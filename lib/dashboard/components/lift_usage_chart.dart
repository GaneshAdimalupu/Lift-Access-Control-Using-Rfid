import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_auth/services/firestore_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiftUsageChart extends StatelessWidget {
  const LiftUsageChart({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LiftUsage>>(
      future: FirestoreService.getLiftUsageData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No lift usage data available.'));
        }

        // Sort lift usage data by timestamp in ascending order
        snapshot.data!.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Find the minimum and maximum usage counts
        num minUsageCount = snapshot.data!.map((usage) => usage.usageCount).reduce((a, b) => a < b ? a : b);
        num maxUsageCount = snapshot.data!.map((usage) => usage.usageCount).reduce((a, b) => a > b ? a : b);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              SizedBox(
                height: 300, // Height of the chart
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2, // Set the width of the chart
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat('dd/MM'),
                        intervalType: DateTimeIntervalType.days,
                        interval: 1,
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: minUsageCount.toDouble(), // Set the minimum usage count
                        maximum: maxUsageCount.toDouble(), // Set the maximum usage count
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      series: _buildSeries(snapshot.data!),
                      tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltips
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add some spacing between the chart and Y-axis
              const Text('Usage Count'), // Y-axis label
            ],
          ),
        );
      },
    );
  }

  List<LineSeries<LiftUsage, DateTime>> _buildSeries(List<LiftUsage> liftUsageData) {
    return [
      LineSeries<LiftUsage, DateTime>(
        dataSource: liftUsageData,
        xValueMapper: (LiftUsage usage, _) => usage.timestamp,
        yValueMapper: (LiftUsage usage, _) => usage.usageCount,
        dataLabelSettings: const DataLabelSettings(isVisible: false), // Remove usage count labels
      ),
    ];
  }
}
