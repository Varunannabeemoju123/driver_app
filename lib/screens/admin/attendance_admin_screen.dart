import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/attendance_data.dart';
import '../../services/attendance_service.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  List<AttendanceEntry> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAttendanceLogs();
  }

  Future<void> loadAttendanceLogs() async {
    final fetchedLogs = await AttendanceService.fetchAllAttendanceLogs();
    setState(() {
      logs = fetchedLogs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/adminbackground.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text("Admin - Attendance Logs"),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : logs.isEmpty
                      ? const Center(
                    child: Text(
                      "No attendance marked yet.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final entry = logs[index];
                      final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                          .format(entry.dateTime);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(entry.name),
                          subtitle: Text(
                              'Date: $formattedDate\nStatus: ${entry.status}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
