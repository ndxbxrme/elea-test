import 'package:eleatest/widgets/group_chat_invites_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/group_start_edit_screen.dart';
import 'friends_list_widget.dart';
import 'group_chats_list_widget.dart';

class GroupsWidget extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  const GroupsWidget({
    super.key,
    required this.currentUser,
  });
  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final List<dynamic> blockedUsers = currentUser['blockedUsers'];
    final List<dynamic> friends = currentUser['friends'];
    final List<dynamic> groupChatInvites = currentUser['groupChatInvites'];
    final List<dynamic> groupChats = currentUser['groupChats'];
    //final List<dynamic> chatInvites = currentUser['chatInvites'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GroupsChatInvitesListWidget(
          groupChatInvites: groupChatInvites,
          currentUserId: _currentUserId,
          currentUser: currentUser,
        ),
        FriendsListWidget(
          currentUserId: _currentUserId,
          blockedUsers: blockedUsers,
          friends: friends,
        ),
        ElevatedButton(
          child: const Text('Start group chat'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GroupStartEditScreen(),
              ),
            );
          },
        ),
        GroupChatsListWidget(
          groupChats: groupChats,
          currentUserId: _currentUserId,
          currentUser: currentUser,
        ),
      ],
    );
  }
}
