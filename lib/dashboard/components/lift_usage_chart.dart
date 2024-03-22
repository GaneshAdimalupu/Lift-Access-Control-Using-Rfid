import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_auth/services/firestore_service.dart';

class LiftUsageChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalesData>>(
      future: FirestoreService.getLiftUsageData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<SalesData> liftUsageData = snapshot.data ?? [];

        return Container(
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(text: "Lift Usage"),
            primaryXAxis: DateTimeAxis(),
            primaryYAxis: CategoryAxis(),
            series: <ChartSeries>[
              SplineSeries<SalesData, DateTime>(
                dataSource: liftUsageData,
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.collegeID,
              ),
            ],
          ),
        );
      },
    );
  }
}
