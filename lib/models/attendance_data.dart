import 'package:flutter/material.dart';

class AttendanceEntry {
  final String driverId;
  final String name;
  final DateTime dateTime;
  final String status;

  AttendanceEntry({
    required this.driverId,
    required this.name,
    required this.dateTime,
    required this.status,
  });

  factory AttendanceEntry.fromMap(Map<dynamic, dynamic> data) {
    return AttendanceEntry(
      driverId: data['driverId'] ?? '',
      name: data['name'] ?? '',
      dateTime: DateTime.parse(data['dateTime']),
      status: data['status'] ?? 'Absent',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
    };
  }
}
