import 'package:firebase_database/firebase_database.dart';
import '../models/attendance_data.dart';

class AttendanceService {
  static final _db = FirebaseDatabase.instance.ref().child("attendance_logs");

  static Future<void> markAttendance({
    required String driverId,
    required String name,
    required DateTime date,
    required String status,
  }) async {
    final key = "${driverId}_${date.toIso8601String().split('T')[0]}";
    await _db.child(key).set({
      'driverId': driverId,
      'name': name,
      'dateTime': date.toIso8601String(),
      'status': status,
    });
  }

  static Future<List<AttendanceEntry>> fetchAllAttendanceLogs() async {
    final snapshot = await _db.get();
    List<AttendanceEntry> logs = [];

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        logs.add(AttendanceEntry.fromMap(value));
      });
      logs.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }

    return logs;
  }
}
