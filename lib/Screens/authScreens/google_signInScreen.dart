// ignore_for_file: file_names, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:ui';
import 'package:classroombuddy/Screens/authScreens/Services/detailsScreen.dart';
import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:classroombuddy/Screens/authScreens/Services/google_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSigninscreen extends StatefulWidget {
  const GoogleSigninscreen({super.key});

  @override
  State<GoogleSigninscreen> createState() => _GoogleSigninscreenState();
}

class _GoogleSigninscreenState extends State<GoogleSigninscreen> {
  bool isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();

      if (!mounted) return;

      if (userCredential != null) {
        if (!mounted) return;

        final user = userCredential.user;

        if (user != null) {
          //  Check if user exists in Firestore
          final docSnapshot = await FirebaseFirestore.instance
              .collection("google_users")
              .doc(user.uid)
              .get();

          if (docSnapshot.exists) {
            // Existing user -> go to MainScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else {
            // New user -> go to Details page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(user: user)),
            );
          }
        }
        // signedin successfully
        print("User Signin: ${userCredential.user?.displayName}");
      }
    } catch (e) {
      if (!mounted) return;
      // For error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          content: Text("Google Login failed!"),
        ),
      );
      print("signin error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset("assets/image/logBG.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
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
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Because every batch is a story.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Google Sign-In Button
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Image.asset("assets/image/google_logo.png", height: 24),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
