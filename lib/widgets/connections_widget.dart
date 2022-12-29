import 'package:eleatest/widgets/chat_invites_list_widget.dart';
import 'package:eleatest/widgets/chats_list_widget.dart';
import 'package:eleatest/widgets/friends_list_widget.dart';
import 'package:eleatest/widgets/invited_users_list_widget.dart';
import 'package:eleatest/widgets/shared_tags_list_widget.dart';
import 'package:eleatest/widgets/user_invites_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConnectionsWidget extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> currentUser;
  const ConnectionsWidget(
      {super.key, required this.userId, required this.currentUser});

  @override
  State<ConnectionsWidget> createState() => _ConnectionsWidgetState();
}

class _ConnectionsWidgetState extends State<ConnectionsWidget> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final List<dynamic> invitedUsers = currentUser['invitedUsers'];
    final List<dynamic> userInvites = currentUser['userInvites'];
    final List<dynamic> blockedUsers = currentUser['blockedUsers'];
    final List<dynamic> friends = currentUser['friends'];
    final List<dynamic> tags = currentUser['tags'];
    final List<dynamic> chatInvites = currentUser['chatInvites'];
    final List<dynamic> chats = currentUser['chats'];
    //final List<dynamic> chatInvites = currentUser['chatInvites'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SharedTagsListWidget(
          currentUserId: _currentUserId,
          tags: tags,
          friends: friends,
          blockedUsers: blockedUsers,
          invitedUsers: invitedUsers,
          userInvites: userInvites,
        ),
        UserInvitesListWidget(
          currentUserId: _currentUserId,
          blockedUsers: blockedUsers,
          userInvites: userInvites,
        ),
        InvitedUsersListWidget(
          invitedUsers: invitedUsers,
          blockedUsers: blockedUsers,
        ),
        ChatInvitesListWidget(
          blockedUsers: blockedUsers,
          currentUserId: _currentUserId,
          chatInvites: chatInvites,
          currentUser: currentUser,
        ),
        FriendsListWidget(
          currentUserId: _currentUserId,
          blockedUsers: blockedUsers,
          friends: friends,
        ),
        ChatsListWidget(
          chats: chats,
          currentUserId: _currentUserId,
          blockedUsers: blockedUsers,
          currentUser: currentUser,
        ),
      ],
    );
  }
}
