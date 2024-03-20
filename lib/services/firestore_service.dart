import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addUser({
    required String fullName,
    required String email,
    required String collegeID,
  }) async {
    try {
      await _firestore.collection('users').add({
        'fullName': fullName,
        'email': email,
        'collegeID': collegeID,
      });
      Fluttertoast.showToast(msg: "User added successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding user: $e");
    }
  }
}
