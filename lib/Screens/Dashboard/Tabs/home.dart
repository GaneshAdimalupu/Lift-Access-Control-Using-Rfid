import 'dart:async';
import 'dart:math';

import 'package:Elivatme/components/dashboard/components/header.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Elivatme/Screens/smooth%20page/src/effects/jumping_dot_effect.dart';
import 'package:Elivatme/Screens/smooth%20page/src/smooth_page_indicator.dart';
import 'package:Elivatme/constants.dart';
import 'package:Elivatme/main.dart';
import 'package:Elivatme/services/firestore_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SmoothScreen extends StatelessWidget {
  const SmoothScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final themeMode = themeNotifier.getThemeMode();

        return ThemeProvider(
          initTheme: MyThemes.lightTheme,
          duration: const Duration(milliseconds: 500),
          builder: (context, themeSwitcher) {
            final Brightness systemBrightness =
                MediaQuery.of(context).platformBrightness;

            return MaterialApp(
              theme: themeMode == ThemeMode.dark ||
                      systemBrightness == Brightness.dark
                  ? MyThemes.darkTheme
                  : MyThemes.lightTheme,
              home: Scaffold(
                backgroundColor: Color(0xFF1B0E41), // Set background color here
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
              ),
              debugShowCheckedModeBanner: false, // Remove debug banner
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller =
      PageController(viewportFraction: 0.8, keepPage: true);
  List<Map<String, dynamic>> _usersData = [];
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final List<DocumentSnapshot> usersDocs = usersSnapshot.docs;
      final List<Map<String, dynamic>> userData =
          usersDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      setState(() {
        _usersData = userData;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving user data: $e');
      // Log error for debugging
      Fluttertoast.showToast(msg: "Error retrieving user data:");
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _usersData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _usersData.map<Widget>((userData) {
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
                  'Name: ${userData['fullName']}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                Text(
                  'Email: ${userData['email']}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                Text(
                  'College ID: ${userData['collegeID']}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (_, index) {
              return pages[index % pages.length];
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: SmoothPageIndicator(
            controller: _controller,
            count: pages.length,
            effect: const JumpingDotEffect(
              dotHeight: 16,
              dotWidth: 16,
              jumpScale: .7,
              verticalOffset: 15,
            ),
          ),
        ),
        const StackedRadialBarChart(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class StackedRadialBarChart extends StatefulWidget {
  const StackedRadialBarChart({super.key});

  @override
  _StackedRadialBarChartState createState() => _StackedRadialBarChartState();
}

class _StackedRadialBarChartState extends State<StackedRadialBarChart> {
  late Future<List<LiftUsage>> _liftUsageFuture;
  late Future<int> _userCountFuture;
  ChartType _selectedChartType = ChartType.column; // Default chart type

  @override
  void initState() {
    super.initState();
    _liftUsageFuture = FirestoreService.getLiftUsageData();
    _userCountFuture = FirestoreService.getUserCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LiftUsage>>(
      future: _liftUsageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Center(child: Text('No lift usage data available.'));
        }

        // Group lift usage data by date and calculate total count for each date
        Map<String, int> liftUsageByDate = {};
        for (var liftUsage in snapshot.data!) {
          String date = DateFormat('dd/MM').format(liftUsage.timestamp);
          liftUsageByDate[date] =
              (liftUsageByDate[date] ?? 0) + 1; // Increment count for each date
        }

        // Sort liftUsageByDate map keys by date
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

        // Adding padding at the beginning and end
        sortedLiftUsageByDate = addPadding(sortedLiftUsageByDate);

        return FutureBuilder<int>(
          future: _userCountFuture,
          builder: (context, userCountSnapshot) {
            if (userCountSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userCountSnapshot.hasError) {
              return const Center(child: Text('Failed to retrieve user count'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Over All Lift Usage',
                  style: Theme.of(context).textTheme.titleLarge!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                DropdownButton<ChartType>(
                  value: _selectedChartType,
                  onChanged: (value) {
                    setState(() {
                      _selectedChartType = value!;
                    });
                  },
                  items: ChartType.values.map((type) {
                    return DropdownMenuItem<ChartType>(
                      value: type,
                      child: Text(type.toString()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: (sortedLiftUsageByDate.length - 2) *
                          80.0, // Adjust width based on number of dates
                      height: 300,
                      child: _buildChart(
                        sortedLiftUsageByDate,
                        userCountSnapshot.data!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'User Lift Usage Pie Chart',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ),
                const SizedBox(height: 10),
                StackedRadialBarChartWidget(
                  snapshot.data!,
                  userCountSnapshot.data!,
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChart(Map<String, int> liftUsageByDate, int userCount) {
    switch (_selectedChartType) {
      case ChartType.column:
        return _buildColumnChart(liftUsageByDate);
      case ChartType.line:
        return _buildLineChart(liftUsageByDate);
      // case ChartType.lineByHour:
      //   return _buildLineChartByHour(liftUsageByDate);
      // Add more chart types as needed
    }
  }

  Widget _buildColumnChart(Map<String, int> liftUsageByDate) {
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
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: liftUsageByDate.values.reduce(max) + 2,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.green),
        axisLine: const AxisLine(color: Colors.red),
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
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildLineChart(Map<String, int> liftUsageByDate) {
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
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: liftUsageByDate.values.reduce(max) + 2,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.green),
        axisLine: const AxisLine(color: Colors.red),
      ),
      plotAreaBorderWidth: 0,
      series: <ChartSeries>[
        LineSeries<MapEntry<String, int>, String>(
          dataSource: liftUsageByDate.entries.toList(),
          xValueMapper: (entry, i) => entry.key,
          yValueMapper: (entry, i) => entry.value.toDouble(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
          ),
          color: Colors.blueAccent,
        ),
      ],
    );
  }


  Map<String, int> addPadding(Map<String, int> data) {
    // Add padding at the beginning
    Map<String, int> paddedData = {'': 0};
    paddedData.addAll(data);
    // Add padding at the end
    paddedData[' '] = 0;
    return paddedData;
  }
}

enum ChartType {
  column,
  line,
  // lineByHour,
  // Add more chart types as needed
}

class StackedRadialBarChartWidget extends StatelessWidget {
  final List<LiftUsage> liftUsageData;
  final int userCount;

  const StackedRadialBarChartWidget(this.liftUsageData, this.userCount,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, int> userUsageCount = {};
    for (var usage in liftUsageData) {
      userUsageCount.update(
        usage.fullName,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    List<UserUsageData> chartData = userUsageCount.entries
        .map((entry) => UserUsageData(entry.key, entry.value))
        .toList();

    return Center(
      child: SizedBox(
        height: 300,
        child: SfCircularChart(
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
          ),
          series: <CircularSeries<UserUsageData, String>>[
            PieSeries<UserUsageData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.userName,
              yValueMapper: (data, _) => data.usageCount.toDouble(),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              pointColorMapper: (data, _) => _getUserColor(data.userName),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserColor(String userName) {
    final random = Random(userName.hashCode);
    return Color.fromRGBO(
      random.nextInt(256), // Red component (0-255)
      random.nextInt(256), // Green component (0-255)
      random.nextInt(256), // Blue component (0-255)
      1, // Opacity (0.0-1.0)
    );
  }
}

class UserUsageData {
  final String userName;
  final int usageCount;

  UserUsageData(this.userName, this.usageCount);
}
