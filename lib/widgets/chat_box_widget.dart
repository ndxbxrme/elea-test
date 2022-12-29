import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/chat_image_uploader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ChatBoxWidget extends StatefulWidget {
  final String chatId;
  final bool needsAccept;
  // TODO update to use current user

  const ChatBoxWidget({
    super.key,
    required this.chatId,
    required this.needsAccept,
  });

  @override
  State<ChatBoxWidget> createState() => _ChatBoxWidgetState();
}

class _ChatBoxWidgetState extends State<ChatBoxWidget> {
  final _textController = TextEditingController();
  final filter = ProfanityFilter();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _textController,
                    enabled: !widget.needsAccept,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (value) async {
                      if (value.trim().isNotEmpty) {
                        final userRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        final snapshot = await userRef.get();
                        final user = snapshot.data();
                        if (user == null) return;
                        await FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.chatId)
                            .collection('messages')
                            .add({
                          'text': filter.censor(value.trim()),
                          'image': null,
                          'userId': user['uid'],
                          'username': user['username'],
                          'timestamp': Timestamp.now(),
                        });
                        _textController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ChatImageUploaderWidget(
              chatId: widget.chatId,
              needsAccept: widget.needsAccept,
            ),
          ],
        ),
      ),
    );
  }
}
