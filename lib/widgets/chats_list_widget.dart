import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_participants_list_widget.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatsListWidget extends StatelessWidget {
  final List<dynamic> chats;
  final String currentUserId;
  final List<dynamic> blockedUsers;
  final Map<String, dynamic> currentUser;
  ChatsListWidget({
    super.key,
    required this.chats,
    required this.currentUserId,
    required this.blockedUsers,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return Container();
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('My chats'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chatId = chats[index];
                return StreamBuilder<DocumentSnapshot>(
                  stream:
                      _firestore.collection('chats').doc(chatId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final chat = snapshot.data;
                    if (chat == null) {
                      return Container();
                    }
                    return StreamBuilder(
                      stream: _firestore
                          .collection('chats')
                          .doc(chatId)
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
                        // Get the latest message
                        DocumentSnapshot latestMessage =
                            snapshot.data!.docs.first;
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
                                  participants: chat["participants"],
                                  currentUserId: currentUserId,
                                  blockedUsers: blockedUsers,
                                  currentUser: currentUser,
                                ),
                              ),
                              title: (currentUserId == latestMessage["userId"])
                                  ? const Text('me')
                                  : (currentUser["friendMap"]
                                              [latestMessage["userId"]] !=
                                          null)
                                      ? Text(currentUser["friendMap"]
                                          [latestMessage["userId"]]["username"])
                                      : Container(),
                              subtitle: (latestMessage["image"] == null)
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
                                    ),
                              onTap: () async {
                                //redirect to chat screen
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      chatId: chatId,
                                      isGroup: false,
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
