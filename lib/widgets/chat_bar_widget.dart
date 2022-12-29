import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_participants_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBarWidget extends StatelessWidget {
  final String chatId;
  final Map<String, dynamic> currentUser;
  ChatBarWidget({
    super.key,
    required this.chatId,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('chats').doc(chatId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final chat = snapshot.data;
          if (chat == null) {
            return Container();
          }
          final participants = chat["participants"];
          final blockedUsers = [];
          return SizedBox(
              width: 100,
              child: ChatParticipantsListWidget(
                currentUserId: currentUserId,
                participants: participants,
                blockedUsers: blockedUsers,
                currentUser: currentUser,
              ));
        });
  }
}
