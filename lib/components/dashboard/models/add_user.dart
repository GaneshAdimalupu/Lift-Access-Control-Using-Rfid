

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserDialog extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collegeIdController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();

  AddUserDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Action'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              _showAddUserDialog(context);
            },
            child: const Text('Add User'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _showUseLiftDialog(context);
            },
            child: const Text('Use Lift'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) async {
    Navigator.of(context).pop(); // Dismiss the current dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _collegeIdController,
                decoration: const InputDecoration(labelText: 'College ID'),
              ),
              TextField(
                controller: _documentIdController,
                decoration: const InputDecoration(labelText: 'Document ID'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _addUserToFirestore(context);
              Navigator.of(context).pop(); // Close dialog after adding user
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addUserToFirestore(BuildContext context) async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final collegeID = _collegeIdController.text.trim();
    final documentID = _documentIdController.text.trim();

    if (fullName.isEmpty || email.isEmpty || collegeID.isEmpty || documentID.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(documentID).set({
        'fullName': fullName,
        'email': email,
        'collegeID': collegeID,
        'liftUsage': [], // Initialize lift usage as an empty list
      });
      Fluttertoast.showToast(msg: 'User added successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding user: $e');
    }
  }

  void _showUseLiftDialog(BuildContext context) {
    Navigator.of(context).pop(); // Dismiss the current dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use Lift'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _documentIdController,
              decoration: const InputDecoration(labelText: 'Document ID'),
            ),
            TextField(
              controller: _collegeIdController,
              decoration: const InputDecoration(labelText: 'College ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _logLiftUsage(context);
              Navigator.of(context).pop(); // Close dialog after logging lift usage
            },
            child: const Text('Use Lift'),
          ),
        ],
      ),
    );
  }

  void _logLiftUsage(BuildContext context) async {
    try {
      String documentId = _documentIdController.text;
      String collegeID = _collegeIdController.text;

      // Check if the document ID exists in the users collection
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();
      if (documentSnapshot.exists) {
        // Document ID found, get current lift usage list
        dynamic data = documentSnapshot.data();
        if (data != null && data.containsKey('liftUsage')) {
          List<dynamic> currentUsage = data['liftUsage'];

          // Update the list with new lift usage
          currentUsage.add({
            //'collegeID': collegeID,
            'timestamp': Timestamp.now(),
          });

          // Update the Firestore document with the modified lift usage list
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'liftUsage': currentUsage,
          });
          Fluttertoast.showToast(msg: "Lift usage logged successfully");
        } else {
          // If 'liftUsage' field does not exist, create it with the new lift usage
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'liftUsage': [
              {
                'collegeID': collegeID,
                'timestamp': Timestamp.now(),
              }
            ],
          });
          Fluttertoast.showToast(msg: "Lift usage logged successfully");
        }
      } else {
        Fluttertoast.showToast(msg: "Document ID not found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging lift usage: $e");
    }
  }
}

