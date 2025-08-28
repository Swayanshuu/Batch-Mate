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
                  Text("Good to see you again!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.1),
                        border: Border.all(color: const Color.fromARGB(255, 91, 91, 91), width: .5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            SizedBox(height: 15),
                            Text(
                              "LogIn",
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
                                        
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              onPressed: () {
                                if (userForm.currentState!.validate()) {
                                  loginController.login(
                                    context: context,
                                    email: email.text,
                                    password: password.text,
                                  );
                                }
                              },
                                        
                              child: Text(
                                "LogIn",
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
              
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New here?",
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
                                return SignupScreen();
                              },
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
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
        ],
      ),
    );
  }
}
