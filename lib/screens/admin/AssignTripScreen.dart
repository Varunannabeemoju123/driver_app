import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AssignTripScreen extends StatefulWidget {
  final String driverId;
  final String driverName;
  final String vehicleNumber;

  const AssignTripScreen({
    Key? key,
    required this.driverId,
    required this.driverName,
    required this.vehicleNumber,
  }) : super(key: key);

  @override
  State<AssignTripScreen> createState() => _AssignTripScreenState();
}

class _AssignTripScreenState extends State<AssignTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _contactController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _distanceController = TextEditingController();
  final _dateController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('assigned_trips');

  void _submitTrip() {
    if (_formKey.currentState!.validate()) {
      final newTrip = {
        'driverId': widget.driverId,
        'driverName': widget.driverName,
        'vehicleNumber': widget.vehicleNumber,
        'client': _clientController.text.trim(),
        'contact': _contactController.text.trim(),
        'pickup': _pickupController.text.trim(),
        'drop': _dropController.text.trim(),
        'distance': _distanceController.text.trim(),
        'date': _dateController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      _dbRef.child(widget.driverId).push().set(newTrip).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trip assigned successfully")),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Trip")),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/adminbackground.png'), // make sure this file exists
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Form content with some transparency
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("Driver: ${widget.driverName}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _clientController,
                      decoration: const InputDecoration(labelText: "Client Name"),
                      validator: (value) => value!.isEmpty ? "Enter client name" : null,
                    ),
                    TextFormField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "Client Contact"),
                      validator: (value) => value!.isEmpty ? "Enter contact number" : null,
                    ),
                    TextFormField(
                      controller: _pickupController,
                      decoration: const InputDecoration(labelText: "Pickup Location"),
                      validator: (value) => value!.isEmpty ? "Enter pickup location" : null,
                    ),
                    TextFormField(
                      controller: _dropController,
                      decoration: const InputDecoration(labelText: "Drop Location"),
                      validator: (value) => value!.isEmpty ? "Enter drop location" : null,
                    ),
                    TextFormField(
                      controller: _distanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Distance (km)"),
                      validator: (value) => value!.isEmpty ? "Enter distance" : null,
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: "Trip Date (YYYY-MM-DD)"),
                      validator: (value) => value!.isEmpty ? "Enter trip date" : null,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitTrip,
                      child: const Text("Assign Trip"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
