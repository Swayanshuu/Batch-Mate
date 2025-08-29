// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/components/textField.dart';
import 'package:classroombuddy/controllers/login_Controller.dart';
import 'package:classroombuddy/Screens/signup_Screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  var userForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // allow proper scrolling with keyboard
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: userForm,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // LOGO
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

                            const SizedBox(height: 20),
                            const Text(
                              "Good to see you again!",
                              style: TextStyle(
                                fontSize: 25,
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
                                    color: Color.fromARGB(255, 91, 91, 91),
                                    width: .5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 15),
                                      const Text(
                                        "LogIn",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      textField(
                                        lebelText: "Email",
                                        obScureText: false,
                                        Controller: email,
                                        ValidatorMessage: "Email Required",
                                      ),
                                      const SizedBox(height: 20),
                                      textField(
                                        lebelText: "Password",
                                        obScureText: true,
                                        Controller: password,
                                        ValidatorMessage: "Password Required",
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (userForm.currentState!
                                              .validate()) {
                                            loginController.login(
                                              context: context,
                                              email: email.text,
                                              password: password.text,
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "LogIn",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "New here?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const SignupScreen();
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    "Register!",
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
