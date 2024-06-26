import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late PageController _controller; // Define _controller here

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.8,
      keepPage: true,
      initialPage: 0, // Set initial page to 0
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.page == 5) {
        _controller.jumpToPage(0);
      } else {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
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
            itemCount: 6,
            controller: _controller,
            itemBuilder: (_, index) {
              return _buildPage(index);
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 6,
            effect: const JumpingDotEffect(
              dotHeight: 16,
              dotWidth: 16,
              jumpScale: .7,
              verticalOffset: 15,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const StackedRadialBarChart(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage(int index) {
    final List<String> images = [
      'assets/images/pic1.jpeg',
      'assets/images/pic2.jpg',
      'assets/images/pic3.jpg',
      'assets/images/pic4.jpg',
      'assets/images/pic5.jpg',
      'assets/images/pic8.jpg',
      'assets/images/pic9.jpg',
      'assets/images/pic7.jpg',
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add any content or widgets you want to display on top of the image
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class StackedRadialBarChartWidget extends StatelessWidget {
//   const StackedRadialBarChartWidget({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<LiftUsage>>(
//       future: FirestoreService.getLiftUsageDataForCurrentUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError || snapshot.data!.isEmpty) {
//           return const Center(
//               child: Text(
//             'No lift usage data available.',
//             style: TextStyle(color: Colors.white),
//           ));
//         }

//         Map<String, int> liftUsageByDate = {};
//         for (var liftUsage in snapshot.data!) {
//           String date = DateFormat('dd/MM').format(liftUsage.timestamp);
//           liftUsageByDate[date] = (liftUsageByDate[date] ?? 0) + 1;
//         }

//         var sortedKeys = liftUsageByDate.keys.toList()
//           ..sort((a, b) {
//             var aDate = DateFormat('dd/MM').parse(a);
//             var bDate = DateFormat('dd/MM').parse(b);
//             return aDate.compareTo(bDate);
//           });
//         Map<String, int> sortedLiftUsageByDate = Map.fromIterable(
//           sortedKeys,
//           key: (key) => key,
//           value: (key) => liftUsageByDate[key]!,
//         );

//         sortedLiftUsageByDate = _addPadding(sortedLiftUsageByDate);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 16),
//             Text(
//               'Your Lift Usage',
//               style: Theme.of(context).textTheme.headline6!.copyWith(
//                     color: Colors.white,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(0, 63, 63, 127),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               // child: Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //   children: [
//               //     _buildChartButton('Daily', () {
//               //       // Implement method to fetch daily data
//               //     }),
//               //     _buildChartButton('Monthly', () {
//               //       // Implement method to fetch monthly data
//               //     }),
//               //     _buildChartButton('Yearly', () {
//               //       // Implement method to fetch yearly data
//               //     }),
//               //   ],
//               // ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               height: 300,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: SizedBox(
//                   width: (sortedLiftUsageByDate.length - 2) * 80.0,
//                   height: 300,
//                   child: _buildChart(sortedLiftUsageByDate),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildChartButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Text(text, style: TextStyle(color: Colors.white)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   Widget _buildChart(Map<String, int> liftUsageByDate) {
//     return SfCartesianChart(
//       title: ChartTitle(text: ''),
//       legend: Legend(isVisible: false),
//       margin: const EdgeInsets.all(10),
//       primaryXAxis: CategoryAxis(
//         labelRotation: 0,
//         labelPlacement: LabelPlacement.onTicks,
//         majorGridLines: const MajorGridLines(width: 0),
//         majorTickLines: const MajorTickLines(color: Colors.green),
//         axisLine: const AxisLine(color: Colors.blue),
//         labelStyle: TextStyle(color: Colors.white),
//       ),
//       primaryYAxis: NumericAxis(
//         minimum: 0,
//         maximum: liftUsageByDate.values.reduce(max) + 2,
//         interval: 1,
//         majorGridLines: const MajorGridLines(width: 0),
//         majorTickLines: const MajorTickLines(color: Colors.green),
//         axisLine: const AxisLine(color: Colors.red),
//         labelStyle: TextStyle(color: Colors.white),
//       ),
//       plotAreaBorderWidth: 0,
//       series: <ChartSeries>[
//         ColumnSeries<MapEntry<String, int>, String>(
//           dataSource: liftUsageByDate.entries.toList(),
//           xValueMapper: (entry, i) => entry.key,
//           yValueMapper: (entry, i) => entry.value.toDouble(),
//           dataLabelSettings: const DataLabelSettings(
//             isVisible: true,
//             labelAlignment: ChartDataLabelAlignment.outer,
//             textStyle: TextStyle(
//               // Set text style for data labels
//               color: Colors.white,
//             ), // Set text color to white
//           ),
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.blueAccent,
//         ),
//       ],
//     );
//   }

//   Map<String, int> _addPadding(Map<String, int> data) {
//     Map<String, int> paddedData = {'': 0};
//     paddedData.addAll(data);
//     paddedData[' '] = 0;
//     return paddedData;
//   }
// }

// enum ChartType {
//   column,
// }


class StackedRadialBarChart extends StatefulWidget {
  const StackedRadialBarChart({Key? key});

  @override
  _StackedRadialBarChartState createState() => _StackedRadialBarChartState();
}

class _StackedRadialBarChartState extends State<StackedRadialBarChart> {
  late Future<List<LiftUsage>> _liftUsageFuture;
  late Future<int> _userCountFuture;
  ChartType _selectedChartType = ChartType.column;

  @override
  void initState() {
    super.initState();
    _liftUsageFuture = FirestoreService.getLiftUsageDataForCurrentUser();
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
          return const Center(
              child: Text(
            'No lift usage data available.',
            style:
                TextStyle(color: Colors.white), // Set the text color to white
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
                    value: _selectedChartType,
                    onChanged: (value) {
                      setState(() {
                        _selectedChartType = value!;
                      });
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
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
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
        LineSeries<MapEntry<String, int>, String>(
          dataSource: liftUsageByDate.entries.toList(),
          xValueMapper: (entry, i) => entry.key,
          yValueMapper: (entry, i) => entry.value.toDouble(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: TextStyle(
              // Set text style for data labels
              color: Colors.white, // Set text color to white
            ),
          ),
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
  line,
}

class StackedRadialBarChartWidget extends StatelessWidget {
  final List<LiftUsage> liftUsageData;
  final int userCount;

  const StackedRadialBarChartWidget(this.liftUsageData, this.userCount,
      {Key? key});

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
            textStyle: TextStyle(
              color: Colors.white,
            ),
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
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
}

class UserUsageData {
  final String userName;
  final int usageCount;

  UserUsageData(this.userName, this.usageCount);
}
