import 'package:eleatest/screens/onboarding_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        return const EleaApp();
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return const EleaApp();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text("Welcome to my app!"),
          ),
        ),
      ),
    );
  }
}

class EleaApp extends StatelessWidget {
  const EleaApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elea test',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.grey[300],
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            if (user == null) {
              return Container();
            }
            return FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                final prefs = snapshot.data;
                if (prefs == null) {
                  return Container();
                }
                final onboardingComplete =
                    prefs.getBool('onboardingComplete') ?? false;
                return onboardingComplete
                    ? const HomeScreen()
                    : const OnboardingScreen1();
              },
            );
          }
          return const WelcomeScreen();
        }),
      ),
    );
  }
}
