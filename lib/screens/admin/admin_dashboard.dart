import 'package:flutter/material.dart';
import 'package:travels_app/models/fuel_log_model.dart';
import 'package:travels_app/screens/admin/mileage_dashboard.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Widget buildTile(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 26),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: Colors.black54,
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.deepPurple.shade600.withOpacity(0.9),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FuelLog> fuelLogs = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: Stack(
        children: [
          // 🔷 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/adminbackground.png"), // ✅ your path here
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔷 Foreground content with translucent background
          Container(
            color: Colors.black.withOpacity(0.4),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                buildTile("Driver Management", Icons.person, () {
                  Navigator.pushNamed(context, '/admin/drivers');
                }),
                buildTile("Vehicle Management", Icons.directions_bus, () {
                  Navigator.pushNamed(context, '/admin/vehicles');
                }),
                buildTile("Billing", Icons.receipt_long, () {
                  Navigator.pushNamed(context, '/admin/billing');
                }),
                buildTile("Attendance", Icons.calendar_today, () {
                  Navigator.pushNamed(context, '/admin/attendance');
                }),
                buildTile("Mileage Dashboard", Icons.speed, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MileageDashboard(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
