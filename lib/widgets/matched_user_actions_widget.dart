import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/report_user_widget.dart';
import 'package:eleatest/widgets/start_chat_widget.dart';
import 'package:eleatest/widgets/user_tags_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'block_user_widget.dart';
import 'invite_friend_widget.dart';

class MatchedUserActionsWidget extends StatefulWidget {
  final String userId;
  const MatchedUserActionsWidget({super.key, required this.userId});

  @override
  State<MatchedUserActionsWidget> createState() =>
      _MatchedUserActionsWidgetState();
}

class _MatchedUserActionsWidgetState extends State<MatchedUserActionsWidget> {
  final _firestore = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(_currentUserId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final currentUser = snapshot.data;
        if (currentUser == null) {
          return Container();
        }
        final List<dynamic> invitedUsers = currentUser['invitedUsers'];
        final List<dynamic> userInvites = currentUser['userInvites'];
        final List<dynamic> blockedUsers = currentUser['blockedUsers'];
        final List<dynamic> friends = currentUser['friends'];
        final List<dynamic> tags = currentUser['tags'];
        return Column(
          children: [
            UserTagsWidget(
              userId: widget.userId,
              currentUserTags: tags,
            ),
            InviteFriendWidget(
              userId: widget.userId,
              currentUserId: _currentUserId,
              invitedUsers: invitedUsers,
              userInvites: userInvites,
              blockedUsers: blockedUsers,
              friends: friends,
            ),
            StartChatWidget(
              userId: widget.userId,
              currentUserId: _currentUserId,
              friends: friends,
            ),
            BlockUserWidget(
              userId: widget.userId,
              currentUserId: _currentUserId,
              blockedUsers: blockedUsers,
            ),
            ReportUserWidget(
              userId: widget.userId,
              currentUserId: _currentUserId,
              blockedUsers: blockedUsers,
            )
          ],
        );
      },
    );
  }
}
