import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatImageUploaderWidget extends StatefulWidget {
  final String chatId;
  final bool needsAccept;
  const ChatImageUploaderWidget({
    super.key,
    required this.chatId,
    required this.needsAccept,
  });

  @override
  State<ChatImageUploaderWidget> createState() =>
      _ChatImageUploaderWidgetState();
}

class _ChatImageUploaderWidgetState extends State<ChatImageUploaderWidget> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: const CircleBorder(),
        child: (_isUploading)
            ? const CircularProgressIndicator()
            : const Icon(Icons.camera_alt),
        onPressed: () async {
          if (_isUploading || widget.needsAccept) {
            return;
          }
          setState(() {
            _isUploading = true;
          });
          ImagePicker imagePicker = ImagePicker();
          XFile? file =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (file == null) return;
          var ref = FirebaseStorage.instance
              .ref()
              .child('avatars/${const Uuid().v4()}');
          try {
            await ref.putFile(File(file.path));
            var downloadUrl = await ref.getDownloadURL();
            setState(() {
              _isUploading = false;
            });
            final userRef = FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            final snapshot = await userRef.get();
            final user = snapshot.data();
            if (user == null) return;
            await FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatId)
                .collection('messages')
                .add({
              'text': '',
              'image': downloadUrl,
              'userId': user['uid'],
              'username': user['username'],
              'avatarUrl': user['avatarUrl'],
              'timestamp': Timestamp.now(),
            });
          } catch (error) {
            debugPrint('error');
            setState(() {
              _isUploading = false;
            });
          }
        });
  }
}
