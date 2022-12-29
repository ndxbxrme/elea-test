import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/onboarding_screen_4.dart';

class TagSelectorWidget extends StatefulWidget {
  final String userId;
  final bool onboarding;

  const TagSelectorWidget(
      {super.key, required this.userId, required this.onboarding});

  @override
  State<TagSelectorWidget> createState() => _TagSelectorWidgetState();
}

class _TagSelectorWidgetState extends State<TagSelectorWidget> {
  final _selectedTags = <String>{};
  List<String> _userTags = [];

  @override
  void initState() {
    super.initState();
    _loadUserTags();
  }

  void _loadUserTags() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      var user = userDoc.data();
      if (user != null) {
        _userTags = user['tags'].whereType<String>().toList();
        _selectedTags.addAll(_userTags);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tags').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              final tags = snapshot.data!.docs;
              return ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  final tagName = tag['name'];
                  return CheckboxListTile(
                    value: _selectedTags.contains(tagName),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTags.add(tagName);
                        } else {
                          _selectedTags.remove(tagName);
                        }
                      });
                    },
                    title: Text(tagName),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .update({
              'tags': _selectedTags.toList(),
            });
            if (widget.onboarding == true) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen4(),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
