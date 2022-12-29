import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatParticipantsListWidget extends StatelessWidget {
  final List<dynamic> participants;
  final String currentUserId;
  final List<dynamic> blockedUsers;
  final Map<String, dynamic> currentUser;

  ChatParticipantsListWidget({
    super.key,
    required this.participants,
    required this.currentUserId,
    required this.blockedUsers,
    required this.currentUser,
  });

  final _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getDocumentsById(List<dynamic> ids) async {
    List<DocumentSnapshot> documents = [];
    for (String id in ids) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      documents.add(doc);
    }
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    final otherParticipants = participants
        .where((id) => id != currentUserId && !blockedUsers.contains(id))
        .toList();
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < otherParticipants.length; i++)
              // Check if currentUser["friendMap"][otherParticipants[i]] exists
              (currentUser["friendMap"][otherParticipants[i]] != null)
                  ? Align(
                      widthFactor: 0.5,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: currentUser["friendMap"]
                            [otherParticipants[i]]["color"],
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(currentUser["friendMap"]
                              [otherParticipants[i]]["avatarUrl"]),
                        ),
                      ),
                    )
                  : const Align(
                      widthFactor: 0.5,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
          ],
        ),
      ],
    );
  }
}
