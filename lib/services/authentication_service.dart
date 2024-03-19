// authentication_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Declare GoogleSignIn instance

  Future<User?> signInMethod(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle user not found separately
        Fluttertoast.showToast(msg: "User not found. Please check your email.");
      } else if (e.code == 'wrong-password') {
        // Handle wrong password separately
        Fluttertoast.showToast(msg: "Please check your password.");
      } else {
        // Handle other errors
        Fluttertoast.showToast(msg: "Please Check Email / Password");
      }
    }
    return null;
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String collegeID,
  ) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user details in Firestore
      await _firestore.collection('users').doc(authResult.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
      });

      return authResult.user;
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
      Fluttertoast.showToast(msg: "Error signing in with Google");
      return null;
    }
  }
}
