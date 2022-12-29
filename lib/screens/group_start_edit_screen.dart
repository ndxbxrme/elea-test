import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/elea_text_box.dart';
import '../components/elea_text_button.dart';
import 'chat_screen.dart';

class GroupStartEditScreen extends StatefulWidget {
  const GroupStartEditScreen({
    super.key,
  });

  @override
  State<GroupStartEditScreen> createState() => _GroupStartEditScreenState();
}

class _GroupStartEditScreenState extends State<GroupStartEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final List<String> _selectedFriends = [];
  final List<String> _preselectedFriends = [];
  String _groupName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: EleaTextBox(
                labelText: 'Group chat name',
                initialValue: _groupName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user name';
                  }
                  return null;
                },
                onSaved: (value) => _groupName = (value == null) ? '' : value,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(_currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final currentUser = snapshot.data;
                if (currentUser == null) {
                  return Container();
                }
                final List<dynamic> friends = currentUser['friends'];
                final List<dynamic> blockedUsers = currentUser['blockedUsers'];
                return Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: ((context, index) {
                      final userId = friends[index];
                      if (blockedUsers.contains(userId)) {
                        return Container();
                      }
                      return StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection('users')
                            .doc(userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final user = snapshot.data;
                          if (user == null) {
                            return Container();
                          }
                          final username = user['username'];
                          final avatarUrl = user['avatarUrl'];
                          return CheckboxListTile(
                            value: _selectedFriends.contains(userId),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedFriends.add(userId);
                                } else {
                                  _selectedFriends.remove(userId);
                                }
                              });
                            },
                            secondary: CircleAvatar(
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            title: Text(username),
                          );
                        },
                      );
                    }),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            EleaTextButton(
              text: 'Start group',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    final reference = await FirebaseFirestore.instance
                        .collection('chats')
                        .add({
                      'participants': [_currentUserId],
                      'owner': _currentUserId,
                      'timestamp': Timestamp.now(),
                      'name': _groupName,
                    });
                    final chatId = reference.id;
                    await _firestore
                        .collection('users')
                        .doc(_currentUserId)
                        .update({
                      'groupChats': FieldValue.arrayUnion([chatId]),
                    });
                    Set<String> set2 = _preselectedFriends.toSet();
                    Set<String> set1 = _selectedFriends.toSet();
                    List<String> added = set1.difference(set2).toList();
                    List<String> removed =
                        set2.difference(set1.union(set2)).toList();
                    for (int i = 0; i < added.length; i++) {
                      String userId = added[i];
                      //send this user an invite
                      await _firestore.collection('users').doc(userId).update({
                        'groupChatInvites': FieldValue.arrayUnion([chatId]),
                      });
                    }
                    for (int i = 0; i < removed.length; i++) {
                      String userId = removed[i];
                      //remove from user's invites
                      await _firestore.collection('users').doc(userId).update({
                        'groupChatInvites': FieldValue.arrayRemove([chatId]),
                      });
                      //remove user's groupChats
                      await _firestore.collection('users').doc(userId).update({
                        'groupChats': FieldValue.arrayRemove([chatId]),
                      });
                      //remove user from chat participants
                      await _firestore.collection('chats').doc(chatId).update({
                        'participants': FieldValue.arrayUnion([userId]),
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chatId,
                          isGroup: true,
                          needsAccept: false,
                        ),
                      ),
                    );
                  } catch (error) {
                    debugPrint(error.toString());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
