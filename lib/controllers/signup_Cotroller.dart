// ignore_for_file: use_build_context_synchronously, camel_case_types, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:flutter/material.dart';

class signupController {
  // for signup, connect to firebase
  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String batchId,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Update the displayName
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

          // Save batchId to Firestore under user document
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'batchCode': batchId,
      'name': name,
      'email': email,
    });

    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        ),
        (route) {
          return false;
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
      print(e);
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
