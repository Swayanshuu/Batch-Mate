// ignore_for_file: file_names

import 'dart:ui';
import 'package:classroombuddy/Services/google_auth.dart';
import 'package:flutter/material.dart';

class GoogleSigninscreen extends StatefulWidget {
  const GoogleSigninscreen({super.key});

  @override
  State<GoogleSigninscreen> createState() => _GoogleSigninscreenState();
}

class _GoogleSigninscreenState extends State<GoogleSigninscreen> {

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
                    onPressed: () async {
                      await GoogleAuthService().signInWithGoogle;
                    },
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
                    icon: Image.asset(
                      "assets/image/logo.png",
                      height: 24,
                    ),
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
