import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_participants_list_widget.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class GroupChatsListWidget extends StatelessWidget {
  final List<dynamic> groupChats;
  final String currentUserId;
  final Map<String, dynamic> currentUser;

  GroupChatsListWidget({
    super.key,
    required this.groupChats,
    required this.currentUserId,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (groupChats.isEmpty) {
      return Container();
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('My groupChats'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: groupChats.length,
              itemBuilder: (context, index) {
                final groupChatId = groupChats[index];
                return StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .doc(groupChatId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final groupChat = snapshot.data;
                    if (groupChat == null) {
                      return Container();
                    }
                    return StreamBuilder(
                      stream: _firestore
                          .collection('chats')
                          .doc(groupChatId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        if (!snapshot.hasData) {
                          return const Text("Loading...");
                        }
                        if (snapshot.data == null) {
                          return Container();
                        }
                        String title = groupChat["name"];
                        Widget subtitle = const Text('No messages yet');
                        if (snapshot.data!.docs.isNotEmpty) {
                          DocumentSnapshot latestMessage =
                              snapshot.data!.docs.first;
                          subtitle = (latestMessage["image"] == null)
                              ? Text(latestMessage["text"])
                              : Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: ClipRRect(
                                    child: Image.network(
                                      latestMessage["image"],
                                    ),
                                  ),
                                );
                        }
                        // Get the latest message
                        // Return the message widget
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              leading: SizedBox(
                                width: 50,
                                child: ChatParticipantsListWidget(
                                  participants: groupChat["participants"],
                                  currentUserId: currentUserId,
                                  blockedUsers: currentUser["blockedUsers"],
                                  currentUser: currentUser,
                                ),
                              ),
                              title: Text(title),
                              subtitle: subtitle,
                              onTap: () async {
                                //redirect to groupChat screen
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      chatId: groupChatId,
                                      isGroup: true,
                                      needsAccept: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
