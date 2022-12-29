import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/matched_user_screen.dart';

class InvitedUsersListWidget extends StatelessWidget {
  final List<dynamic> invitedUsers;
  final List<dynamic> blockedUsers;
  final _firestore = FirebaseFirestore.instance;
  InvitedUsersListWidget(
      {super.key, required this.invitedUsers, required this.blockedUsers});
  @override
  Widget build(BuildContext context) {
    if (invitedUsers.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: invitedUsers.length,
        itemBuilder: (context, index) {
          final userId = invitedUsers[index];
          if (blockedUsers.contains(userId)) {
            return Container();
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('users').doc(userId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final user = snapshot.data;
              if (user == null) {
                return Container();
              }
              final username = user['username'];
              final avatarUrl = user['avatarUrl'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                title: Text(username),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchedUserScreen(userId: userId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
