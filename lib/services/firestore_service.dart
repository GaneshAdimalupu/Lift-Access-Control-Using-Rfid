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

  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error retrieving users: $e");
      return [];
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

  static Future<List<SalesData>> getLiftUsageData() async {
    List<SalesData> liftUsageData = [];

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('lift usage').get();
      querySnapshot.docs.forEach((doc) {
        // Extracting collegeID and timestamp from Firestore document
        num collegeID = doc['collegeID'];
        Timestamp timestamp = doc['timestamp'];

        // Converting timestamp to DateTime
        DateTime date = timestamp.toDate();

        // Adding data to liftUsageData list
        liftUsageData.add(SalesData(date, collegeID));
      });
    } catch (e) {
      print('Error retrieving lift usage data: $e');
    }

    return liftUsageData;
  }
}

class SalesData {
  final DateTime year;
  final num collegeID;

  SalesData(this.year, this.collegeID);
}
