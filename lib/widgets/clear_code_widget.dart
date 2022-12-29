import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearCodeWidget extends StatelessWidget {
  final Function updateState;

  const ClearCodeWidget({super.key, required this.updateState});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Clear code'),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('waitingForCode', false);
        prefs.setString('email', '');
        prefs.setString('code', '');
        // Update the state of the LoginScreen
        updateState(() {});
      },
    );
  }
}
