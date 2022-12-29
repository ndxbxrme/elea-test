import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportUserWidget extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String userId;
  final String currentUserId;
  final List<dynamic> blockedUsers;
  ReportUserWidget({
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
      child: const Text('Report User'),
      onPressed: () async {
        await _firestore.collection('users').doc(currentUserId).update({
          'blockedUsers': FieldValue.arrayUnion([userId]),
        });
        await FirebaseFirestore.instance.collection('reportedUsers').add({
          'reportedUser': userId,
          'currentUser': currentUserId,
          'timestamp': Timestamp.now(),
        });
      },
    );
  }
}
