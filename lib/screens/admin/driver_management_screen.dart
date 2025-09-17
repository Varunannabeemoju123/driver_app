import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'AssignTripScreen.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('drivers');

  List<Map<String, String>> drivers = [];

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  void fetchDrivers() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, String>> loadedDrivers = [];

      data.forEach((key, value) {
        final driverData = value as Map;
        loadedDrivers.add({
          'id': key,
          'name': driverData['name'] ?? '',
          'vehicleNumber': driverData['vehicleNumber'] ?? '',
          'phone': driverData['phone'] ?? '',
        });
      });

      setState(() {
        drivers = loadedDrivers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Management')),
      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/adminbackground.png',
              fit: BoxFit.cover,
            ),
          ),
          // 🔹 Main content over background
          drivers.isEmpty
              ? const Center(child: Text("No driver data available", style: TextStyle(color: Colors.white)))
              : ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(driver['name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${driver['id']}"),
                      Text("Phone: ${driver['phone']}"),
                      Text("Vehicle No: ${driver['vehicleNumber']}"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignTripScreen(
                            driverId: driver['id']!,
                            driverName: driver['name']!,
                            vehicleNumber: driver['vehicleNumber']!,
                          ),
                        ),
                      );
                    },
                    child: const Text("Assign"),
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
