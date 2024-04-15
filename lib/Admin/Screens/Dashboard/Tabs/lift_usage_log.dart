import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:Elivatme/Admin/Services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class LiftUsageLogScreen extends StatefulWidget {
  const LiftUsageLogScreen({Key? key}) : super(key: key);

  @override
  _LiftUsageLogScreenState createState() => _LiftUsageLogScreenState();
}

class _LiftUsageLogScreenState extends State<LiftUsageLogScreen> {
  bool _isSortedByDate = false;
  bool _isSortedByName = false;
  bool _isSortedByCollegeID = false;
  TextEditingController _searchController = TextEditingController();
  List<LiftUsage> _liftUsageData = [];

  @override
  void initState() {
    super.initState();
    _loadLiftUsageData();
  }

  Future<void> _loadLiftUsageData() async {
    final data = await FirestoreService.getLiftUsageData();
    setState(() {
      _liftUsageData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B0E41),
        title: const Text(
          'Lift Usage Log',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF1B0E41),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  _filterData(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _liftUsageData.length,
                itemBuilder: (context, index) {
                  final liftUsage = _liftUsageData[index];
                  return LiftUsageCard(
                    liftUsage: liftUsage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterData(String query) {
    setState(() {
      _liftUsageData = _liftUsageData.where((liftUsage) {
        final collegeID = liftUsage.collegeID.toString().toLowerCase();
        final fullName = liftUsage.fullName.toLowerCase();
        final formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(liftUsage.timestamp);
        return collegeID.contains(query.toLowerCase()) ||
            fullName.contains(query.toLowerCase()) ||
            formattedDate.contains(query.toLowerCase());
      }).toList();
    });
  }

  // Method to sort lift usage data based on selected sorting option
  List<LiftUsage> _getSortedData(List<LiftUsage> data) {
    if (_isSortedByDate) {
      data.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else if (_isSortedByName) {
      data.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if (_isSortedByCollegeID) {
      data.sort((a, b) => a.collegeID.compareTo(b.collegeID));
    }
    return data;
  }

  // Method to show sorting options dialog
  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Date'),
                onTap: () {
                  setState(() {
                    _isSortedByDate = true;
                    _isSortedByName = false;
                    _isSortedByCollegeID = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Name'),
                onTap: () {
                  setState(() {
                    _isSortedByDate = false;
                    _isSortedByName = true;
                    _isSortedByCollegeID = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('College ID'),
                onTap: () {
                  setState(() {
                    _isSortedByDate = false;
                    _isSortedByName = false;
                    _isSortedByCollegeID = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
