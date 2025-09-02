// ignore_for_file: file_names, body_might_complete_normally_nullable, prefer_is_empty, deprecated_member_use, use_build_context_synchronously, unnecessary_import

import 'dart:ui';

import 'package:classroombuddy/Screens/Services/auth_Services/Controllers/signup_Cotroller.dart';
import 'package:classroombuddy/Screens/Services/auth_Services/Screens/login_Screen.dart';
import 'package:classroombuddy/components/textField.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController batchID = TextEditingController();

  var userForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                      Text(
                                        "SignUp",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 20),

                                      textField(
                                        lebelText: "Email",
                                        obScureText: false,
                                        Controller: email,
                                        ValidatorMessage: "Email Required",
                                      ),

                                      SizedBox(height: 20),

                                      textField(
                                        lebelText: "Password",
                                        obScureText: true,
                                        Controller: password,
                                        ValidatorMessage: "Password Required",
                                      ),

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
                                                  parameters: {
                                                    "email": email.text,
                                                    "batchId": batchID.text,
                                                  },
                                                );

                                            // Proceed with signup
                                            signupController.createAccount(
                                              context: context,
                                              email: email.text,
                                              password: password.text,
                                              name: name.text,
                                              batchId: batchID.text,
                                            );
                                          }
                                        },

                                        child: Text(
                                          "Sign Up",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already a user?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return LoginScreen();
                                        },
                                      ),
                                      (route) {
                                        return false;
                                      },
                                    );
                                  },
                                  child: Text(
                                    "LogIn!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
