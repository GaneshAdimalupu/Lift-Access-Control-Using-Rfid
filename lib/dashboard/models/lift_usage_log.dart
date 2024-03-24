// import 'package:flutter/material.dart';
// import 'package:flutter_auth/services/firestore_service.dart';
// import 'package:intl/intl.dart';

// class LiftUsageLogScreen extends StatelessWidget {
//   const LiftUsageLogScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lift Usage Log'),
//       ),
//       body: FutureBuilder<List<LiftUsage>>(
//         future: FirestoreService.getLiftUsageData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No lift usage data available.'));
//           }
//           // Sort lift usage data by timestamp in descending order
//           snapshot.data!.sort((a, b) => b.timestamp.compareTo(a.timestamp));
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final liftUsage = snapshot.data![index];
//               return ListTile(
//                 title: Text('College ID: ${liftUsage.collegeID}'),
//                 subtitle: Text(
//                     'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp)}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }






import 'dart:io'; // Add this import statement
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_auth/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class LiftUsageLogScreen extends StatelessWidget {
  const LiftUsageLogScreen({Key? key}) : super(key: key); // Corrected constructor definition

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lift Usage Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context);
            },
          ),
        ],
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

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    final List<LiftUsage> liftUsageData = await FirestoreService.getLiftUsageData();

    if (liftUsageData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No lift usage data available to download.'),
      ));
      return;
    }

    pdf.addPage(pw.Page(
      build: (context) {
        return pw.Column(
          children: [
            pw.Text('Lift Usage Log', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            for (final liftUsage in liftUsageData)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('College ID: ${liftUsage.collegeID}'),
                  pw.Text('Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp)}'),
                  pw.Divider(),
                ],
              ),
          ],
        );
      },
    ));

    final bytes = await pdf.save();
    final Uint8List data = Uint8List.fromList(bytes);

    const pdfFileName = 'lift_usage_log.pdf';
    const pdfPath = '/storage/emulated/0/$pdfFileName'; // Change this path to your desired directory

    final pdfFile = await File(pdfPath).writeAsBytes(data);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('PDF downloaded successfully: $pdfPath'),
    ));
  }
}
