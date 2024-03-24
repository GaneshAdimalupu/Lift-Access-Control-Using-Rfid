import 'dart:ui';

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

  static Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      Fluttertoast.showToast(msg: "User deleted successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting user: $e");
    }
  }

  static Future<void> logLiftUsage(String collegeID) async {
    try {
      // Add current timestamp to the lift usage collection under the corresponding user
      await _firestore.collection('lift usage').add({
        'collegeID': collegeID,
        'timestamp': Timestamp.now(),
      });
      Fluttertoast.showToast(msg: "Lift usage logged successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging lift usage: $e");
    }
  }

  static Future<List<LiftUsage>> getLiftUsageData() async {
    List<LiftUsage> liftUsageData = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      for (var doc in querySnapshot.docs) {
        // Extracting collegeID and timestamp from Firestore document
        String collegeID = doc['collegeID'].toString(); // Convert to String
        List<dynamic> liftUsageList = doc['liftUsage'];
        String fullName = doc['fullName']
            .toString(); // Hypothetical function to fetch fullName

        for (var usage in liftUsageList) {
          Timestamp timestamp = usage['timestamp'];
          // Converting timestamp to DateTime
          DateTime date = timestamp.toDate();
          // Adding data to liftUsageData list
          liftUsageData.add(LiftUsage(date, collegeID, 1,
              fullName)); // Hardcoded usageCount to 1 for each log
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving lift usage data: $e');
    }

    return liftUsageData;
  }
}

class LiftUsage {
  final DateTime timestamp;
  final String collegeID;
  final int usageCount;
  final String fullName;

  LiftUsage(this.timestamp, this.collegeID, this.usageCount, this.fullName);

  DateTime getTimestamp() {
    return timestamp;
  }

  String getCollegeID() {
    return collegeID;
  }

  int getYear() {
    return timestamp.year;
  }
}
