import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/components/elea_text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../components/elea_text_button.dart';

class ForumThreadStartEditScreen extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  const ForumThreadStartEditScreen({super.key, required this.currentUser});

  @override
  State<ForumThreadStartEditScreen> createState() =>
      _ForumThreadStartEditScreenState();
}

class _ForumThreadStartEditScreenState
    extends State<ForumThreadStartEditScreen> {
  final filter = ProfanityFilter();
  final _formKey = GlobalKey<FormState>();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late String _title;
  late String _post;
  final _tags = <String>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EleaTextBox(
                    labelText: 'Thread title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a thread title';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = (value == null) ? '' : value,
                  ),
                  const SizedBox(height: 10),
                  EleaTextBox(
                    labelText: 'Thread body',
                    minLines: 10,
                    maxLines: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a thread';
                      }
                      return null;
                    },
                    onSaved: (value) => _post = (value == null) ? '' : value,
                  ),
                  SizedBox(
                    height: 200,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tags')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data == null) {
                          return Container();
                        }
                        final tags = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            final tag = tags[index];
                            final tagName = tag['name'];
                            return CheckboxListTile(
                              value: _tags.contains(tagName),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _tags.add(tagName);
                                  } else {
                                    _tags.remove(tagName);
                                  }
                                });
                              },
                              title: Text(tagName),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  EleaTextButton(
                    text: 'Start thread',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          final postRef = await FirebaseFirestore.instance
                              .collection('posts')
                              .add({
                            'owner': _currentUserId,
                            'avatarUrl': widget.currentUser["avatarUrl"],
                            'username': widget.currentUser["username"],
                            'title': filter.censor(_title.trim()),
                            'post': filter.censor(_post.trim()),
                            'tags': _tags.toList(),
                            'timestamp': Timestamp.now(),
                            'threadId': '0',
                            'parentId': '0',
                            'images': [],
                            'likes': 0,
                            'status': 'active',
                            'numSubposts': 0,
                          });
                          final userDocRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(_currentUserId);
                          await userDocRef.update({
                            'posts': FieldValue.arrayUnion([postRef.id]),
                            'numThreads': FieldValue.increment(1),
                            'numPosts': FieldValue.increment(1),
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (error) {
                          debugPrint(error.toString());
                        }
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
