import 'dart:math';

// Mock method to generate dummy LiftUsage data
List<LiftUsage> generateSampleData(int count) {
  List<LiftUsage> sampleData = [];
  DateTime now = DateTime.now();

  // Generate random usage counts and timestamps
  Random random = Random();
  for (int i = 0; i < count; i++) {
    DateTime timestamp = now.subtract(Duration(days: count - i));
    int usageCount = random.nextInt(6); // Generate random usage count between 0 and 9
    sampleData.add(LiftUsage(timestamp, 'User${i + 1}', usageCount));
  }

  return sampleData;
}
class LiftUsage {
  final DateTime timestamp;
  final String collegeID;
  final int usageCount;


  LiftUsage(this.timestamp, this.collegeID, this.usageCount);

  DateTime getTimestamp() {
    return timestamp;
  }

  String getCollegeID() {
    return collegeID;
  }

  int getYear() {
    return timestamp.year;
  }
}
