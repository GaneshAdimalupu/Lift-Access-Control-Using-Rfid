import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_auth/services/firestore_service.dart';

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
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<LiftUsage> liftUsageData = snapshot.data ?? [];

        // Count the occurrences of lift usage for each college ID
        Map<String, int> liftUsageCount = {};
        for (var usage in liftUsageData) {
          liftUsageCount.update(usage.collegeID, (value) => value + 1, ifAbsent: () => 1);
        }

        // Convert the map into a list of data points
        List<ChartData> chartData = [];
        liftUsageCount.forEach((collegeID, count) {
          chartData.add(ChartData(collegeID, count));
        });

        return SizedBox(
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(text: "Lift Usage"),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: <ChartSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.collegeID,
                yValueMapper: (ChartData data, _) => data.count,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChartData {
  final String collegeID;
  final int count;

  ChartData(this.collegeID, this.count);
}
