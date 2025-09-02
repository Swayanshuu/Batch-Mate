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
  String userLastLogIn = "?";
  String createdAt = "?";

  bool isLoading = true; // indicates loading state

  /// Fetches user details from Firestore
  Future<void> getDetails() async {
    isLoading = true;
    notifyListeners(); // tell UI to show loader

    try {
      var authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        await Future.delayed(Duration(milliseconds: 500)); // wait a bit
        authUser = FirebaseAuth.instance.currentUser;
        if (authUser == null) return;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection("google_users")
          .doc(authUser.uid)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;

        userName = data["name"] ?? "";
        userSetName = data["Setname"] ?? "";
        userEmail = data["email"] ?? authUser.email;
        userBatch = data["batchID"] ?? "";
        userPhotoUrl = data["photoUrl"] ?? "";
        userUID = authUser.uid;
        userLastLogIn =
            (data["lastLogin"] as Timestamp?)?.toDate().toString().substring(0,16) ?? "?";
        createdAt =
            (data["createdAt"] as Timestamp?)?.toDate().toString().substring(0,16) ?? "?";
      } else {
        // Optional: handle user doc not existing
        userName = "?";
        userSetName = "?";
        userEmail = "?";
        userBatch = "?";
        userPhotoUrl = "?";
        userUID = authUser.uid;
        userLastLogIn = "?";
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }

    isLoading = false;
    notifyListeners(); // tell UI to rebuild with real data
  }

  /// Resets all user fields (useful on logout)
  void resetDetails() {
    userName = "?";
    userSetName = "?";
    userEmail = "?";
    userBatch = "?";
    userPhotoUrl = "?";
    userUID = "?";
    userLastLogIn = "?";
    isLoading = true;
    notifyListeners();
  }
}
