import 'package:flutter/material.dart';
import '../components/elea_text_button.dart';
import 'login_screen.dart';

class WelcomeScreen4 extends StatefulWidget {
  const WelcomeScreen4({super.key});

  @override
  State<WelcomeScreen4> createState() => _WelcomeScreen4State();
}

class _WelcomeScreen4State extends State<WelcomeScreen4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 80.0),
          alignment: Alignment.center,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Chat one on one, join communities and ask questions.',
              style: TextStyle(
                color: Color(0xff344f4f),
                fontSize: 50,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: 300,
          child: EleaTextButton(
            text: 'Let\'s Get Started',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
