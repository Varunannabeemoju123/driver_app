import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travels_app/screens/driver/advance_screen.dart';
import 'fuel_screen.dart';
import 'bank_screen.dart';
import 'attendance_screen.dart';
import 'performance_screen.dart';
import 'TripsScreen.dart'; // ✅ NEW

// ... all your imports stay the same

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String driverName = '';
  String contact = 'N/A';
  String vehicleNo = 'N/A';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  Future<void> fetchDriverDetails() async {
    final ref = FirebaseDatabase.instance.ref('drivers/${widget.uid}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as dynamic);
      setState(() {
        driverName = data['name'] ?? 'N/A';
        contact = data['contact'] ?? '';
        vehicleNo = data['vehicleNo'] ?? 'N/A';
        isLoading = false;
      });
    } else {
      setState(() {
        driverName = 'Unknown Driver';
        isLoading = false;
      });
    }
  }

  Widget customButton(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.white,
            elevation: 4,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text(label, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget driverInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Driver ID: ${widget.uid}", style: const TextStyle(color: Colors.black)),
          Text("Name: $driverName", style: const TextStyle(color: Colors.black)),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: kToolbarHeight + 10, bottom: 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // Removed: Driver Fleet App title
                  driverInfoCard(),
                  customButton('Start Trip', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripsScreen(driverId: widget.uid),
                      ),
                    );
                  }),
                  customButton('Fuel', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FuelScreen(driverId: widget.uid),
                      ),
                    );
                  }),
                  customButton('Attendance', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendanceScreen(
                          driverId: widget.uid,
                          driverName: driverName,
                        ),
                      ),
                    );
                  }),
                  customButton('Bank A/C & Docs', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BankScreen(driverId: widget.uid),
                      ),
                    );
                  }),
                  customButton('Advance', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdvanceScreen(driverId: widget.uid),
                      ),
                    );
                  }),
                  customButton('Performance', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PerformanceScreen(driverId: widget.uid),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
