import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_participants_list_widget.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatInvitesListWidget extends StatelessWidget {
  final List<dynamic> chatInvites;
  final String currentUserId;
  final List<dynamic> blockedUsers;
  final Map<String, dynamic> currentUser;

  ChatInvitesListWidget({
    super.key,
    required this.chatInvites,
    required this.currentUserId,
    required this.blockedUsers,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (chatInvites.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemCount: chatInvites.length,
              itemBuilder: (context, index) {
                final chatId = chatInvites[index];
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
                      return ListTile(
                          leading: SizedBox(
                            width: 100,
                            child: ChatParticipantsListWidget(
                              participants: chat["participants"],
                              currentUserId: currentUserId,
                              blockedUsers: blockedUsers,
                              currentUser: currentUser,
                            ),
                          ),
                          title: const Text('hey'),
                          onTap: () async {
                            //redirect to chat screen
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chatId,
                                  isGroup: false,
                                  needsAccept: true,
                                ),
                              ),
                            );
                          });
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
