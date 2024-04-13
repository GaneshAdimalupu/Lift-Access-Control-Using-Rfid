import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:Elivatme/Users/Services/firestore_service.dart';
import 'package:Elivatme/Admin/Screens/Dashboard/components/header.dart';
import 'package:Elivatme/Admin/Screens/smooth%20page/src/effects/jumping_dot_effect.dart';
import 'package:Elivatme/Admin/Screens/smooth%20page/src/smooth_page_indicator.dart';

class SmoothScreen extends StatelessWidget {
  const SmoothScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B0E41),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                child: HomePage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  final PageController _controller = PageController(viewportFraction: 0.8, keepPage: true);
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.email).get();
        final userData = userSnapshot.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>?
        setState(() {
          _userData = userData;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving user data: $e');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: 1, // Display only one page
            itemBuilder: (_, __) {
              return _buildPage();
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 1, // Only one page
            effect: const JumpingDotEffect(
              dotHeight: 16,
              dotWidth: 16,
              jumpScale: .7,
              verticalOffset: 15,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const StackedRadialBarChartWidget(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 255, 0, 183),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: ${_userData?['fullName'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Email: ${_userData?['email'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'College ID: ${_userData?['collegeID'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StackedRadialBarChartWidget extends StatelessWidget {
  const StackedRadialBarChartWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LiftUsage>>(
      future: FirestoreService.getLiftUsageDataForCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
                'No lift usage data available.',
                style: TextStyle(color: Colors.white),
              ));
        }

        Map<String, int> liftUsageByDate = {};
        for (var liftUsage in snapshot.data!) {
          String date = DateFormat('dd/MM').format(liftUsage.timestamp);
          liftUsageByDate[date] = (liftUsageByDate[date] ?? 0) + 1;
        }

        var sortedKeys = liftUsageByDate.keys.toList()
          ..sort((a, b) {
            var aDate = DateFormat('dd/MM').parse(a);
            var bDate = DateFormat('dd/MM').parse(b);
            return aDate.compareTo(bDate);
          });
        Map<String, int> sortedLiftUsageByDate = Map.fromIterable(
          sortedKeys,
          key: (key) => key,
          value: (key) => liftUsageByDate[key]!,
        );

        sortedLiftUsageByDate = _addPadding(sortedLiftUsageByDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Your Lift Usage',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(0, 63, 63, 127),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<ChartType>(
                dropdownColor: Color.fromARGB(0, 20, 20, 21),
                value: ChartType.column,
                onChanged: (value) {
                  // Implement dropdown value change if needed
                },
                items: ChartType.values.map((type) {
                  return DropdownMenuItem<ChartType>(
                    value: type,
                    child: Text(
                      type.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: (sortedLiftUsageByDate.length - 2) * 80.0,
                  height: 300,
                  child: _buildChart(sortedLiftUsageByDate),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildChart(Map<String, int> liftUsageByDate) {
    return SfCartesianChart(
      title: ChartTitle(text: ''),
      legend: Legend(isVisible: false),
      margin: const EdgeInsets.all(10),
      primaryXAxis: CategoryAxis(
        labelRotation: 0,
        labelPlacement: LabelPlacement.onTicks,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.green),
        axisLine: const AxisLine(color: Colors.blue),
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: liftUsageByDate.values.reduce(max) + 2,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.green),
        axisLine: const AxisLine(color: Colors.red),
        labelStyle: TextStyle(color: Colors.white),
      ),
      plotAreaBorderWidth: 0,
      series: <ChartSeries>[
        ColumnSeries<MapEntry<String, int>, String>(
          dataSource: liftUsageByDate.entries.toList(),
          xValueMapper: (entry, i) => entry.key,
          yValueMapper: (entry, i) => entry.value.toDouble(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: TextStyle(
              // Set text style for data labels
              color: Colors.white,
            ), // Set text color to white
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueAccent,
        ),
      ],
    );
  }

  Map<String, int> _addPadding(Map<String, int> data) {
    Map<String, int> paddedData = {'': 0};
    paddedData.addAll(data);
    paddedData[' '] = 0;
    return paddedData;
  }
}

enum ChartType {
  column,
}
