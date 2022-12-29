import 'package:eleatest/widgets/edit_profile_widget.dart';
import 'package:eleatest/widgets/keyboard_safe_view_widget.dart';
import 'package:eleatest/widgets/notification_settings_widget.dart';
import 'package:eleatest/widgets/tag_selector_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _currentIndex = 0;
  final List<IconData> _icons = [
    Icons.person,
    Icons.group,
    Icons.question_answer,
  ];
  final List<String> _labels = [
    "Profile",
    "Tags",
    "Notifications",
  ];
  final List<Widget> screens = [
    EditProfileWidget(
      onboarding: false,
    ),
    TagSelectorWidget(
      userId: FirebaseAuth.instance.currentUser!.uid,
      onboarding: false,
    ),
    NotificationSettingsWidget(
      onboarding: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: KeyboardSafeViewWidget(
        child: SafeArea(
          child: screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Set the current index to the selected item's index
        currentIndex: _currentIndex,
        // Set the type of the bottom navigation bar
        type: BottomNavigationBarType.fixed,
        // Set the items of the bottom navigation bar
        items: [
          for (int i = 0; i < _labels.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_icons[i]),
              label: _labels[i],
            ),
        ],
        // Set the onTap callback
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
