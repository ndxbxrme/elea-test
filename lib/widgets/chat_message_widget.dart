import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/full_size_image_screen.dart';

class ChatMessageWidget extends StatelessWidget {
  final String messageText;
  final String? image;
  final Timestamp messageTimestamp;
  final String messageUserId;
  final String currentUserId;
  final String messageId;
  final Map<String, dynamic> currentUser;
  final Function(String) onReply;
  final Function(String) onDelete;
  final Function(String) onEdit;

  const ChatMessageWidget(
      {super.key,
      required this.messageText,
      required this.messageTimestamp,
      required this.messageUserId,
      required this.currentUserId,
      required this.currentUser,
      required this.messageId,
      required this.onReply,
      required this.onDelete,
      required this.onEdit,
      this.image});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = messageUserId == currentUserId;
    final timestamp = messageTimestamp.toDate();
    final timeString = "${timestamp.hour}:${timestamp.minute}";
    Offset tapPosition = Offset.zero;
    return messageUserId == "0"
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: isCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTapDown: (details) {
                    tapPosition = details.globalPosition;
                  },
                  onLongPress: () {
                    print('longpressin freak');
                    Offset offset = tapPosition;
                    RelativeRect rect = RelativeRect.fromLTRB(
                        offset.dx, offset.dy, offset.dx, offset.dy);
                    showMenu(
                      context: context,
                      position: rect,
                      items: [
                        PopupMenuItem(
                          value: 1,
                          child: Text('Reply'),
                        ),
                        if (isCurrentUser)
                          PopupMenuItem(
                            value: 2,
                            child: Text('Edit'),
                          ),
                        if (isCurrentUser)
                          PopupMenuItem(
                            value: 3,
                            child: Text('Delete'),
                          ),
                      ],
                    ).then((value) {
                      if (value == 1) {
                        onReply(messageId);
                      }
                      if (value == 2) {
                        onEdit(messageId);
                      }
                      if (value == 3) {
                        onDelete(messageId);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? Colors.grey[300]
                          : (currentUser["friendMap"][messageUserId] != null)
                              ? currentUser["friendMap"][messageUserId]["color"]
                              : Colors.blue[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        if (image == null)
                          Text(
                            messageText,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        if (image != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullSizeImageScreen(
                                      imageUrl: image.toString()),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(image.toString(),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        const SizedBox(height: 4.0),
                        isCurrentUser
                            ? Text(
                                timeString,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timeString,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(
                                        currentUser["friendMap"][messageUserId]
                                            ["avatarUrl"]),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: isCurrentUser ? 8.0 : 16.0),
              ],
            ),
          );
  }
}
