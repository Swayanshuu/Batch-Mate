import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProvider extends ChangeNotifier {
  String userName = "?";
  String userSetName = "?";
  String userEmail = "?";
  String userBatch = "?";
  String userPhotoUrl = "?";
  String userUID = "?";
  String userLastLogIn = "?";
  String createdAt = "?";
  String userROle= "?";
  bool isLoading = true; // indicates loading state

  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');

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
        userLastLogIn = (data["lastLogin"] as Timestamp?) != null
            ? formatter.format((data["lastLogin"] as Timestamp).toDate())
            : "?";

        createdAt = (data["createdAt"] as Timestamp?) != null
            ? formatter.format((data["createdAt"] as Timestamp).toDate())
            : "?";
        userROle = data["role"];
      } else {
        // Optional: handle user doc not existing
        userName = "?";
        userSetName = "?";
        userEmail = "?";
        userBatch = "?";
        userPhotoUrl = "?";
        userUID = authUser.uid;
        userLastLogIn = "?";
        userROle="?";
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
    userROle = "?";
    isLoading = true;
    notifyListeners();
  }
}
