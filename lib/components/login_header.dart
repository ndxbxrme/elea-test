import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const LoginHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 75),
      Text(
        title,
        style: GoogleFonts.getFont('Poppins', fontSize: 52),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    ]);
  }
}
