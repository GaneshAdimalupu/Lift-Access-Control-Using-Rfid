import 'package:Elivatme/Use%20Lift/Elevator_access/ipaddres.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MonitoringPage extends StatefulWidget {
  final String ipAddres;
  const MonitoringPage({super.key, required this.ipAddres});

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => IpAddress()));
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
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
            )),
        actions: [
          SizedBox(
            width: 50,
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton("assets/images/E4.png", "/control?id=F"),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildButton("assets/images/E3.png", "/control?id=B"),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton("assets/images/E1.png", "/control?id=R"),
                const SizedBox(
                  width: 20,
                ),
                _buildButton("assets/images/E2.png", "/control?id=L"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String icon, command) {
    bool holdingButton = false;

    Future<void> _sendCommand(String command) async {
      try {
        final response = await http.get(
          Uri.parse('http://${widget.ipAddres + command}'),
        );

        if (response.statusCode == 200) {
          print('Command sent successfully: $command');
        } else {
          print('Failed to send command: http://${widget.ipAddres + command}');
        }
      } catch (error) {
        print('Error sending command: $error');
      }
    }

    Future<void> _delayedStop() async {
      await Future.delayed(Duration(milliseconds: 200));
      await _sendCommand('/control?id=S');
    }

    void _startCommand(String command) {
      _sendCommand(command);
      holdingButton = true;
    }

    void _stopCommand() {
      if (holdingButton) {
        _sendCommand('/control?id=S');
        holdingButton = false;
      }
    }

    return GestureDetector(
      onTapDown: (_) => _startCommand(command),
      onTapUp: (_) => _stopCommand(),
      child: Container(
          width: MediaQuery.sizeOf(context).width / 4,
          height: MediaQuery.sizeOf(context).height / 4,
          child: Image.asset(
            icon,
            fit: BoxFit.contain,
          )),
    );
  }
}
