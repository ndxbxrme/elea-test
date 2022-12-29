import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/components/elea_text_box.dart';
import 'package:eleatest/components/elea_text_button.dart';
import 'package:eleatest/helpers/fetch_post_details.dart';
import 'package:eleatest/widgets/keyboard_safe_view_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profanity_filter/profanity_filter.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ForumPostScreen extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  final String postId;
  final String threadId;
  const ForumPostScreen({
    super.key,
    required this.currentUser,
    required this.postId,
    required this.threadId,
  });
  @override
  State<ForumPostScreen> createState() => _ForumPostScreenState();
}

class _ForumPostScreenState extends State<ForumPostScreen>
    with SingleTickerProviderStateMixin {
  final filter = ProfanityFilter();
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late DocumentSnapshot<Object?> _post;
  late String _text;
  bool replying = false;
  bool liked = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: KeyboardSafeViewWidget(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(12.0),
              child: FutureBuilder(
                future: fetchPostDetails(widget.threadId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final thread = snapshot.data;
                  if (thread == null) {
                    return const CircularProgressIndicator();
                  }
                  return StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('posts')
                        .doc(widget.postId)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var post = snapshot.data;
                      if (post == null) {
                        return const CircularProgressIndicator();
                      }
                      _post = post;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Topic: " + thread["title"]),
                          SizedBox(height: 10.0),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(post["avatarUrl"]),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Posted by: " + post["username"]),
                                    Text(DateFormat("dd MMM, HH:mm")
                                        .format(post["timestamp"].toDate())),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(post["post"]),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (liked) {
                                          liked = false;
                                          _controller.reverse();
                                        } else {
                                          liked = true;
                                          _controller.forward();
                                        }
                                      },
                                      child: Container(
                                        child: Align(
                                          heightFactor: 0.5,
                                          widthFactor: 0.5,
                                          child: Lottie.network(
                                              'https://assets1.lottiefiles.com/private_files/lf30_kpak4iic.json',
                                              controller: _controller,
                                              repeat: false,
                                              width: 80),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: (post["numSubposts"] == 0)
                                            ? Colors.grey[400]
                                            : Colors.amber[400],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                          post["numSubposts"].toString() +
                                              ((post["numSubposts"] == 1)
                                                  ? " Reply"
                                                  : " Replies")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
            if (replying)
              Form(
                key: _formKey,
                child: EleaTextBox(
                  labelText: 'Reply',
                  minLines: 10,
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a thread';
                    }
                    return null;
                  },
                  onSaved: (value) => _text = (value == null) ? '' : value,
                ),
              ),
            const SizedBox(height: 10),
            (replying)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: EleaTextButton(
                            text: 'Cancel',
                            onPressed: () {
                              setState(() {
                                replying = false;
                              });
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: EleaTextButton(
                          text: 'Post reply',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                final postRef = await FirebaseFirestore.instance
                                    .collection('posts')
                                    .add({
                                  'owner': _currentUserId,
                                  'avatarUrl': widget.currentUser["avatarUrl"],
                                  'username': widget.currentUser["username"],
                                  'title': '',
                                  'post': filter.censor(_text.trim()),
                                  'tags': _post["tags"],
                                  'timestamp': Timestamp.now(),
                                  'threadId': (_post["threadId"] == '0')
                                      ? _post.id
                                      : _post["threadId"],
                                  'parentId': _post.id,
                                  'images': [],
                                  'likes': 0,
                                  'status': 'active',
                                  'numSubposts': 0,
                                });
                                FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(_post.id)
                                    .update({
                                  'numSubposts': FieldValue.increment(1),
                                });
                                final userDocRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_currentUserId);
                                await userDocRef.update({
                                  'posts': FieldValue.arrayUnion([
                                    postRef.id,
                                    _post.id,
                                    _post["threadId"]
                                  ]),
                                  'numThreads': FieldValue.increment(1),
                                  'numPosts': FieldValue.increment(1),
                                });
                                setState(() {
                                  replying = false;
                                });
                              } catch (error) {
                                debugPrint(error.toString());
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : EleaTextButton(
                    text: 'Reply',
                    onPressed: () {
                      setState(() {
                        replying = true;
                      });
                    },
                  ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('threadId', isEqualTo: widget.threadId)
                  .where('parentId', isEqualTo: widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return const Text("Loading...");
                }
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Posted by: " + document["username"]),
                                      Text(DateFormat("dd MMM, HH:mm").format(
                                          document["timestamp"].toDate())),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(document["post"]),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(""),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: (document["numSubposts"] == 0)
                                              ? Colors.grey[400]
                                              : Colors.amber[400],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            document["numSubposts"].toString() +
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
                                      currentUser: widget.currentUser,
                                      postId: document.id,
                                      threadId: (document["threadId"] == '0')
                                          ? document.id
                                          : document["threadId"],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
