import 'package:flutter/material.dart';

class EleaTextBox extends StatelessWidget {
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;

  const EleaTextBox({
    super.key,
    this.labelText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.controller,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 20.0),
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        obscureText: obscureText,
        initialValue: initialValue,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        controller: controller,
      ),
    );
  }
}
