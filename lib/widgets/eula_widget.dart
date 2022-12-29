import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../screens/onboarding_screen_2.dart';

class EulaWidget extends StatefulWidget {
  const EulaWidget({super.key});

  @override
  State<EulaWidget> createState() => _EulaWidgetState();
}

class _EulaWidgetState extends State<EulaWidget> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('eulas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          DocumentSnapshot eula = snapshot.data!.docs.first;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  MarkdownBody(
                    data: eula['text'],
                  ),
                  CheckboxListTile(
                    value: _accepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _accepted = value!;
                      });
                    },
                    title: const Text('I accept the EULA'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _accepted
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen2(),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
