import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'welcome_screen_1.dart';
import 'welcome_screen_2.dart';
import 'welcome_screen_3.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_fjv8qxqn.json'),
          ),
          PageView(
            controller: _pageController,
            children: const [
              WelcomeScreen1(),
              WelcomeScreen2(),
              WelcomeScreen3(),
            ],
          ),
        ],
      ),
    );
  }
}
