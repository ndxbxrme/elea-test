import 'package:eleatest/helpers/fetch_current_user_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eleatest/screens/onboarding_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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

  static const colorLightGreen = Color(0xffeff6f2);
  static const colorGreen = Color(0xffb2d4bf);
  static const colorPink = Color(0xfff8f0f5);
  static const colorDarkGreen = Color(0xff344f4f);
  static const colorOrange = Color(0xfff08e57);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elea test',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: colorDarkGreen,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 45),
          toolbarHeight: 80.0,
        ),
        primaryColor: colorDarkGreen,
        accentColor: colorGreen,
        splashColor: colorOrange,
        backgroundColor: colorLightGreen,
        textTheme: GoogleFonts.poppinsTextTheme(),
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
