import 'dart:ui';

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUserCredentials extends StatefulWidget {
  const ShowUserCredentials({super.key});

  @override
  State<ShowUserCredentials> createState() => _ShowUserCredentialsState();
}

class _ShowUserCredentialsState extends State<ShowUserCredentials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Logo background
          Center(
            child: SizedBox(
              height: 200,
              child: Image.asset("assets/image/logo.png"),
            ),
          ),
          // Blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Your Details:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),

                  SizedBox(height: 30),
                  _userDeatils(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userDeatils() {
    var userCredential = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(userCredential.userName),
              Text(userCredential.userEmail),
              Text(userCredential.userBatch),
              Text(userCredential.userUID),
              Text(userCredential.userSetName),
              Text(userCredential.userLastLogIn),
              Text(userCredential.createdAt),
            ],
          ),
        ),
      ),
    );
  }
}
