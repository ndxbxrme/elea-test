import 'package:eleatest/components/error_alert.dart';
import 'package:eleatest/screens/complete_signup_screen.dart';
import 'package:eleatest/screens/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/elea_text_button.dart';
import '../components/login_header.dart';
import '../widgets/clear_code_widget.dart';
import '../widgets/keyboard_safe_view_widget.dart';
import '../components/elea_text_box.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _waitingForCode = false;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadWaitingForCode();
  }

  _loadWaitingForCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waitingForCode = prefs.getBool('waitingForCode') ?? false;
      _email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: KeyboardSafeViewWidget(
          child: Center(
            child: _waitingForCode
                ? WaitingForCodeForm(
                    updateState: setState,
                    email: _email,
                  )
                : const LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  late String _email;

  late String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginHeader(
            title: 'Don\'t Worry, Be Happy',
            subtitle: 'Sign in to join the good vibes',
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
          EleaTextBox(
            labelText: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            onSaved: (value) => _password = (value == null) ? '' : value,
            obscureText: true,
          ),
          const SizedBox(height: 10),
          EleaTextButton(
            text: 'Log in',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email,
                    password: _password,
                  );
                  // if the user has signed in with a password then they are on board already
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('onboardingComplete', true);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } catch (e) {
                  showErrorAlert('Login error', context);
                }
              }
            },
          ),
          TextButton(
            child: const Text('Go to Signup Screen'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 50),
          TextButton(
            child: const Text('Forgot password?'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WaitingForCodeForm extends StatefulWidget {
  final Function updateState;
  final String email;
  const WaitingForCodeForm(
      {super.key, required this.updateState, required this.email});

  @override
  State<WaitingForCodeForm> createState() => _WaitingForCodeFormState();
}

class _WaitingForCodeFormState extends State<WaitingForCodeForm> {
  final _formKey = GlobalKey<FormState>();

  late String _code;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginHeader(
            title: 'Get In On The Action',
            subtitle: 'Sign in to join the ride',
          ),
          const SizedBox(height: 50),
          EleaTextBox(
            labelText: 'Email',
            initialValue: widget.email,
            enabled: false,
          ),
          const SizedBox(height: 10),
          EleaTextBox(
            labelText: 'Code',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the code';
              }
              return null;
            },
            onSaved: (value) => _code = (value == null) ? '' : value,
          ),
          const SizedBox(height: 10),
          EleaTextButton(
            text: 'Submit code',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var prefsEmail = prefs.getString('email') ?? '';
                  var prefsCode = prefs.getString('code') ?? '';
                  if (widget.email == prefsEmail && _code == prefsCode) {
                    prefs.setString('email', '');
                    prefs.setString('code', '');
                    prefs.setBool('waitingForCode', false);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompleteSignupScreen(
                          email: widget.email,
                        ),
                      ),
                    );
                  } else {
                    // alert about bad code
                  }
                } catch (e) {
                  showErrorAlert('Login error', context);
                }
              }
            },
          ),
          ClearCodeWidget(updateState: widget.updateState),
        ],
      ),
    );
  }
}
