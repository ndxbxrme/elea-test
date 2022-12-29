import 'package:eleatest/widgets/keyboard_safe_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../components/elea_text_box.dart';
import '../components/elea_text_button.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                    'Sign up',
                    style: GoogleFonts.bebasNeue(fontSize: 52),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Friendly subtitle, you\'re looking great',
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
                    text: 'Get a code',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', _email);
                        var code = _generateCode();
                        prefs.setString('code', code);
                        prefs.setBool('waitingForCode', true);
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
