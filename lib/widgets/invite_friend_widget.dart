import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InviteFriendWidget extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String userId;
  final String currentUserId;
  final List<dynamic> invitedUsers;
  final List<dynamic> userInvites;
  final List<dynamic> blockedUsers;
  final List<dynamic> friends;
  InviteFriendWidget({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.invitedUsers,
    required this.userInvites,
    required this.blockedUsers,
    required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    if (invitedUsers.contains(userId) ||
        blockedUsers.contains(userId) ||
        friends.contains(userId) ||
        userInvites.contains(userId)) {
      if (userInvites.contains(userId)) {
        return ElevatedButton(
            child: const Text('Accept Invite'),
            onPressed: () async {
              await _firestore.collection('users').doc(currentUserId).update({
                'userInvites': FieldValue.arrayRemove([userId]),
              });
              await _firestore.collection('users').doc(userId).update({
                'invitedUsers': FieldValue.arrayRemove([currentUserId]),
              });
              await _firestore.collection('users').doc(currentUserId).update({
                'friends': FieldValue.arrayUnion([userId]),
              });
              await _firestore.collection('users').doc(userId).update({
                'friends': FieldValue.arrayUnion([currentUserId]),
              });
            });
      }
      return Container();
    }

    return ElevatedButton(
      child: const Text('Invite Friend'),
      onPressed: () async {
        await _firestore.collection('users').doc(currentUserId).update({
          'invitedUsers': FieldValue.arrayUnion([userId]),
        });

        await _firestore.collection('users').doc(userId).update({
          'userInvites': FieldValue.arrayUnion([currentUserId]),
        });
      },
    );
  }
}
