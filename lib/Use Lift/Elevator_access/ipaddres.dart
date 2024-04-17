import 'package:Elivatme/Use%20Lift/Elevator_access/lift_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class IpAddress extends StatefulWidget {
  const IpAddress({
    Key? key,
  }) : super(key: key);
  @override
  State<IpAddress> createState() => _IpAddressState();
}

class _IpAddressState extends State<IpAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Center(
            child: GameIdInput(),
          ),
        ));
  }
}

class GameIdInput extends StatefulWidget {
  @override
  _GameIdInputState createState() => _GameIdInputState();
}

class _GameIdInputState extends State<GameIdInput> {
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: _urlController,
            onChanged: (text) {},
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Enter IP Address',
              hintText: 'eg: 193.38.18',
              filled: true,
              labelStyle: const TextStyle(
                color: Color.fromRGBO(200, 198, 188, 1),
              ),
              helperStyle: const TextStyle(
                color: Color.fromRGBO(200, 198, 188, 1),
              ),
              hintStyle: const TextStyle(
                color: Color.fromRGBO(200, 198, 188, 1),
              ),
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.videogame_asset,
                color: Color.fromARGB(255, 24, 198, 120),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Color.fromARGB(255, 24, 198, 120),
                ),
                onPressed: () {
                  _urlController.clear();
                },
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            style: TextStyle(
              color: Color.fromRGBO(200, 198, 188, 1),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: GestureDetector(
                onTap: () {
                  if (_urlController.text != "") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MonitoringPage(
                          ipAddres: _urlController.text,
                        ), // Replace with your home screen widget
                      ),
                    );
                  }
                },
                child: Image.asset(
                  "assets/images/use_lift.png",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
