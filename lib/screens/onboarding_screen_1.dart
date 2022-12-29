import 'package:flutter/material.dart';

import '../widgets/eula_widget.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EulaWidget(),
    );
  }
}
