// ignore_for_file: file_names, deprecated_member_use, unused_element

import 'dart:ui';
import 'package:classroombuddy/Screens/Services/user_Srervices/showUser_Credentials.dart';
import 'package:classroombuddy/Screens/User%20Profile/aboutBatch_Screen.dart';
import 'package:classroombuddy/Screens/User%20Profile/about_Screen.dart';
import 'package:classroombuddy/Screens/Services/user_Srervices/editUser_Credentials.dart';
import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getDetails();
    });
  }

  Widget _optionRow({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard() {
    var userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 17, 17).withOpacity(.9),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color.fromARGB(255, 85, 85, 85),
                backgroundImage: userProvider.userPhotoUrl.isNotEmpty
                    ? NetworkImage(userProvider.userPhotoUrl)
                    : null,
                child: userProvider.userPhotoUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 40)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                userProvider.userSetName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Batch: ${userProvider.userBatch}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                userProvider.userEmail,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("PROFILE", style: TextStyle(letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
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
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Profile Card
                              _profileCard(),

                              const SizedBox(height: 10),
                              // Edit Profile
                              _optionRow(
                                icon: Icons.edit_note,
                                text: "Edit Profile",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditScreen(),
                                    ),
                                  );
                                },
                              ),
                              // User Details
                              _optionRow(
                                icon: Icons.person,
                                text: "Your Details",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ShowUserCredentials(),
                                    ),
                                  );
                                },
                              ),
                              // about batch
                              _optionRow(
                                icon: Icons.group,
                                text: "About your Batch",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AboutBatch(),
                                    ),
                                  );
                                },
                              ),
                              // About
                              _optionRow(
                                icon: Icons.error_outline,
                                text: "About Us",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AboutScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Text(
                        "© 2025 Batch Mate. All rights reserved.",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
