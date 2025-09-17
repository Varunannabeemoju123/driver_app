import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  final DatabaseReference _driversRef = FirebaseDatabase.instance.ref().child('drivers');
  List<Map<String, dynamic>> _drivers = [];

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  void _fetchDrivers() {
    _driversRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> temp = [];
        data.forEach((key, value) {
          temp.add(Map<String, dynamic>.from(value));
        });
        setState(() {
          _drivers = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Management")

      ),

      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/adminbackground.png', // Make sure this matches your file path
              fit: BoxFit.cover,
            ),
          ),
          _drivers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _drivers.length,
            itemBuilder: (context, index) {
              final driver = _drivers[index];
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                color: Colors.white.withOpacity(0.9), // Slight transparency
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${driver['name'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Phone: ${driver['phone'] ?? ''}"),
                      Text("Vehicle Number: ${driver['vehicle_number'] ?? 'N/A'}"),
                      Text("Vehicle Type: ${driver['vehicle_type'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
