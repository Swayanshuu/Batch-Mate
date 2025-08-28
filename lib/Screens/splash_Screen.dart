import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        OpenLogin();
      } else {
        OpenMainScreen();
      }
    });
  }

  void OpenLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  void OpenMainScreen() {
    Provider.of<UserProvider>(context,listen: false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MainScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset("assets/images/ic_launcher.png"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
