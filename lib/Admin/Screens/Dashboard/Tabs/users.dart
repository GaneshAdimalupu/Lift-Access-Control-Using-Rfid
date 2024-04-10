import 'dart:io';

import 'package:Elivatme/Admin/Screens/Dashboard/components/models/add_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File _imageFile; // Variable to store the selected image file

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload the selected image to Firestore
  Future<void> _uploadImage(String userId) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$userId.jpg');

    await storageRef.putFile(_imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    await userRef.update({'profileImageUrl': imageUrl});
  }

  // Function to delete user data from Firestore
  Future<void> _deleteUserFirestore(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  // Function to delete user from Firebase Authentication
  Future<void> _deleteUserFirebaseAuth(String userId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  // Function to delete user from both Firestore and Firebase Authentication
  Future<void> _deleteUserBoth(String userId) async {
    await _deleteUserFirestore(userId);
    await _deleteUserFirebaseAuth(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B0E41), // Background color
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          List<DocumentSnapshot> users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final docID = users[index].id;
              final profileImageUrl = userData['profileImageUrl'] as String?;

              return Dismissible(
                key: Key(docID),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Color.fromARGB(255, 0, 153, 255),
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart ||
                      direction == DismissDirection.startToEnd) {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text("Are you sure you want to delete this user?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return false;
                },
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart ||
                      direction == DismissDirection.startToEnd) {
                    await _deleteUserFirestore(docID); // Delete from Firestore
                  }
                },
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      await _pickImage(); // Pick an image from gallery
                      await _uploadImage(docID); // Upload the image to Firestore
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : null, // Display the uploaded image if available
                      child: profileImageUrl == null
                          ? const Icon(
                              Icons.person) // Display default icon if no image
                          : null,
                    ),
                  ),
                  title: Text(
                    userData['fullName'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Email: ${userData['email'] ?? 'Unknown'}, College ID: ${userData['collegeID'] ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => AddUserDialog(),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User added successfully'),
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
