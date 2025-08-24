// ignore_for_file: file_names, body_might_complete_normally_nullable, prefer_is_empty, deprecated_member_use

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
      resizeToAvoidBottomInset: true, // Ensures screen adjusts for keyboard
      body: SafeArea(
        child: Form(
          key: userForm,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20), // extra padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      border: Border.all(color: Colors.white, width: 1),
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
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text("Name"),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
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
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text("batch id"),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
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
                            onPressed: () {
                              if (userForm.currentState!.validate()) {
                                signupController.createAccount(
                                  context: context,
                                  email: email.text,
                                  password: password.text,
                                  name: name.text,
                                  batchId: batchID.text
                                );
                              }
                            },

                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
                      "Already a user?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
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
      ),
    );
  }
}
