import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class StartChatWidget extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String userId;
  final String currentUserId;
  final List<dynamic> friends;
  StartChatWidget({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    if (!friends.contains(userId)) {
      return Container();
    }
    return ElevatedButton(
      child: const Text('Start chat'),
      onPressed: () async {
        final reference =
            await FirebaseFirestore.instance.collection('chats').add({
          'participants': [currentUserId],
          'owner': currentUserId,
          'timestamp': Timestamp.now(),
        });
        final uid = reference.id;

        await reference.collection('messages').add({
          'text': 'New conversation',
          'image': null,
          'userId': '0',
          'username': 'bot',
          'timestamp': Timestamp.now(),
        });

        await _firestore.collection('users').doc(userId).update({
          'chatInvites': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(currentUserId).update({
          'chats': FieldValue.arrayUnion([uid]),
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: uid,
              isGroup: false,
              needsAccept: false,
            ),
          ),
        );
      },
    );
  }
}
