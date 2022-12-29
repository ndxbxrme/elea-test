import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/connections_widget.dart';

class ConnectionsScreen extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const ConnectionsScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ConnectionsWidget(
      userId: FirebaseAuth.instance.currentUser!.uid,
      currentUser: currentUser,
    );
  }
}
