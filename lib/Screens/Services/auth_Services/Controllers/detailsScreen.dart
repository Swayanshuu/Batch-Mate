// ignore_for_file: body_might_complete_normally_nullable, deprecated_member_use, must_be_immutable, prefer_is_empty, use_build_context_synchronously, file_names

import 'dart:ui';

import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final User user;
  DetailsPage({super.key, required this.user});

  TextEditingController name = TextEditingController();
  TextEditingController batchID = TextEditingController();
  var userForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/image/logBG.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),
          SafeArea(
            child: Form(
              key: userForm,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: Image.asset("assets/image/logo.png"),
                                ),
                                const Text(
                                  "BATCH MATE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const Text(
                                  "Because every batch is a story.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            Text(
                              "Let's get start!",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.1),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      91,
                                      91,
                                      91,
                                    ),
                                    width: .5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(height: 15),

                                      SizedBox(height: 20),

                                      TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          label: Text("Name"),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                157,
                                                157,
                                                157,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                74,
                                                74,
                                                74,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        controller: name,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.toString().length < 3) {
                                            return "Enter your Name";
                                          }
                                        },
                                      ),

                                      SizedBox(height: 20),

                                      TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          label: Text("batch id"),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                157,
                                                157,
                                                157,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                74,
                                                74,
                                                74,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        controller: batchID,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.toString().length == 0) {
                                            return "enter your batch id";
                                          }
                                        },
                                      ),

                                      SizedBox(height: 20),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          if (userForm.currentState!
                                              .validate()) {
                                            // Log event to firebase analytics
                                            await FirebaseAnalytics.instance
                                                .logEvent(
                                                  name: "signup_btn_clk",
                                                );

                                            // Save to Firestore
                                            await FirebaseFirestore.instance
                                                .collection("google_users")
                                                .doc(user.uid)
                                                .set({
                                                  "uid": user.uid,
                                                  "Setname": name.text,
                                                  'name': user.displayName ?? '',
                                                  "batchID": batchID.text,
                                                  "provider": "google",
                                                  "createdAt":
                                                      FieldValue.serverTimestamp(),
                                                }, SetOptions(merge: true));
                                            // merge:true → updates existing doc without overwriting old fields

                                            // Navigate to MainScreen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MainScreen(),
                                              ),
                                            );
                                          }
                                        },

                                        child: Text(
                                          "LestGo",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
