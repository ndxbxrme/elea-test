import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/screens/forum_post_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ForumThreadListWidget extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  final String selectedTag;
  const ForumThreadListWidget({
    super.key,
    required this.currentUser,
    required this.selectedTag,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (selectedTag == 'All topics')
          ? FirebaseFirestore.instance
              .collection('posts')
              .where('threadId', isEqualTo: '0')
              .where('parentId', isEqualTo: '0')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('posts')
              .where('threadId', isEqualTo: '0')
              .where('parentId', isEqualTo: '0')
              .where('tags', arrayContains: selectedTag)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return const Text("Loading...");
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text("No questions here");
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      document["avatarUrl"],
                    ),
                  ),
                  title: Text(document["title"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Posted by: ',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text: document["username"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat("dd MMM, HH:mm")
                                .format(document["timestamp"].toDate()),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(document["post"]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(""),
                          Container(
                            decoration: BoxDecoration(
                              color: (document["numSubposts"] == 0)
                                  ? Colors.grey[400]
                                  : Colors.amber[400],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: Text(document["numSubposts"].toString() +
                                ((document["numSubposts"] == 1)
                                    ? " Reply"
                                    : " Replies")),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumPostScreen(
                          currentUser: currentUser,
                          postId: document.id,
                          threadId: (document["threadId"] == '0')
                              ? document.id
                              : document["threadId"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
