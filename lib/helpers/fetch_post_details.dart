import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> fetchPostDetails(String postId) async {
  final postSnapshot =
      await FirebaseFirestore.instance.collection('posts').doc(postId).get();
  if (!postSnapshot.exists) {
    return {};
  }
  final post = postSnapshot.data();
  if (post == null) {
    return {};
  }
  return {
    'title': post["title"],
    'avatarUrl': post["avatarUrl"],
    'username': post["username"],
    'timestamp': post["timestamp"],
    'numSubposts': post["numSubposts"],
  };
}
