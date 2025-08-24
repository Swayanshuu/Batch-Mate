import 'dart:ui';

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
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: .5,
                ),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 22, 22, 22).withOpacity(0.6),
                    const Color.fromARGB(255, 152, 152, 152).withOpacity(0.01),
                    const Color.fromARGB(255, 20, 20, 20).withOpacity(0.6),
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
                      return _roundButton(Icons.menu, () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Container(),
                                  ),
                                ),
                                DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.5,
                                  maxChildSize: 0.95,
                                  expand: false,
                                  builder: (context, scrollController) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ).withOpacity(0.9),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount: 50,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color.fromARGB(
                                                    255,
                                                    46,
                                                    46,
                                                    46,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text("Shibu $index"),
                                                      Text("Shibu $index"),
                                                      Text("Shibu $index"),
                                                      Text("Shibu $index"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                  ),
                  Text(
                    "BATCH MATE",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 237, 237, 237),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
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
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(100),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white),
    ),
  );
}
