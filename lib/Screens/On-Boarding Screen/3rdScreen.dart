// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:ui';
import 'package:classroombuddy/Screens/Services/auth_Services/Screens/google_signInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  // save onboarding complete
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasSeenOnboarding", true);

    if (!mounted) return; //  Prevents navigation errors if widget is disposed

    // Navigate to Signup
    Navigator.pushAndRemoveUntil(
    context,
      MaterialPageRoute(builder: (context) => const GoogleSigninscreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 140, 0, 255).withOpacity(1),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/image/3rdScreenbg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset("assets/image/3.jpg", fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.asset("assets/image/logo.png"),
                    ),
                    const Text(
                      "BATCH MATE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Text(
                      "Because every batch is a story.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Let's get started!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 233, 233, 233),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Batchmates united — are you in?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: _completeOnboarding, // logic moved here
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
