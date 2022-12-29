import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/elea_text_box.dart';
import '../components/elea_text_button.dart';
import '../components/login_header.dart';
import '../widgets/keyboard_safe_view_widget.dart';
import 'onboarding_screen_1.dart';

class CompleteSignupScreen extends StatefulWidget {
  final String email;
  const CompleteSignupScreen({super.key, required this.email});

  @override
  State<CompleteSignupScreen> createState() => _CompleteSignupScreenState();
}

class _CompleteSignupScreenState extends State<CompleteSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _password;
  final _firestore = FirebaseFirestore.instance;
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
                  const LoginHeader(
                    title: 'Life\'s a Party',
                    subtitle: 'Sign in to join the fun',
                  ),
                  const SizedBox(height: 50),
                  EleaTextBox(
                    labelText: 'Email',
                    initialValue: widget.email,
                    enabled: false,
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
                    onChanged: (value) => _password = value ?? '',
                    onSaved: (value) =>
                        _password = (value == null) ? '' : value,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  EleaTextBox(
                    labelText: 'Repeat password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please repeat the password';
                      }
                      if (value != _password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  EleaTextButton(
                    text: 'Sign in',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          debugPrint('creating user');
                          debugPrint(widget.email);
                          debugPrint(_password);
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: widget.email,
                            password: _password,
                          );
                          //push blank profile to firestore
                          await _firestore
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .set({
                            'uid': FirebaseAuth.instance.currentUser?.uid,
                            'username': '',
                            'full_name': '',
                            'dob': DateTime(1989, 1, 1).toIso8601String(),
                            'bio': '',
                            'avatarUrl':
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            'tags': [],
                            'chats': [],
                            'groupChats': [],
                            'userInvites': [],
                            'invitedUsers': [],
                            'blockedUsers': [],
                            'friends': [],
                            'chatInvites': [],
                            'groupChatInvites': [],
                            'status': 'Active',
                            'typing': false,
                            'forumStatus': 'User',
                            'numThreads': 0,
                            'numTopics': 0,
                            'lastTime': DateTime.now().toIso8601String(),
                          }, SetOptions(merge: true));

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('onboardingComplete', false);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen1(),
                            ),
                          );
                        } catch (e) {
                          debugPrint(e.toString());
                        }
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
