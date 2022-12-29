import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String userId;

  const UserAvatarWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data;
        if (user == null) {
          return Container();
        }
        final String avatarUrl = user['avatarUrl'];
        return ClipOval(
          child: Image.network(
            avatarUrl,
            width: 16,
            height: 16,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
