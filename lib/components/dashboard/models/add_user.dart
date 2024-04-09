import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserDialog extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collegeIDController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();

  AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.98),
      title: Text(
        'Choose Action',
        style: TextStyle(
          color: Colors.white, // Set text color to white
        ),
        textAlign: TextAlign.center,
      ),
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Make the background transparent
          insetPadding:
              EdgeInsets.symmetric(horizontal: 40), // Adjust dialog padding
          elevation: 0, // Remove dialog shadow
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.98),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _collegeIDController,
                    labelText: 'College ID',
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildDialogButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: 'Cancel',
                      ),
                      SizedBox(width: 10),
                      _buildDialogButton(
                        onPressed: () async {
                          await _addUserToFirestore(context);
                          Navigator.of(context)
                              .pop(); // Close dialog after adding user
                        },
                        label: 'Add',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildDialogButton(
      {required VoidCallback onPressed, required String label}) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered))
            return Colors.white.withOpacity(0.2);
          return null;
        }),
      ),
      child: Text(label),
    );
  }

  Future<void> _addUserToFirestore(BuildContext context) async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final collegeIDText = _collegeIDController.text.trim();

    // Convert collegeID from String to num using tryParse
  final num? collegeID = num.tryParse(collegeIDText);

    // Set document ID equal to college ID
    final documentID = email;

    if (fullName.isEmpty || email.isEmpty || collegeID==null) {
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
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Make the background transparent
          insetPadding:
              EdgeInsets.symmetric(horizontal: 40), // Adjust dialog padding
          elevation: 0, // Remove dialog shadow
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.98),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Use Lift',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _documentIdController,
                  labelText: 'Email',
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildDialogButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: 'Cancel',
                    ),
                    SizedBox(width: 10),
                    _buildDialogButton(
                      onPressed: () {
                        _logLiftUsage(context);
                        Navigator.of(context)
                            .pop(); // Close dialog after logging lift usage
                      },
                      label: 'Use Lift',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logLiftUsage(BuildContext context) async {
    try {
      String documentId = _documentIdController.text;

      // Check if the document ID exists in the users collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: documentId) // Query by email
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Document ID found, get first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Get current lift usage list
        dynamic data = documentSnapshot.data();
        if (data != null && data.containsKey('liftUsage')) {
          List<dynamic> currentUsage = data['liftUsage'];

          // Update the list with new lift usage
          currentUsage.add({
            'collegeID': documentSnapshot['collegeID'],
            'timestamp': Timestamp.now(),
          });

          // Update the Firestore document with the modified lift usage list
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentSnapshot.id)
              .update({
            'liftUsage': currentUsage,
          });
          Fluttertoast.showToast(msg: "Lift usage logged successfully");
        } else {
          // If 'liftUsage' field does not exist, create it with the new lift usage
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentSnapshot.id)
              .update({
            'liftUsage': [
              {
                'collegeID': documentSnapshot['collegeID'],
                'timestamp': Timestamp.now(),
              }
            ],
          });
          Fluttertoast.showToast(msg: "Lift usage logged successfully");
        }
      } else {
        Fluttertoast.showToast(msg: "Email not found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging lift usage: $e");
    }
  }
}
