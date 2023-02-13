import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AvatarWidget extends StatefulWidget {
  final String avatarUrl;
  final Function(String) onAvatarChanged;

  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    required this.onAvatarChanged,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String avatarUrl = '';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    avatarUrl = widget.avatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: avatarUrl.isEmpty
                  ? Text(
                      FirebaseAuth.instance.currentUser?.displayName
                              ?.substring(0, 1) ??
                          '',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.grey[300],
                      ),
                    ) as ImageProvider
                  : NetworkImage(avatarUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            setState(() {
              _isUploading = true;
            });
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
            if (file == null) return;
            var ref = FirebaseStorage.instance
                .ref()
                .child('avatars/${FirebaseAuth.instance.currentUser!.uid}');
            try {
              await ref.putFile(File(file.path));
              var downloadUrl = await ref.getDownloadURL();
              setState(() {
                avatarUrl = downloadUrl;
                _isUploading = false;
              });
              widget.onAvatarChanged(downloadUrl);
            } catch (error) {
              debugPrint('error');
              setState(() {
                _isUploading = false;
              });
              // some error occured
            }
          },
          icon: _isUploading
              ? const CircularProgressIndicator()
              : const Icon(Icons.camera_alt),
        ),
      ],
    );
  }
}
