import 'package:flutter/material.dart';

void showFriendlyAlert(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.deepPurple,
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
