import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> logLiftUsage(String email) async {
    try {
      // Add current timestamp to the lift usage collection under the corresponding user
      await _firestore.collection('lift usage').add({
        'collegeID': email,
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
        num collegeID = doc['collegeID'];
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
  final num collegeID;
  final int usageCount;
  final String fullName;
  final String email; // Add email property
  final String docId;

  LiftUsage(this.timestamp, this.collegeID, this.usageCount, this.fullName,
      this.email, this.docId);

  DateTime getTimestamp() {
    return timestamp;
  }

  num getcollegeID() {
    return collegeID;
  }

  int getYear() {
    return timestamp.year;
  }

  String getDocId() {
    return docId;
  }
}
