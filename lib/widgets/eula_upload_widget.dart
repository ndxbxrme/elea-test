import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EulaUploadWidget extends StatefulWidget {
  const EulaUploadWidget({super.key});

  @override
  State<EulaUploadWidget> createState() => _EulaUploadWidgetState();
}

class _EulaUploadWidgetState extends State<EulaUploadWidget> {
  final TextEditingController _eulaTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _eulaTextController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter Eula here',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('eulas')
                  .add({'text': _eulaTextController.text});
            },
            child: const Text('Upload Eula'),
          ),
        ],
      ),
    );
  }
}
