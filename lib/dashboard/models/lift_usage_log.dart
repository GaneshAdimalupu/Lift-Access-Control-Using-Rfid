import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_auth/services/firestore_service.dart';

class LiftUsageLogScreen extends StatelessWidget {
  const LiftUsageLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lift Usage Log'),
      ),
      body: FutureBuilder<List<LiftUsage>>(
        future: FirestoreService.getLiftUsageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lift usage data available.'));
          }
          // Sort lift usage data by timestamp in descending order
          snapshot.data!.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final liftUsage = snapshot.data![index];
              return ListTile(
                title: Text('College ID: ${liftUsage.collegeID}'),
                subtitle: Text(
                    'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp)}'),
              );
            },
          );
        },
      ),
    );
  }
}
