import 'package:flutter/material.dart';

import '../widgets/groups_widget.dart';

class GroupsScreen extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const GroupsScreen({
    super.key,
    required this.currentUser,
  });
  @override
  Widget build(BuildContext context) {
    return GroupsWidget(
      currentUser: currentUser,
    );
  }
}
