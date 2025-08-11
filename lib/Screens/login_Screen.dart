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
      body: SafeArea(
        child: Form(
          key: userForm,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20), 
            child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
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
                                "LogIn",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  
                              SizedBox(height: 20),
                  
                              textField(lebelText: "Email", obScureText: false, Controller: email, ValidatorMessage: "Email Required"),
                  
                              SizedBox(height: 20),
                  
                              textField(lebelText: "Password", obScureText: true, Controller: password, ValidatorMessage: "Password Required"),
                  
                              SizedBox(height: 20),
                  
                              ElevatedButton(
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
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                ),
                              ),
                  
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New here?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignupScreen();
                              },
                            ),
                          );
                        },
                        child: Text("Register!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
