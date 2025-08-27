// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userProvider extends ChangeNotifier {
  String userName = "USER";
  String userEmail = "EMAIL";
  String userBatch = "BATCH";

  var db = FirebaseFirestore.instance;
  void getDetails() {
    var authUser = FirebaseAuth.instance.currentUser;

    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?['name'] ?? "";
      userEmail = dataSnapshot.data()?['email'] ?? "";
      userBatch = dataSnapshot.data()?['batchCode'] ?? "";
      notifyListeners();
    });
  }
}
