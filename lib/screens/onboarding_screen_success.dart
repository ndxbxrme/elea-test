import 'package:flutter/material.dart';

import '../components/elea_text_button.dart';
import 'home_screen.dart';

class OnboardingScreenSuccess extends StatelessWidget {
  const OnboardingScreenSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: EleaTextButton(
              text: 'Get started',
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
