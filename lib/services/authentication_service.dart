// authentication_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  
 Future<User?> signInMethod(String email, String password) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: "User not found. Please check your email.");
      return null; // Return null to indicate that the sign-in failed
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: "Incorrect password. Please try again.");
      return null; // Return null to indicate that the sign-in failed
    } else {
      Fluttertoast.showToast(msg: "Some error occurred: ${e.message}");
    }
  }
  return null;
}

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Email already exists");
      } else {
        Fluttertoast.showToast(msg: "Error occurred: ${e.code}");
      }
    }
    return null;
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
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount == null) {
          return null;
        }

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        return authResult.user;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      Fluttertoast.showToast(msg: "Error signing in with Google");
      return null;
    }
  }
}
