// ignore_for_file: file_names

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/On-Boarding%20Screen/onBoardingScreen.dart';
import 'package:classroombuddy/Screens/authScreens/google_signInScreen.dart';
import 'package:classroombuddy/Screens/authScreens/login_Screen.dart';
import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool("hasSeenOnboarding") ?? false;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      // First time → show onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
      return;
    }

    // If already seen onboarding, check FirebaseAuth
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _openLogin();
    } else {
      _openMainScreen();
    }
  }

  void _openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GoogleSigninscreen()),
    );
  }

  void _openMainScreen() {
    Provider.of<UserProvider>(context, listen: false).getDetails();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset("assets/image/logo.png")),
                SizedBox(height: 20,),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
