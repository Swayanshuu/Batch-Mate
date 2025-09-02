// ignore_for_file: file_names, unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:classroombuddy/Screens/Services/auth_Services/Controllers/detailsScreen.dart';
import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:classroombuddy/Screens/Services/auth_Services/Controllers/google_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          print("User UID: ${user.uid}");
          final docSnapshot = await FirebaseFirestore.instance
              .collection("google_users")
              .doc(user.uid)
              .get();
          print("Doc exists? ${docSnapshot.exists}");

          final data = docSnapshot.data();
          if (data == null || data["name"] == null || data["batchID"] == null) {
            // Existing user -> go to MainScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(user: user)),
            );
          } else {
            // New user -> go to Details page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
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
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : _signInWithGoogle, // Disable button while loading
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
                    child: isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: const Color.fromARGB(255, 176, 176, 176),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/image/google_logo.png",
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Sign in with Google",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
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
