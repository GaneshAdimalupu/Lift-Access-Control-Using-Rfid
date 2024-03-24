import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:flutter_auth/services/firestore_service.dart';
import 'package:flutter_auth/dashboard/components/sample.dart';
// future: Future.delayed(Duration(seconds: 1), () => generateSampleData(50)), // Generate 30 days of sample data with a delay of 1 second

class LiftUsageChart extends StatelessWidget {
  const LiftUsageChart({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LiftUsage>>(
      // future: FirestoreService.getLiftUsageData(),
      future: Future.delayed(Duration(seconds: 1), () => generateSampleData(50)), // Generate 30 days of sample data with a delay of 1 second

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No lift usage data available.'));
        }

        // Sort lift usage data by timestamp in ascending order
        snapshot.data!.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return SingleChildScrollView(
          scrollDirection:
              Axis.vertical, // Vertical scrolling for entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Lift Usage Chart',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // Set width to screen width
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Horizontal scrolling for the chart
                  child: SizedBox(
                    width: snapshot.data!.length * 50.0,
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelRotation: 45,
                        labelPlacement: LabelPlacement.onTicks,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 24,
                        interval: 1,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      series: <ChartSeries<LiftUsage, String>>[
                        LineSeries<LiftUsage, String>(
                          dataSource: snapshot.data!,
                          xValueMapper: (LiftUsage usage, _) =>
                              DateFormat('dd/MM').format(usage.timestamp),
                          yValueMapper: (LiftUsage usage, _) =>
                              usage.timestamp.hour.toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Usage Points:',
                    style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling for the list view
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final usage = snapshot.data![index];
                  return ListTile(
                    title: Text('College ID: ${usage.collegeID}'),
                    subtitle: Text(
                        'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(usage.timestamp)}'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
