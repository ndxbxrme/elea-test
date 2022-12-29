import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/elea_text_box.dart';
import '../components/elea_text_button.dart';
import '../widgets/keyboard_safe_view_widget.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: KeyboardSafeViewWidget(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.android,
                    size: 100,
                  ),
                  const SizedBox(height: 75),
                  Text(
                    'Reset password',
                    style: GoogleFonts.bebasNeue(fontSize: 52),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your email for a reset link',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 50),
                  EleaTextBox(
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = (value == null) ? '' : value,
                  ),
                  const SizedBox(height: 10),
                  EleaTextButton(
                    text: 'Send link',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: _email);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _generateCode() {
  var rng = Random();
  var code = '';
  for (var i = 0; i < 6; i++) {
    var charCode = rng.nextInt(36);
    code += charCode < 10
        ? charCode.toString()
        : String.fromCharCode(charCode + 87);
  }
  code = 'TEST01';
  return code.toUpperCase();
}
