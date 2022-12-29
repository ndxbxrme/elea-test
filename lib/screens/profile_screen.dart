import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const ProfileScreen({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser["avatarUrl"]),
              ),
            ),
            const SizedBox(height: 20),
            Text(currentUser["username"], style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(currentUser["bio"], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text("Edit profile"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
