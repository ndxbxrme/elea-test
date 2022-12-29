import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/widgets/eula_upload_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
              child: const Text('Add tags'),
              onPressed: () async {
                await addMedicalTagsToFirestore();
              },
            ),
            const EulaUploadWidget(),
          ],
        ),
      ),
    );
  }
}

Future<void> addMedicalTagsToFirestore() async {
  final List<String> medicalTags =
      generateMedicalTags(); // generate the list of tags
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // get a reference to the Firestore instance
  final CollectionReference collection =
      firestore.collection('tags'); // get a reference to the 'tags' collection

  // add each tag to the collection as a new document
  for (String tag in medicalTags) {
    debugPrint(tag);
    await collection.add({'name': tag, 'category': 'medical'});
  }
}

List<String> generateMedicalTags() {
  final random = Random();
  final List<String> medicalTags = [
    'anatomy',
    'physiology',
    'pharmacology',
    'pathology',
    'surgery',
    'radiology',
    'dermatology',
    'gynecology',
    'obstetrics',
    'pediatrics',
    'psychiatry',
    'oncology',
    'neurology',
    'orthopedics',
    'cardiology',
    'endocrinology',
    'gastroenterology',
    'hematology',
    'infectious disease',
    'nephrology',
    'pulmonology',
    'rheumatology',
    'emergency medicine',
    'toxicology',
    'urology',
    'allergy and immunology'
  ];

  return List.generate(
      20, (i) => medicalTags[random.nextInt(medicalTags.length)]);
}
