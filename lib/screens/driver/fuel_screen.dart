import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class FuelScreen extends StatefulWidget {
  final String driverId;

  const FuelScreen({super.key, required this.driverId});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  File? odometerImage;
  File? fuelMeterImage;

  String driverName = '';
  String vehicleNumber = '';
  bool isLoading = true;

  List<Map<String, dynamic>> fuelLogs = [];

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  void fetchDriverDetails() async {
    final ref = FirebaseDatabase.instance.ref('drivers/${widget.driverId}');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        driverName = data['name'] ?? '';
        vehicleNumber = data['vehicleNumber'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage(bool isOdometer) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 60);
    if (picked != null) {
      setState(() {
        if (isOdometer) {
          odometerImage = File(picked.path);
        } else {
          fuelMeterImage = File(picked.path);
        }
      });
    }
  }

  void submitFuelLog() {
    final fuel = _fuelController.text.trim();
    final distance = _distanceController.text.trim();

    if (fuel.isEmpty || distance.isEmpty || odometerImage == null || fuelMeterImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload both images')),
      );
      return;
    }

    final mileage = double.parse(distance) / double.parse(fuel);

    final odometerBase64 = base64Encode(odometerImage!.readAsBytesSync());
    final fuelMeterBase64 = base64Encode(fuelMeterImage!.readAsBytesSync());

    final log = {
      'driverId': widget.driverId,
      'fuel': fuel,
      'distance': distance,
      'mileage': mileage.toStringAsFixed(2),
      'odometerImage': odometerBase64,
      'fuelMeterImage': fuelMeterBase64,
      'timestamp': DateTime.now().toString(),
    };

    setState(() {
      fuelLogs.insert(0, log);
      _fuelController.clear();
      _distanceController.clear();
      odometerImage = null;
      fuelMeterImage = null;
    });

    // Firebase push can be added later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Log', style: TextStyle(color: Colors.black)),
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

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white.withOpacity(0.85),
                child: ListTile(
                  title: Text('Driver: $driverName', style: const TextStyle(color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver ID: ${widget.driverId}', style: const TextStyle(color: Colors.black)),
                      Text('Vehicle Number: $vehicleNumber', style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => pickImage(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Upload Odometer'),
                        ),
                        const SizedBox(height: 6),
                        if (odometerImage != null)
                          Image.file(odometerImage!, height: 100),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => pickImage(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Upload Fuel Meter'),
                        ),
                        const SizedBox(height: 6),
                        if (fuelMeterImage != null)
                          Image.file(fuelMeterImage!, height: 100),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fuelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fuel in Liters',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Distance Traveled (km)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitFuelLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Submit Log'),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Fuel Logs:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              ...fuelLogs.map((log) {
                return Card(
                  color: Colors.white.withOpacity(0.85),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Driver ID: ${log['driverId']}', style: const TextStyle(color: Colors.black)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fuel: ${log['fuel']} L', style: const TextStyle(color: Colors.black)),
                        Text('Distance: ${log['distance']} km', style: const TextStyle(color: Colors.black)),
                        Text('Mileage: ${log['mileage']} km/L', style: const TextStyle(color: Colors.black)),
                        Text('Time: ${log['timestamp'].toString().substring(0, 16)}',
                            style: const TextStyle(color: Colors.black)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (log['odometerImage'] != null)
                              Image.memory(
                                base64Decode(log['odometerImage']),
                                height: 60,
                              ),
                            const SizedBox(width: 10),
                            if (log['fuelMeterImage'] != null)
                              Image.memory(
                                base64Decode(log['fuelMeterImage']),
                                height: 60,
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
