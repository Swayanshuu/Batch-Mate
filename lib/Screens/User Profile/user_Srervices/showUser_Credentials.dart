// ignore_for_file: deprecated_member_use, file_names

import 'dart:ui';

import 'package:classroombuddy/Provider/userProvider.dart';
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
    var userCredential = Provider.of<UserProvider>(context);

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Your Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),

                    // User Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(
                              255,
                              15,
                              15,
                              15,
                            ).withOpacity(0.5),
                            const Color.fromARGB(
                              255,
                              93,
                              93,
                              93,
                            ).withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color.fromARGB(
                              255,
                              85,
                              85,
                              85,
                            ),
                            backgroundImage:
                                userCredential.userPhotoUrl.isNotEmpty
                                ? NetworkImage(userCredential.userPhotoUrl)
                                : null,
                            child: userCredential.userPhotoUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : null,
                          ),
                          _userInfoRow(
                            Icons.admin_panel_settings,
                            "role",
                            userCredential.userROle,
                          ),
                          _userInfoRow(
                            Icons.person,
                            "Name",
                            userCredential.userName,
                          ),
                          _userInfoRow(
                            Icons.email,
                            "Email",
                            userCredential.userEmail,
                          ),
                          _userInfoRow(
                            Icons.school,
                            "Batch",
                            userCredential.userBatch,
                          ),
                          _userInfoRow(
                            Icons.fingerprint,
                            "UID",
                            userCredential.userUID,
                          ),
                          _userInfoRow(
                            Icons.edit,
                            "Set Name",
                            userCredential.userSetName,
                          ),
                          _userInfoRow(
                            Icons.login,
                            "Last Login",
                            userCredential.userLastLogIn,
                          ),
                          _userInfoRow(
                            Icons.date_range,
                            "Created At",
                            userCredential.createdAt,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.white70),
              //overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
