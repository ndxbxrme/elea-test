import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/matched_user_actions_widget.dart';

class MatchedUserScreen extends StatefulWidget {
  final String userId;

  const MatchedUserScreen({super.key, required this.userId});

  @override
  State<MatchedUserScreen> createState() => _MatchedUserScreenState();
}

class _MatchedUserScreenState extends State<MatchedUserScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return Container();
        }
        final avatarUrl = user['avatarUrl'];
        final username = user['username'];
        final bio = user['bio'];

        return Scaffold(
          appBar: AppBar(
            title: const Text(''),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                const SizedBox(height: 20),
                Text(username, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
                Text(bio, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                MatchedUserActionsWidget(userId: widget.userId),
              ],
            ),
          ),
        );
      },
    );
  }
}
