import 'package:flutter/material.dart';

void showErrorAlert(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xFF520D0D),
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
