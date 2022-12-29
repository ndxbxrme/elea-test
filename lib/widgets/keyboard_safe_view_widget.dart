// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class KeyboardSafeViewWidget extends StatefulWidget {
  final Widget child;

  const KeyboardSafeViewWidget({
    super.key,
    required this.child,
  });

  @override
  State<KeyboardSafeViewWidget> createState() => _KeyboardSafeViewWidgetState();
}

class _KeyboardSafeViewWidgetState extends State<KeyboardSafeViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: widget.child);
  }
}
