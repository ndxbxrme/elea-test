import 'package:flutter/material.dart';

import '../components/login_header.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginHeader(
            title: 'Welcome to ELEA',
            subtitle:
                'Connect with other users, ask and answer questions, and get the support you need',
          ),
          const SizedBox(height: 50),
          Text(
              'ELEA Medical Chat is a community-driven platform developed by ELEA, a company with offices in Barcelona and Sheffield. Our goal is to provide a safe and supportive space for users to connect with others who have similar medical conditions and share their experiences'),
          const SizedBox(height: 10),
          Text(
              'With our innovative tagging system, you can easily find and join discussions on topics that matter to you. Whether you\'re looking for information, support, or just want to connect with others who understand what you\'re going through, ELEA Medical Chat is here for you.'),
          const SizedBox(height: 10),
          Text(
              'Thank you for choosing ELEA Medical Chat. We hope you find the support and connection you need in our community.'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
