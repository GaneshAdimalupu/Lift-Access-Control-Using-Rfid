import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                      _buildButton("assets/images/EG.png", "/control?id=F"),
                      _buildButton("assets/images/E3.png", "/control?id=F"),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust spacing between columns
                Expanded(
                  child: Column(
                    children: [
                      _buildButton("assets/images/E1.png", "/control?id=R"),
                      _buildButton("assets/images/E4.png", "/control?id=L"),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust spacing between columns
                Expanded(
                  child: Column(
                    children: [
                      _buildButton("assets/images/E2.png", "/control?id=R"),
                      _buildButton("assets/images/E5.png", "/control?id=L"),
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
    try {
      final response = await http.get(
        Uri.parse('http://${widget.ipAddress}$command'),
      );

      if (response.statusCode == 200) {
        print('Command sent successfully: $command');
      } else {
        print('Failed to send command: ${response.statusCode}');
        // Handle error, possibly show a snackbar or dialog
      }
    } catch (error) {
      print('Error sending command: $error');
      // Handle error, possibly show a snackbar or dialog
    }
  }
}
