import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsPage extends StatefulWidget {
  final User? user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late File _imageFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('app_users')
            .doc(widget.user!.email)
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
                GestureDetector(
                  onTap: _editProfilePicture,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: profileImageUrl != null
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/placeholder_image.png')
                                as ImageProvider<Object>,
                        // Using 'as ImageProvider<Object>' to explicitly cast to ImageProvider<Object>
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _deleteProfilePicture,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Delete Profile Picture'),
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
                  'College ID: ${userData?['collegeID'] ?? "Unknown"}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(widget.user!.email! + '.jpg');

      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(widget.user!.email)
          .update({'profileImageUrl': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture updated successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile picture: $error'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteProfilePicture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(widget.user!.email! + '.jpg');
      await ref.delete();

      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(widget.user!.email)
          .update({'profileImageUrl': null});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture deleted successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete profile picture: $error'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _editProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage(_imageFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image selected'),
      ));
    }
  }
}
