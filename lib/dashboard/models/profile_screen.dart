import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/dashboard/models/add_user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue, // Change app bar background color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red, // Error text color
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue, // Loading indicator color
              ),
            );
          }

          final users = snapshot.data?.docs;

          if (users == null || users.isEmpty) {
            return Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Colors.grey, // Text color for no users found
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 3, // Card elevation
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Card margin
                child: ListTile(
                  title: Text(
                    userData['fullName'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Email: ${userData['email'] ?? 'Unknown'}, College ID: ${userData['collegeID'] ?? 'Unknown'}',
                    style: TextStyle(
                      color: Colors.grey, // Subtitle text color
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddUserDialog(),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white, // Icon color
        ),
        backgroundColor: Colors.blue, // Floating action button color
      ),
    );
  }
}
