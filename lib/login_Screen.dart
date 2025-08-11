import 'package:classroombuddy/controllers/login_Controller.dart';
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
      body: Form(
        key: userForm,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      height: 400,
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
                              "Verify Yourself",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              autofocus: true,
                              decoration: InputDecoration(
                                label: Text("Email"),
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
                              controller: email,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.toString().length < 3) {
                                  return "Must be atleast 3 Characters";
                                }
                              },
                            ),

                            SizedBox(height: 20),

                            TextFormField(
                              autofocus: true,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: Text("Password"),
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
                              controller: password,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.toString().length < 3) {
                                  return "Must be atleast 3 Characters";
                                }
                              },
                            ),

                            SizedBox(height: 20),

                            GestureDetector(
                              onTap: () {
                                if (userForm.currentState!.validate()) {
                                  loginController.login(
                                    context: context,
                                    email: email.text,
                                    password: password.text,
                                  );
                                }
                              },

                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ), // Add padding for nicer spacing
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.3),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(.3),

                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ).withOpacity(0.2), // shadow color
                                      blurRadius: 6, // how blurry the shadow is
                                      offset: Offset(
                                        0,
                                        0,
                                      ), // shadow position (x,y)
                                      spreadRadius:
                                          4, // how much the shadow spreads
                                    ),
                                  ],
                                ),

                                child: Text(
                                  "Proceed",
                                  style: TextStyle(fontSize: 16),
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
          ],
        ),
      ),
    );
  }
}
