import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "?";
  String userSetName = "?";
  String userEmail = "?";
  String userBatch = "?";
  String userPhotoUrl = "?";
  String userUID = "?";

  bool isLoading = true; // 🔥 add loading flag

  Future<void> getDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      var authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) return;

      final dataSnapshot = await FirebaseFirestore.instance
          .collection("google_users")
          .doc(authUser.uid)
          .get();

      userName = dataSnapshot.data()?["name"] ?? "";
      userSetName = dataSnapshot.data()?["Setname"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userBatch = dataSnapshot.data()?["batchID"] ?? "";
      userPhotoUrl = dataSnapshot.data()?["photoUrl"] ?? "";
      userUID = authUser.uid;
    } catch (e) {
      print("Error fetching user details: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
