import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTagsWidget extends StatelessWidget {
  final String userId;
  final List<dynamic> currentUserTags;

  const UserTagsWidget({
    super.key,
    required this.userId,
    required this.currentUserTags,
  });

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
        final List<dynamic> userTags = user['tags'];
        return SizedBox(
          height: 42,
          child: Center(
            child: ListView.builder(
              itemCount: userTags.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final tag = userTags[index];
                final capitalizedTag =
                    '${tag[0].toUpperCase()}${tag.substring(1)}';
                final color = currentUserTags.contains(tag)
                    ? Colors.green
                    : Colors.grey[400];
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        capitalizedTag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
