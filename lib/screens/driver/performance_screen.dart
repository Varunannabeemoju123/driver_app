import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  final String driverId;

  const PerformanceScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  List<Map<String, dynamic>> fuelLogs = [];

  double getAttendancePercentage() {
    // Dummy calculation
    int presentDays = 18;
    int totalDays = 30;
    return (presentDays / totalDays) * 100;
  }

  double getAverageMileage() {
    if (fuelLogs.isEmpty) return 0.0;

    double totalMileage = 0.0;
    int count = 0;

    for (var log in fuelLogs) {
      if (log['mileage'] != null && log['mileage'] is num) {
        double mileage = log['mileage'].toDouble();
        if (mileage > 0) {
          totalMileage += mileage;
          count++;
        }
      }
    }

    return count > 0 ? (totalMileage / count) : 0.0;
  }

  @override
  void initState() {
    super.initState();

    // Simulated data
    fuelLogs = [
      {'mileage': 12.5},
      {'mileage': null},
      {'mileage': 15.3},
      {'mileage': 0},
      {'mileage': 14.0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    double attendance = getAttendancePercentage();
    double avgMileage = getAverageMileage();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Performance Overview",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCircularPerformance(
                          "Attendance", attendance.toInt(), Colors.green),
                      _buildCircularPerformance(
                          "Mileage", avgMileage.toInt(), Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPerformance(
      String label, int percent, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              "$percent%",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
