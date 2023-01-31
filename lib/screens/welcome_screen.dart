import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'welcome_screen_1.dart';
import 'welcome_screen_2.dart';
import 'welcome_screen_3.dart';
import 'welcome_screen_4.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 800,
            child: PageView(
              controller: _pageController,
              children: const [
                WelcomeScreen1(),
                WelcomeScreen2(),
                WelcomeScreen3(),
                WelcomeScreen4(),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 4,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Color(0xfff08e57),
              ),
              onDotClicked: (index) {}),
        ],
      ),
    );
  }
}
