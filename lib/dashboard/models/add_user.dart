import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUserDialog extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collegeIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _collegeIdController,
              decoration: InputDecoration(labelText: 'College ID'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addUserToFirestore(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  void _addUserToFirestore(BuildContext context) async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final collegeID = _collegeIdController.text.trim();

    if (fullName.isEmpty || email.isEmpty || collegeID.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'fullName': fullName,
        'email': email,
        'collegeID': collegeID,
      });
      Fluttertoast.showToast(msg: 'User added successfully');
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding user: $e');
    }
  }
}
