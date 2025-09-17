import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  final String driverId;
  final String driverName;

  const AttendanceScreen({
    super.key,
    required this.driverId,
    required this.driverName,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<DateTime> markedDates = [];
  final List<Map<String, String>> attendanceLogs = [];

  DateTime selectedDate = DateTime.now();
  bool isMarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfMarked(selectedDate);
  }

  void _checkIfMarked(DateTime date) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      isMarked = attendanceLogs.any((log) => log['date'] == formatted);
    });
  }

  void _markAttendance() async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    if (attendanceLogs.any((log) => log['date'] == formattedDate)) return;

    await AttendanceService.markAttendance(
      driverId: widget.driverId,
      name: widget.driverName,
      date: selectedDate,
      status: "Present",
    );

    setState(() {
      markedDates.add(selectedDate);
      attendanceLogs.insert(0, {
        'date': formattedDate,
        'day': DateFormat('EEEE').format(selectedDate),
        'status': "Present"
      });
      isMarked = true;
    });
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        itemCount: 30,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: 29 - index));
          final formatted = DateFormat('yyyy-MM-dd').format(date);
          final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == formatted;
          final isMarked = attendanceLogs.any((log) => log['date'] == formatted);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
                _checkIfMarked(date);
              });
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isMarked
                    ? Colors.green
                    : isToday
                    ? Colors.purple.shade100
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selectedDate == date ? Colors.purple : Colors.grey,
                ),
              ),
              child: Center(
                child: Text(
                  DateFormat('d').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: attendanceLogs.map((log) {
        return ListTile(
          title: Text(
            'Date: ${log['date']}',
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            'Day: ${log['day']} | Status: ${log['status']}',
            style: const TextStyle(color: Colors.black87),
          ),
          leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isMarked ? null : _markAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Mark Attendance"),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.black),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Attendance Logs",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: attendanceLogs.isEmpty
                    ? const Center(
                  child: Text("No logs yet.", style: TextStyle(color: Colors.black)),
                )
                    : SingleChildScrollView(child: _buildLogList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
