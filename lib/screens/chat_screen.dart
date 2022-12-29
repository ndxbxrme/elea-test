import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/helpers/fetch_current_user_data.dart';
import 'package:eleatest/widgets/chat_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/chat_history_list_widget.dart';
import '../widgets/chat_box_widget.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final String chatId;
  final bool isGroup;
  bool needsAccept;
  ChatScreen({
    super.key,
    required this.chatId,
    required this.isGroup,
    required this.needsAccept,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamSubscription<bool> keyboardSubscription;
  final _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //keyboardSubscription.cancel();
    super.dispose();
  }

  final Widget loadingWidget = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(currentUserId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loadingWidget;
          }
          final currentUser = snapshot.data;
          if (currentUser == null) {
            return loadingWidget;
          }
          return FutureBuilder(
              future: fetchCurrentUserData(currentUser),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loadingWidget;
                }
                final currentUser = snapshot.data;
                if (currentUser == null) {
                  return loadingWidget;
                }
                return Scaffold(
                  appBar: AppBar(
                    title: ChatBarWidget(
                      chatId: widget.chatId,
                      currentUser: currentUser,
                    ),
                    actions: <Widget>[
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Profile'),
                          ),
                        ],
                      )
                    ],
                  ),
                  body: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/cartoon-pattern3.png'),
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ChatHistoryListWidget(
                                chatId: widget.chatId,
                                currentUser: currentUser),
                          ),
                          (widget.needsAccept)
                              ? SizedBox(
                                  height: 100,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          child: const Text('Accept'),
                                          onPressed: () async {
                                            //remove current chat invite
                                            await _firestore
                                                .collection('users')
                                                .doc(currentUserId)
                                                .update(
                                              {
                                                (widget.isGroup)
                                                        ? 'groupChatInvites'
                                                        : 'chatInvites':
                                                    FieldValue.arrayRemove(
                                                        [widget.chatId]),
                                              },
                                            );
                                            //add to current user chats
                                            await _firestore
                                                .collection('users')
                                                .doc(currentUserId)
                                                .update(
                                              {
                                                (widget.isGroup)
                                                        ? 'groupChats'
                                                        : 'chats':
                                                    FieldValue.arrayUnion(
                                                        [widget.chatId]),
                                              },
                                            );
                                            await _firestore
                                                .collection('chats')
                                                .doc(widget.chatId)
                                                .update(
                                              {
                                                'participants':
                                                    FieldValue.arrayUnion(
                                                        [currentUserId])
                                              },
                                            );
                                            setState(() {
                                              widget.needsAccept = true;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Decline'),
                                          onPressed: () async {
                                            //remove current chat invite
                                            await _firestore
                                                .collection('users')
                                                .doc(currentUserId)
                                                .update(
                                              {
                                                'chatInvites':
                                                    FieldValue.arrayRemove(
                                                        [widget.chatId]),
                                              },
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ]),
                                )
                              : Container(),
                          SizedBox(
                            height: 100,
                            child: ChatBoxWidget(
                              chatId: widget.chatId,
                              needsAccept: widget.needsAccept,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
