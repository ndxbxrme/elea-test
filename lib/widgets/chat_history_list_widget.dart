import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'chat_message_widget.dart';
import 'chat_date_widget.dart';

class ChatHistoryListWidget extends StatefulWidget {
  final String chatId;
  final Map<String, dynamic> currentUser;
  const ChatHistoryListWidget(
      {super.key, required this.chatId, required this.currentUser});

  @override
  State<ChatHistoryListWidget> createState() => _ChatHistoryListWidgetState();
}

class _ChatHistoryListWidgetState extends State<ChatHistoryListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledUp = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isScrolledUp = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs.reversed.toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            controller: _scrollController,
            reverse: true,
            separatorBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox.shrink();
              }

              final message = messages[index - 1];
              final previousMessage = messages[index];
              final difference = message
                  .get('timestamp')
                  .toDate()
                  .difference(previousMessage.get('timestamp').toDate());

              if (difference.inHours >= 1) {
                return ChatDateWidget(
                  date: message.get('timestamp').toDate(),
                );
              }

              return const SizedBox.shrink();
            },
            itemCount: messages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _isScrolledUp
                    ? IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      )
                    : const SizedBox.shrink();
              }

              final message = messages[index - 1];
              return ChatMessageWidget(
                messageText: message['text'],
                messageTimestamp: message['timestamp'],
                messageUserId: message['userId'],
                messageId: message.id,
                image: message['image'],
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                currentUser: widget.currentUser,
                onReply: (messageId) {
                  print(messageId);
                },
                onEdit: (messageId) {
                  print(messageId);
                },
                onDelete: (messageId) {
                  print(messageId);
                },
              );
            },
          ),
        );
      },
    );
  }
}
