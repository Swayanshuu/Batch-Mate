
import 'package:firebase_auth/firebase_auth.dart';
import 'package:classroombuddy/main_Screen.dart';
import 'package:flutter/material.dart';

class loginController {
  // for signup, connect to firebase
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // here we use pushand remove until instead of pus or push replacement to remove the back button from dashboard page, as we can olny replace one screen that we chnage to login page at sigup page
      // so we use pushAndRemoveUntil here, and it requires (route){ return 'boolean' } (if true then it ll show bback button and give access to previous page anf if it is false then it ll chnage the dashboard screen to main screen)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        ),
        (route) {
          return false; // nned here coz of pushAndRemoveUntil. set to false as we dont need the back button at dashboard page
        },
      );

      // message after account created....
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          content: Text("✅ Signed in Successfully"),
        ),
      );
    } catch (e) {
      // message after if any error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          content: Row(
            children: [
              Text("❌"),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  e.toString(),
                  // softWrap: true,
                  // overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
