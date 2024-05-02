import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class MonitoringPage extends StatefulWidget {
  final String ipAddress;
  const MonitoringPage({Key? key, required this.ipAddress}) : super(key: key);

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  bool holdingButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32.0,
          ),
        ),
        title: SizedBox(
          height: 40,
          child: Center(
            child: Image.asset(
              "assets/images/Skyway.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(
              50.0, 450.0, 50.0, 0.0), // Adjust padding here
          child: Align(
            alignment: Alignment.bottomCenter, // Place buttons at the bottom

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildButton("assets/images/EG.png", "/control?id=G"),
                      _buildButton("assets/images/E3.png", "/control?id=3"),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust spacing between columns
                Expanded(
                  child: Column(
                    children: [
                      _buildButton("assets/images/E1.png", "/control?id=1"),
                      _buildButton("assets/images/E4.png", "/control?id=4"),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust spacing between columns
                Expanded(
                  child: Column(
                    children: [
                      _buildButton("assets/images/E2.png", "/control?id=2"),
                      _buildButton("assets/images/E5.png", "/control?id=5"),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildButton(String icon, String command) {
    return GestureDetector(
      onTapDown: (_) => _startCommand(command),
      onTapUp: (_) => _stopCommand(),
      onTapCancel: () => _stopCommand(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 6, // Adjust button height
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _startCommand(String command) {
    if (!holdingButton) {
      _sendCommand(command);
      holdingButton = true;
    }
  }

  void _stopCommand() {
    if (holdingButton) {
      _sendCommand('/control?id=S');
      holdingButton = false;
    }
  }

  Future<void> _sendCommand(String command) async {
    String lcdMessage;
    String liftPosition;
    switch (command) {
      case "/control?id=G":
        lcdMessage = "Moving Ground";
        liftPosition = "Ground";
        break;
      case "/control?id=1":
        lcdMessage = "Moving to 1st floor";
        liftPosition = "1st floor";
        break;
      case "/control?id=2":
        lcdMessage = "Moving to 2nd floor";
        liftPosition = "2nd floor";
        break;
      case "/control?id=3":
        lcdMessage = "Moving to 3rd floor";
        liftPosition = "3rd floor";
        break;
      case "/control?id=4":
        lcdMessage = "Moving to 4th floor";
        liftPosition = "4th floor";
        break;
      case "/control?id=5":
        lcdMessage = "Moving to 5th floor";
        liftPosition = "5th floor";
        break;
      default:
        lcdMessage = "";
        liftPosition = "";
    }

    try {
      final response = await http.get(
        Uri.parse('http://${widget.ipAddress}$command'),
      );

      if (response.statusCode == 200) {
        print('Command sent successfully: $command');
        // Here you would update the LCD display with the lcdMessage
        print('LCD Message: $lcdMessage');

        // Update Firestore with the new lift position
        await updateFirestoreLiftPosition(liftPosition);

        // Update Realtime Database with the new lift position
        updateRealtimeDBLiftPosition(liftPosition);
      } else {
        print('Failed to send command: ${response.statusCode}');
        // Handle error, possibly show a snackbar or dialog
      }
    } catch (error) {
      print('Error sending command: $error');
      // Handle error, possibly show a snackbar or dialog
    }
  }

  Future<void> updateFirestoreLiftPosition(String liftPosition) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('current_lift')
            .doc('current_lift_position')
            .set({'lift_position': liftPosition});
        print('Firestore lift position updated: $liftPosition');
      }
    } catch (error) {
      print('Error updating Firestore lift position: $error');
    }
  }

  void updateRealtimeDBLiftPosition(String liftPosition) {
    try {
      DatabaseReference liftRef =
          FirebaseDatabase.instance.reference().child('current_lift');
      liftRef.update({'lift_position': liftPosition});
      print('Realtime Database lift position updated: $liftPosition');
    } catch (error) {
      print('Error updating Realtime Database lift position: $error');
    }
  }
}
