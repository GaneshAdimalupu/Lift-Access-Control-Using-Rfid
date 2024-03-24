import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_auth/services/firestore_service.dart';
// import 'package:flutter_auth/dashboard/components/sample.dart';
// future: Future.delayed(Duration(seconds: 1), () => generateSampleData(50)), // Generate 30 days of sample data with a delay of 1 second


class LiftUsageChart extends StatelessWidget {
  const LiftUsageChart({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LiftUsage>>(
      future: FirestoreService.getLiftUsageData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No lift usage data available.'));
        }

        // Sort lift usage data by timestamp in ascending order
        snapshot.data!.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: snapshot.data!.length * 50.0,
                    height: 300,
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Lift Usage'),
                      legend: Legend(isVisible: false),
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
                child: Text(
                  'User:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No user data available.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData['fullName'] ?? 'Unknown',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Email: ${userData['email'] ?? 'Unknown'}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'College ID: ${userData['collegeID'] ?? 'Unknown'}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
