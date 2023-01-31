import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen3 extends StatefulWidget {
  const WelcomeScreen3({super.key});

  @override
  State<WelcomeScreen3> createState() => _WelcomeScreen3State();
}

class _WelcomeScreen3State extends State<WelcomeScreen3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(40),
          alignment: Alignment.center,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  'Just enter your age, gender and health concerns and elea will match you with someone who knows what you\'re going through.',
              style: TextStyle(
                color: Color(0xff344f4f),
                fontSize: 42,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
