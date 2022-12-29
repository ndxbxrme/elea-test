import 'package:easy_debounce/easy_debounce.dart';
import 'package:eleatest/components/friendly_alert.dart';
import 'package:eleatest/screens/onboarding_screen_3.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../components/elea_text_box.dart';
import '../components/elea_text_button.dart';
import 'avatar_widget.dart';

class EditProfileWidget extends StatefulWidget {
  final bool onboarding;
  const EditProfileWidget({super.key, required this.onboarding});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String _avatarUrl;
  late String _username;
  late String _fullName;
  late String _dob;
  late String _bio;
  final _usernameController = TextEditingController();
  bool _usernameAvailable = true; // Set this to true initially

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var user = snapshot.data;
        if (user == null) {
          return const CircularProgressIndicator();
        }
        _avatarUrl = user["avatarUrl"];
        _dob = user["dob"];
        _username = user["username"];
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              if (widget.onboarding)
                EleaTextBox(
                  labelText: 'Username',
                  controller: _usernameController,
                  initialValue: null,
                  onChanged: (_) {
                    EasyDebounce.debounce(
                        'username', Duration(milliseconds: 500), () async {
                      // Check the availability of the username
                      final availability = await checkUsernameAvailability(
                          _usernameController.text);
                      setState(() {
                        _usernameAvailable = availability;
                      });
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user name';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = (value == null) ? '' : value,
                ),
              if (!_usernameAvailable) const Text('Username taken'),
              if (widget.onboarding) const SizedBox(height: 10),
              EleaTextBox(
                initialValue: user["full_name"],
                labelText: 'Full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) => _fullName = (value == null) ? '' : value,
              ),
              const SizedBox(height: 10),
              EleaTextBox(
                initialValue: user["bio"],
                labelText: 'A short bio',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a short bio';
                  }
                  return null;
                },
                onSaved: (value) => _bio = (value == null) ? '' : value,
              ),
              const SizedBox(height: 10),
              if (widget.onboarding)
                SizedBox(
                  height: 80,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.parse(user['dob']),
                    onDateTimeChanged: (DateTime newDateTime) {
                      _dob = newDateTime.toIso8601String();
                    },
                  ),
                ),
              if (widget.onboarding) const SizedBox(height: 10),
              AvatarWidget(
                avatarUrl: user["avatarUrl"],
                onAvatarChanged: (String newAvatarUrl) {
                  _avatarUrl = newAvatarUrl;
                },
              ),
              EleaTextButton(
                text: (widget.onboarding == true)
                    ? 'Save profile'
                    : 'Update profile',
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _usernameAvailable) {
                    _formKey.currentState!.save();
                    try {
                      await _firestore
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .set({
                        'username': _username,
                        'full_name': _fullName,
                        'dob': _dob,
                        'bio': _bio,
                        'avatarUrl': _avatarUrl,
                      }, SetOptions(merge: true));
                      if (widget.onboarding == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen3(),
                          ),
                        );
                      }
                      // ignore: use_build_context_synchronously
                      showFriendlyAlert('Profile updated', context);
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<bool> checkUsernameAvailability(String username) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final query = usersRef.where('username', isEqualTo: username);
  final snapshot = await query.get();
  return snapshot.docs.isEmpty;
}
