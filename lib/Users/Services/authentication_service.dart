import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check the user's role before allowing sign-in
      if (credential.user != null) {
        final userRole = await getUserRole(email);
        if (userRole == 'user') {
          return credential.user;
        } else {
          _handleError('Cannot sign in. User role is "user".');
          
        }
      }
      // Accessing the authentication token
      final User? user = credential.user;
      if (user != null) {
        final String? token =
            await user.getIdToken(); // Access the authentication token
        Fluttertoast.showToast(msg: 'Authentication token: $token');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    num collegeID,
  ) async {
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return authResult.user;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  Future<String?> getUserRole(String email) async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('app_users')
          .doc(email)
          .get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data()
            as Map<String, dynamic>; // Cast to Map<String, dynamic>
        return userData['role'] as String?; // Access 'role' field
      }
    } catch (error) {
      print('Error fetching user role: $error');
    }
    return null;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
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

      // Get user info
      final User? user = authResult.user;

      // Store user data in Firestore
      if (user != null) {}

      return user;
    } catch (error) {
      _handleError(error);
    }
    return null;
  }

  // Error handling methods...

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        Fluttertoast.showToast(msg: "User not found. Please check your email.");
        break;
      case 'wrong-password':
        Fluttertoast.showToast(msg: "Please check your password.");
        break;
      case 'email-already-in-use':
        Fluttertoast.showToast(msg: "Email already exists");
        break;
      default:
        Fluttertoast.showToast(msg: "Error occurred: ${e.code}");
    }
  }

  void _handleError(dynamic e) {
    Fluttertoast.showToast(msg: "Error occurred: $e");
  }
}
