import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/matched_user_screen.dart';

class FriendsListWidget extends StatelessWidget {
  final String currentUserId;
  final List<dynamic> blockedUsers;
  final List<dynamic> friends;
  FriendsListWidget({
    super.key,
    required this.currentUserId,
    required this.blockedUsers,
    required this.friends,
  });

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          const Text('Friends'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final userId = friends[index];
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
                    final avatarUrl = user['avatarUrl'];

                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
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
