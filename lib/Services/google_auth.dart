import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Method to sign in with Google (no return type)
  Future<void> signInWithGoogle() async {
    try {
      // initialize Google SignIn (required in v7+)
      await _googleSignIn.initialize();

      // authenticate
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      // check if user cancelled
      if (account == null) {
        print("User cancelled Google Sign-In");
        return;
      }

      // get auth tokens
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      // create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // sign in to Firebase
      await _auth.signInWithCredential(credential);

      print("Google Sign-In successful");
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
    } catch (e) {
      print("Error: $e");
    }
  }
}
