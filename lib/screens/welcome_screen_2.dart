import 'package:flutter/material.dart';

class WelcomeScreen2 extends StatefulWidget {
  const WelcomeScreen2({super.key});

  @override
  State<WelcomeScreen2> createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2> {
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
                text: 'elea\n',
                style: TextStyle(
                  color: Color(0xffb2d4bf),
                  fontSize: 100,
                ),
                children: const <TextSpan>[
                  TextSpan(
                      text:
                          'connects people living with the same health conditions',
                      style: TextStyle(
                        color: Color(0xff344f4f),
                        fontSize: 50,
                      )),
                ]),
          ),
        ),
      ],
    );
  }
}
