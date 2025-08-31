// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/User%20Profile/about_Screen.dart';
import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/User%20Profile/edit_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvide = Provider.of<UserProvider>(
      context,
    ); // we have to use in uder builder
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("PROFILE", style: TextStyle(letterSpacing: 1.5)),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 200,
              child: Image.asset("assets/image/logo.png"),
            ),
          ),
          // Blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),
          Center(
            child: Column(
              children: [
                // calling user data
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 17, 17, 17),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      85,
                                      85,
                                      85,
                                    ),
                                    radius: 40,
                                    child: Text(
                                      userProvide.userName[0],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    userProvide.userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Batch: ${userProvide.userBatch}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(userProvide.userEmail),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Edit Profile
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Material(
                            color: Colors.grey[900], // background color
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // About
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Material(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "About",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Copyright
                Text(
                  "© 2025 Batch Mate. All rights reserved.",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
