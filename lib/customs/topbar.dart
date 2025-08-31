// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:classroombuddy/User%20Profile/profileScreen.dart';
import 'package:classroombuddy/Screens/splash_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      left: 12,
      right: 12,
      child: SafeArea(
        top: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: .5,
                ),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 35, 35, 35).withOpacity(0.6),
                    const Color.fromARGB(255, 129, 129, 129).withOpacity(0.01),
                    const Color.fromARGB(255, 35, 35, 35).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return _roundButton(Icons.person, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileScreen();
                            },
                          ),
                        ); // This opens the drawer
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "BATCH MATE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
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
                  ),
                  _roundButton(Icons.logout, () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SplashScreen();
                        },
                      ),
                      (route) => false,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _roundButton(IconData icon, VoidCallback onTap) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
    ),
    child: IconButton(
      padding: EdgeInsets.zero, // remove default padding
      iconSize: 20, // smaller icon inside
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
    ),
  );
}
