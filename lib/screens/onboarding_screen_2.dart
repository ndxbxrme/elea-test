import 'package:eleatest/widgets/keyboard_safe_view_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/edit_profile_widget.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: const SafeArea(
        child: KeyboardSafeViewWidget(
          child: Center(
            child: EditProfileWidget(onboarding: true),
          ),
        ),
      ),
    );
  }
}
