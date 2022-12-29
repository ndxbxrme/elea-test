import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import '../screens/matched_user_screen.dart';

class SharedTagsListWidget extends StatelessWidget {
  final String currentUserId;
  final List<dynamic> tags;
  final List<dynamic> friends;
  final List<dynamic> blockedUsers;
  final List<dynamic> invitedUsers;
  final List<dynamic> userInvites;
  SharedTagsListWidget({
    super.key,
    required this.currentUserId,
    required this.tags,
    required this.friends,
    required this.blockedUsers,
    required this.invitedUsers,
    required this.userInvites,
  });

  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getUsersWithSharedTags() async {
    final query = _firestore
        .collection('users')
        .where('tags', arrayContainsAny: tags)
        .orderBy('tags', descending: true);

    final querySnapshot = await query.get();
    final docs =
        querySnapshot.docs.where((doc) => doc.id != currentUserId).where((doc) {
      //final data = doc.data();
      return !friends.contains(doc.id) &&
          !blockedUsers.contains(doc.id) &&
          !invitedUsers.contains(doc.id) &&
          !userInvites.contains(doc.id);
    }).toList();
    return docs.map((doc) {
      final tags = doc.data()['tags'];
      final intersection =
          SplayTreeSet.from(tags).intersection(SplayTreeSet.from(tags)).length;
      return {'data': doc.data(), 'intersection': intersection};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getUsersWithSharedTags(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final users = snapshot.data;

        if (users == null) {
          return Container();
        }
        if (users.isEmpty) {
          return Container();
        }

        return Container(
          decoration: BoxDecoration(color: Colors.red[200]),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Your matched users'),
              Flexible(
                fit: FlexFit.tight,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index]['data'];
                    final intersection = users[index]['intersection'];
                    final username = user['username'];
                    final avatarUrl = user['avatarUrl'];
                    final userId = user['uid'];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      title: Text(username),
                      subtitle: Text('$intersection shared tags'),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
