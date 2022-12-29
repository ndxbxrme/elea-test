import 'package:eleatest/widgets/notification_settings_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotificationSettingsWidget(
        onboarding: true,
      ),
    );
  }
}
