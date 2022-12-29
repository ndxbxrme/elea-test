import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/onboarding_screen_success.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final bool onboarding;
  const NotificationSettingsWidget({
    super.key,
    required this.onboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text('Notification settings'),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('onboardingComplete', true);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreenSuccess(),
            ),
          );
        },
      ),
    );
  }
}
