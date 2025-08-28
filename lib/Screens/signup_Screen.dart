// ignore_for_file: file_names, body_might_complete_normally_nullable, prefer_is_empty, deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/components/textField.dart';
import 'package:classroombuddy/controllers/signup_Cotroller.dart';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:flutter/material.dart';

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Let's get start!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.1),
                        border: Border.all(
                          color: const Color.fromARGB(255, 91, 91, 91),
                          width: .5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  borderRadius: BorderRadius.circular(20),
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
                                  borderRadius: BorderRadius.circular(20),
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
                                  borderRadius: BorderRadius.circular(20),
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
                                  borderRadius: BorderRadius.circular(20),
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
                              onPressed: () {
                                if (userForm.currentState!.validate()) {
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
                                "Sign In",
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
        ],
      ),
    );
  }
}
