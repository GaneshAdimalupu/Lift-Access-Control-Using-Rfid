import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addUser({
    required String fullName,
    required String email,
    required String collegeID,
    required String docID,
  }) async {
    try {
      await _firestore.collection('users').add({
        'fullName': fullName,
        'email': email,
        'collegeID': collegeID,
        'docID': docID,
      });
      Fluttertoast.showToast(msg: "User added successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding user: $e");
    }
  }

  static Future<void> deleteUser(String docId) async {
    try {
      await _firestore.collection('users').doc(docId).delete();
      // Delete lift usage data associated with the user
      await _firestore
          .collection('lift usage')
          .where('collegeID', isEqualTo: docId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      Fluttertoast.showToast(msg: "User and associated data deleted successfully");
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

  static Future<int> getUserCount() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.size;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving user count: $e');
      return 0;
    }
  }

  static Future<List<LiftUsage>> getLiftUsageData() async {
    List<LiftUsage> liftUsageData = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      for (var doc in querySnapshot.docs) {
        // Extracting collegeID, email, and timestamp from Firestore document
        String collegeID = doc['collegeID'].toString();
        String email = doc['email'].toString();
        List<dynamic> liftUsageList = doc['liftUsage'];
        String fullName = doc['fullName'].toString();

        for (var usage in liftUsageList) {
          Timestamp timestamp = usage['timestamp'];
          DateTime date = timestamp.toDate();
          liftUsageData
              .add(LiftUsage(date, collegeID, 1, fullName, email, doc.id));
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
  final String email; // Add email property
  final String docId;

  LiftUsage(this.timestamp, this.collegeID, this.usageCount, this.fullName,
      this.email, this.docId);

  DateTime getTimestamp() {
    return timestamp;
  }

  String getCollegeID() {
    return collegeID;
  }

  int getYear() {
    return timestamp.year;
  }

  String getDocId() {
    return docId;
  }
}
