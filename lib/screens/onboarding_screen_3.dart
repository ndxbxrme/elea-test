import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/keyboard_safe_view_widget.dart';
import '../widgets/tag_selector_widget.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: KeyboardSafeViewWidget(
          child: Center(
            child: TagSelectorWidget(
                userId: FirebaseAuth.instance.currentUser!.uid,
                onboarding: true),
          ),
        ),
      ),
    );
  }
}
