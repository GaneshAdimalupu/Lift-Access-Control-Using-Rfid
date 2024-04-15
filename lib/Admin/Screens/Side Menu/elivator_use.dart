import 'package:flutter/material.dart';

class ElevatorPage extends StatefulWidget {
  final int numberOfFloors;

  ElevatorPage({required this.numberOfFloors});

  @override
  _ElevatorPageState createState() => _ElevatorPageState();
}

class _ElevatorPageState extends State<ElevatorPage> {
  int? selectedFloor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elevator Buttons'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.numberOfFloors,
                itemBuilder: (context, index) {
                  final floorNumber = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFloor = floorNumber;
                      });
                      // Add your code here to handle elevator action or signal
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedFloor == floorNumber ? Color.fromARGB(255, 31, 194, 220) : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            floorNumber == 0 ? 'G' : floorNumber.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selectedFloor == floorNumber ? Colors.white : Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.grey,
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.grey,
                          ),
                          Text(
                            'Moving',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
