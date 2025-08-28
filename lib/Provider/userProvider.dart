// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "?";
  String userEmail = "?";
  String userBatch = "?";

  var db = FirebaseFirestore.instance;
  void getDetails() {
    var authUser = FirebaseAuth.instance.currentUser;

    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userBatch = dataSnapshot.data()?["batchCode"] ?? "";
      notifyListeners();
    });
  }
}
