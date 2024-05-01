import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        print('User role: $userRole'); // Print user role for debugging
        if (userRole =='admin') {
          return credential.user;
        } else {
          Fluttertoast.showToast( msg: 'Do not have privillages to LogIn ');
        }
      }
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
        return userData['role'] as String?; // Access 'role' field      }
      }
    } catch (error) {
      print('Error fetching user role: $error');
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
      default:
        Fluttertoast.showToast(msg: "Error occurred: ${e.code}");
    }
  }

  void _handleError(dynamic e) {
    Fluttertoast.showToast(msg: "Error occurred: $e");
  }
}
