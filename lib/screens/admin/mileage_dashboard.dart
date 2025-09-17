import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MileageDashboard extends StatefulWidget {
  const MileageDashboard({Key? key}) : super(key: key);

  @override
  State<MileageDashboard> createState() => _MileageDashboardState();
}

class _MileageDashboardState extends State<MileageDashboard> {
  final DatabaseReference fuelRef = FirebaseDatabase.instance.ref('fuel_logs');
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('driver_users');
  final DatabaseReference mileageLogRef = FirebaseDatabase.instance.ref('mileage_logs');

  bool isLoading = true;

  // Map<driverUid, {name, vehicle, avgMileage}>
  final Map<String, Map<String, dynamic>> driverMileageMap = {};

  @override
  void initState() {
    super.initState();
    fetchAndStoreMileageData();
  }

  Future<void> fetchAndStoreMileageData() async {
    final fuelSnapshot = await fuelRef.get();
    final userSnapshot = await userRef.get();

    if (fuelSnapshot.exists && userSnapshot.exists) {
      final fuelData = Map<String, dynamic>.from(fuelSnapshot.value as Map);
      final userData = Map<String, dynamic>.from(userSnapshot.value as Map);

      for (final driverUid in fuelData.keys) {
        final logs = Map<String, dynamic>.from(fuelData[driverUid]);

        List<double> mileages = [];

        logs.forEach((logId, logDataRaw) {
          final logData = Map<String, dynamic>.from(logDataRaw);
          final mileage = double.tryParse(logData['mileage'].toString()) ?? 0.0;
          if (mileage > 0) {
            mileages.add(mileage);
          }
        });

        if (mileages.isNotEmpty && userData.containsKey(driverUid)) {
          final driverDetails = Map<String, dynamic>.from(userData[driverUid]);
          final name = driverDetails['name'] ?? 'Unknown';
          final vehicle = driverDetails['vehicleNumber'] ?? 'Unknown';

          final average = mileages.reduce((a, b) => a + b) / mileages.length;

          // Save to Firebase under mileage_logs/
          await mileageLogRef.child(driverUid).set({
            'driverName': name,
            'vehicleNumber': vehicle,
            'averageMileage': average
          });

          driverMileageMap[driverUid] = {
            'driverName': name,
            'vehicleNumber': vehicle,
            'averageMileage': average
          };
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mileage Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/adminbackground.png', // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : driverMileageMap.isEmpty
              ? const Center(child: Text("No mileage data found.", style: TextStyle(color: Colors.white)))
              : ListView.builder(
            itemCount: driverMileageMap.length,
            itemBuilder: (context, index) {
              final uid = driverMileageMap.keys.elementAt(index);
              final data = driverMileageMap[uid]!;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  leading: const Icon(Icons.speed, color: Colors.orange),
                  title: Text("Driver: ${data['driverName']}", style: const TextStyle(color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle: ${data['vehicleNumber']}", style: const TextStyle(color: Colors.black87)),
                      Text("Avg Mileage: ${data['averageMileage'].toStringAsFixed(2)} km/L", style: const TextStyle(color: Colors.black87)),
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
