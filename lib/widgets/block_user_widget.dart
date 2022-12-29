import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockUserWidget extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String userId;
  final String currentUserId;
  final List<dynamic> blockedUsers;
  BlockUserWidget({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.blockedUsers,
  });

  @override
  Widget build(BuildContext context) {
    if (blockedUsers.contains(userId)) {
      return Container();
    }
    return ElevatedButton(
      child: const Text('Block User'),
      onPressed: () async {
        await _firestore.collection('users').doc(currentUserId).update({
          'blockedUsers': FieldValue.arrayUnion([userId]),
        });
      },
    );
  }
}
