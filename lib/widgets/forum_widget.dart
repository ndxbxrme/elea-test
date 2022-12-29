import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/forum_thread_list_widget.dart';
import 'package:flutter/material.dart';

import '../screens/forum_thread_start_edit_screen.dart';

class ForumWidget extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  const ForumWidget({super.key, required this.currentUser});

  @override
  State<ForumWidget> createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {
  String selectedTag = "All topics";
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('tags').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final tags = snapshot.data!.docs;
                if (tags.isEmpty) {
                  return Container();
                }
                List<String> tagNames = [
                  for (var snapshot in tags) snapshot.data()["name"]
                ];
                sortTags(tagNames, widget.currentUser["tags"]);
                tagNames.insert(0, 'All topics');
                return Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.deepPurple[600]),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tagNames.length,
                    itemBuilder: (context, index) {
                      final tag = tagNames[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTag = tag;
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: (tag == selectedTag)
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  capitalize(tag),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: (tag == selectedTag)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: ForumThreadListWidget(
                currentUser: widget.currentUser,
                selectedTag: selectedTag,
              ),
            )
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForumThreadStartEditScreen(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

void sortTags(List<String> tags, List<dynamic> userTags) {
  tags.sort((a, b) {
    if (userTags.contains(a) && !userTags.contains(b)) {
      return -1;
    } else if (userTags.contains(b) && !userTags.contains(a)) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  });
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
