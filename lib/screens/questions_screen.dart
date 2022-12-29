import 'package:eleatest/widgets/forum_widget.dart';
import 'package:flutter/cupertino.dart';

class QuestionsScreen extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const QuestionsScreen({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return ForumWidget(
      currentUser: currentUser,
    );
  }
}
