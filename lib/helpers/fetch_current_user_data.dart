import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> allFriends = {};
final List<Color> colors = [
  const Color.fromRGBO(229, 213, 222, 1),
  const Color.fromRGBO(220, 199, 193, 1),
  const Color.fromRGBO(203, 191, 173, 1),
  const Color.fromRGBO(179, 218, 210, 1),
];

Future<Map<String, dynamic>> fetchCurrentUserData(DocumentSnapshot user) async {
  if (!user.exists) {
    return {};
  }
  Map<String, dynamic> currentUser = user.data() as Map<String, dynamic>;
  currentUser['friendMap'] = {};
  final friends = user['friends'];
  // Loop through the friends array
  var i = 0;
  for (String friendId in friends) {
    if (allFriends[friendId] != null) {
      currentUser['friendMap'][friendId] = allFriends[friendId];
    } else {
      // Get the document for the friend with the given id
      final friendSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();
      final friend = friendSnapshot.data();
      if (friend == null) {
        continue;
      }
      // Get the friend's username and avatarUrl
      String username = friend['username'];
      String avatarUrl = friend['avatarUrl'];

      // Generate a random pastel color for the friend
      Color color = colors[i++ % colors.length];

      final newUser = {
        'username': username,
        'avatarUrl': avatarUrl,
        'color': color,
      };

      // Add the friend's data to the Map
      allFriends[friendId] = newUser;
      currentUser['friendMap'][friendId] = newUser;
    }
  }
  return currentUser;
}
