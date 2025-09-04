// ignore_for_file: use_rethrow_when_possible, unnecessary_null_comparison, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool isIntialize = false;

  static Future<void> initializeGoogleAuth() async {
    // Ensure Intialization
    if (!isIntialize) {
      await _googleSignIn.initialize(
        serverClientId:
            '754971893832-eojllqndu79r5paeppu48tm8m56uuf3g.apps.googleusercontent.com',
      );
    }

    isIntialize = true;
  }

  // Method to sign in with Google (no return type)
  static Future<UserCredential> signInWithGoogle() async {
    try {
      initializeGoogleAuth();

      final GoogleSignInAccount gUser = await _googleSignIn.authenticate();

      // getting id token
      final idToken = gUser.authentication.idToken;
      final authorizationClient = gUser.authorizationClient;

      // authorize user
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      // getting access token
      final accessToken = authorization!.accessToken;
      if (accessToken == null) {
        final authorizatio2 = await authorizationClient.authorizationForScopes([
          'email',
          'profile',
        ]);

        if (authorizatio2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorizatio2;
      }

      // credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      // sign in with google
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;
      bool isNewUser = false;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('google_users')
            .doc(user.uid);
        final docSnapShot = await userDoc.get();
        if (!docSnapShot.exists) {
          // new user
          isNewUser = true;
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email,
            'photoUrl': user.photoURL ?? '',
            'provider': 'google',
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'User',
          });
        } else {
          // Existing user → make sure isNewUser = false
          await userDoc.update({
            'isNewUser': isNewUser,
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }
      }
      return userCredential;
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  // signout
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error signingout: $e");
      throw e;
    }
  }
}
