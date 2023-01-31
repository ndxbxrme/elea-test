import 'package:flutter/material.dart';

class EleaTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const EleaTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: Color(0xfff08e57),
          textStyle: const TextStyle(fontSize: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
      child: Text(text),
    );
  }
}
