import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/matched_user_screen.dart';

class UserInvitesListWidget extends StatelessWidget {
  final String currentUserId;
  final List<dynamic> blockedUsers;
  final List<dynamic> userInvites;
  UserInvitesListWidget({
    super.key,
    required this.currentUserId,
    required this.blockedUsers,
    required this.userInvites,
  });
  final _firestore = FirebaseFirestore.instance;

  // Replace this with the current user's ID
  @override
  Widget build(BuildContext context) {
    if (userInvites.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Friend requests'),
          const SizedBox(height: 10),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemCount: userInvites.length,
              itemBuilder: (context, index) {
                final userId = userInvites[index];
                if (blockedUsers.contains(userId)) {
                  return Container();
                }

                return StreamBuilder<DocumentSnapshot>(
                  stream:
                      _firestore.collection('users').doc(userId).snapshots(),
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
                            builder: (context) =>
                                MatchedUserScreen(userId: userId),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
