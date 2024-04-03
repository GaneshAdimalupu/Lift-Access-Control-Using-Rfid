import 'dart:io';

import 'package:Elivatme/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Elivatme/components/dashboard/models/add_user.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bool _sortByFullName = false; // Variable to control sorting by fullName
  late File? _imageFile; // Variable to store the selected image file

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

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
    if (_imageFile != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final storageRef = FirebaseStorage.instance.ref().child('user_images').child('$userId.jpg');

      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      await userRef.update({'profileImageUrl': imageUrl});
    } else {
      print('No image file to upload.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (_sortByFullName) {
            users.sort((a, b) =>
                (a['fullName'] as String).compareTo(b['fullName'] as String));
          }

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
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm"),
                      content:
                          const Text("Are you sure you want to delete this user?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await FirestoreService.deleteUser(docID);
                  }
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            ? const Icon(Icons.person) // Display default icon if no image
                            : null,
                      ),
                    ),
                    title: Text(
                      userData['fullName'] ?? 'Unknown',
                      style: const TextStyle(
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
