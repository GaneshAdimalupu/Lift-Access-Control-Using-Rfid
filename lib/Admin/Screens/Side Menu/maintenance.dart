import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Add RFID Tag'),
            onTap: () {
              // Navigate to page for adding RFID tag
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRFIDTagPage()),
              );
            },
          ),
          ListTile(
            title: Text('Remove RFID Tag'),
            onTap: () {
              // Navigate to page for removing RFID tag
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemoveRFIDTagPage()),
              );
            },
          ),
          ListTile(
            title: Text('Update Access Permissions'),
            onTap: () {
              // Navigate to page for updating access permissions
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateAccessPermissionsPage()),
              );
            },
          ),
          // Add more maintenance options as needed
        ],
      ),
    );
  }
}

class AddRFIDTagPage extends StatelessWidget {
  const AddRFIDTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add RFID Tag'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform action to add RFID tag
            // This could involve scanning a new tag and adding it to the system
          },
          child: Text('Scan RFID Tag'),
        ),
      ),
    );
  }
}

class RemoveRFIDTagPage extends StatelessWidget {
  const RemoveRFIDTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove RFID Tag'),
      ),
      body: Center(
        child: TextField(
          decoration: InputDecoration(labelText: 'Enter RFID Tag ID'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // Store the entered RFID tag ID
            // This ID will be used to remove the corresponding tag from the system
          },
        ),
      ),
    );
  }
}

class UpdateAccessPermissionsPage extends StatelessWidget {
  const UpdateAccessPermissionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Access Permissions'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform action to update access permissions
            // This could involve selecting users or groups and updating their permissions
          },
          child: Text('Select Users/Groups'),
        ),
      ),
    );
  }
}
