import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      return user;
    } catch (e) {
      print('Error during sign up: $e');
      return null;
    }
  }

  Future<void> prepareAuthEvent() async {
    // Add logic for preparing the authentication event
    // For example, you can initialize Firebase or perform other setup tasks
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        UserCredential userCredential = await _auth.signInWithPopup(
          GoogleAuthProvider(),
        );
        return userCredential.user;
      } else {
        final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

        if (googleSignInAccount == null) {
          return null;
        }

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);

        return authResult.user;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }
}
