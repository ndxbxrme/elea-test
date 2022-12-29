import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.green,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.blue,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.yellow,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.purple,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
