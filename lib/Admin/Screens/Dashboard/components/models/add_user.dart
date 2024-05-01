import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserDialog extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collegeIDController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();
  final TextEditingController _goToLift = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

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
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _roleController,
                    labelText: 'Role',
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
    final password = _passwordController.text.trim(); // Get password
    final role = _roleController.text.trim(); // Get role from dropdown

    // Convert collegeID from String to num using tryParse
    final num? collegeID = num.tryParse(collegeIDText);

    // Set document ID equal to college ID
    final documentID = email;

    if (fullName.isEmpty ||
        email.isEmpty ||
        collegeID == null ||
        password.isEmpty ||
        role.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }
    try {
      // First, create the user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Get the UID of the newly created user
      String uid = userCredential.user!.uid;

      // Then, add the user details to Firestore to 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(documentID).set({
        'fullName': fullName,
        'email': email,
        'collegeID': collegeID,
        'role': role,
        'uid': uid,
        'liftUsage': [], // Initialize lift usage as an empty list
      });
      // Save data to 'app_users' firestore collection
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(documentID)
          .set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': uid,
        'role': role, // Set default role here
      });

      // Sanitize email for Realtime Database key
      String sanitizedEmail = email.replaceAll('.', '_');

      // Add user details to Realtime Database under 'users' node
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(sanitizedEmail);
      // Initialize 'liftUsage' as an empty list
      await userRef.set({
        'fullName': fullName,
        'uid': uid,
        'liftUsage': [], // Initialize lift usage as an empty list
      });

      // Store user data in Realtime Database under 'app_users' node
      DatabaseReference appUserRef = FirebaseDatabase.instance
          .reference()
          .child('app_users')
          .child(sanitizedEmail);

      await appUserRef.set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': uid,
        'role': role, // Set default role here
      });

      Fluttertoast.showToast(msg: 'User added successfully');
    } catch (e) {
      print('Error adding user: $e');
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
                _buildTextField(
                  controller: _goToLift,
                  labelText: 'goToLift',
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
      int goToLift = int.parse(_goToLift.text); // Get the value of goToLift

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

          // Get the length of currentUsage to determine the index for the new lift usage log
          int newIndex = currentUsage.length;

          // Add the new lift usage log to the end of the list
          currentUsage.add({
            'Traveled_to': goToLift,
            'timestamp': Timestamp.now(),
          });

          // Update the Firestore document with the modified lift usage list
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentSnapshot.id)
              .update({
            'liftUsage': currentUsage,
          });

          Fluttertoast.showToast(
              msg: "Lift usage logged successfully in Firestore");

          // Sanitize email for Realtime Database key
          String sanitizedEmail =
              documentSnapshot['email'].replaceAll('.', '_');

          // Get the current timestamp
          DateTime now = DateTime.now();
          String timestamp = '${now.hour}:${now.minute}:${now.second} '
              '${now.day}/${now.month}/${now.year}';

          // Add the lift usage to the user's node in Realtime Database
          DatabaseReference userRef = FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(sanitizedEmail)
              .child('liftUsage');

          // Push the new entry to the lift usage array with the index as the key
          await userRef.child(newIndex.toString()).set({
            'timestamp': timestamp,
            'goToLift': goToLift,
          });

          // Update the current lift position in Realtime Database
          updateRealtimeDBLiftPosition(goToLift);
          // Update the current lift position in Firestore
          updateFirestoreLiftPosition(goToLift);

          Fluttertoast.showToast(
              msg: "Lift usage logged successfully in Realtime Database");
        } else {
          // If 'liftUsage' field does not exist, create it with the new lift usage
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentSnapshot.id)
              .update({
            'liftUsage': [
              {
                'Traveled_to': goToLift,
                'timestamp': Timestamp.now(),
              }
            ],
          });

          Fluttertoast.showToast(
              msg:
                  "Lift usage logged successfully in Firestore with initial index");
        }
      } else {
        Fluttertoast.showToast(msg: "Email not found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging lift usage: $e");
    }
  }

  Future<void> updateFirestoreLiftPosition(int liftPosition) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('current_lift')
            .doc('current_lift_position')
            .update(
                {'lift_position': liftPosition, 'timestamp': Timestamp.now()});
        // Update the current lift position in Realtime Database
        updateRealtimeDBLiftPosition(liftPosition);

        print('Firestore lift position updated: $liftPosition');
      }
    } catch (error) {
      print('Error updating Firestore lift position: $error');
    }
  }

  void updateRealtimeDBLiftPosition(int liftPosition) {
    try {
      DatabaseReference liftRef =
          FirebaseDatabase.instance.reference().child('current_lift');

      // Convert the current timestamp to milliseconds since Unix epoch
      DateTime now = DateTime.now();
      String timestamp = '${now.hour}:${now.minute}:${now.second} '
          '${now.day}/${now.month}/${now.year}';
      // Update the 'lift_position' and 'timestamp' fields
      liftRef.update({
        'lift_position': liftPosition,
        'timestamp': timestamp, // Convert to string
      });
      print('Realtime Database lift position updated: $liftPosition');
    } catch (error) {
      print('Error updating Realtime Database lift position: $error');
    }
  }
}
