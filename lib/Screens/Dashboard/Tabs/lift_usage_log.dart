import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:Elivatme/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class LiftUsageLogScreen extends StatelessWidget {
  const LiftUsageLogScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B0E41),
        title: const Text(
          'Lift Usage Log',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF1B0E41),
        child: FutureBuilder<List<LiftUsage>>(
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
                return LiftUsageCard(
                  liftUsage: liftUsage,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    final List<LiftUsage> liftUsageData =
        await FirestoreService.getLiftUsageData();

    if (liftUsageData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No lift usage data available to download.'),
        ),
      );
      return;
    }

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Lift Usage Log',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              for (final liftUsage in liftUsageData)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('College ID: ${liftUsage.collegeID}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp)}'),
                    pw.Divider(),
                  ],
                ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final Uint8List data = Uint8List.fromList(bytes);

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to access storage.'),
        ),
      );
      return;
    }

    final pdfPath = '${directory.path}/lift_usage_log.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF downloaded successfully: $pdfPath'),
      ),
    );
  }
}

class LiftUsageCard extends StatelessWidget {
  final LiftUsage liftUsage;

  const LiftUsageCard({required this.liftUsage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add your logic for handling tap on each lift usage card
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color.fromRGBO(30, 30, 30, .95),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'College ID: ${liftUsage.collegeID}',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp)}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
