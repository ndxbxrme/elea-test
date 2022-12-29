import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_participants_list_widget.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class GroupsChatInvitesListWidget extends StatelessWidget {
  final List<dynamic> groupChatInvites;
  final String currentUserId;
  final Map<String, dynamic> currentUser;
  GroupsChatInvitesListWidget({
    super.key,
    required this.groupChatInvites,
    required this.currentUserId,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (groupChatInvites.isEmpty) {
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
              itemCount: groupChatInvites.length,
              itemBuilder: (context, index) {
                final groupChatId = groupChatInvites[index];
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
                    return ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: ChatParticipantsListWidget(
                          participants: groupChat["participants"],
                          currentUserId: currentUserId,
                          blockedUsers: currentUser["blockedUsers"],
                          currentUser: currentUser,
                        ),
                      ),
                      title: const Text('Group chat invite'),
                      onTap: () async {
                        //redirect to chat screen
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: groupChatId,
                              isGroup: true,
                              needsAccept: true,
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
