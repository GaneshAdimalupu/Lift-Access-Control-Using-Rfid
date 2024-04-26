import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<int> getUserCount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the count of documents in the collection
        return 1;
      } else {
        // If the user is not signed in, return 0
        return 0;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving user count: $e');
      return 0;
    }
  }

  static Future<List<LiftUsage>> getLiftUsageDataForCurrentUser() async {
    List<LiftUsage> liftUsageData = [];

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot liftUsageQuerySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (liftUsageQuerySnapshot.docs.isNotEmpty) {
          // Cast QueryDocumentSnapshot to DocumentSnapshot<Map<String, dynamic>>
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              liftUsageQuerySnapshot.docs.first
                  as DocumentSnapshot<Map<String, dynamic>>;

          if (documentSnapshot.exists &&
              documentSnapshot.data()!.containsKey('liftUsage')) {
            List<dynamic> liftUsageList = documentSnapshot['liftUsage'];
            for (var usage in liftUsageList) {
              if (usage is Map<String, dynamic> &&
                  usage.containsKey('timestamp')) {
                Timestamp timestamp = usage['timestamp'];
                DateTime date = timestamp.toDate();
                String goToLift = usage['goToLift'] ?? ''; // Get goToLift field
                liftUsageData.add(LiftUsage(
                    date,
                    documentSnapshot['collegeID'],
                    1,
                    documentSnapshot['fullName'],
                    documentSnapshot['email'],
                    documentSnapshot.id,
                    goToLift)); // Pass goToLift to LiftUsage constructor
              }
            }
          } else {
            print(
                'Document does not exist or does not contain the liftUsage field');
          }
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
  final String email;
  final String docId;
  final String goToLift; // New field

  LiftUsage(this.timestamp, this.collegeID, this.usageCount, this.fullName,
      this.email, this.docId, this.goToLift);
}

enum ChartType {
  column,
  pie,
}
