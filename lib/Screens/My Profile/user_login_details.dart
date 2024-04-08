import 'dart:io';

import 'package:Elivatme/Screens/My%20Profile/profile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsPage extends StatelessWidget {
  final User? user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  Future<void> _uploadImage(File imageFile, BuildContext context) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(user!.uid + '.jpg');

    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('app_users')
        .doc(user!.uid)
        .update({'profileImageUrl': imageUrl});
  }

  Future<void> _editProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path), context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture updated successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image selected'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('app_users')
            .doc(user!.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final userData = snapshot.data!.data();
          final profileImageUrl = userData?['profileImageUrl'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileWidget(
                  imagePath: profileImageUrl ?? '',
                  onClicked: () {
                    _editProfilePicture(context);
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Name: ${userData?['fullName'] ?? "Unknown"}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Email: ${userData?['email'] ?? "Unknown"}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'collegeID: ${userData?['collegeID'] ?? "Unknown"}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
