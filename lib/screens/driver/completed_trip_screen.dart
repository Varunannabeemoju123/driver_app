import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CompletedTripsScreen extends StatefulWidget {
  final String driverId;

  const CompletedTripsScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  State<CompletedTripsScreen> createState() => _CompletedTripsScreenState();
}

class _CompletedTripsScreenState extends State<CompletedTripsScreen> {
  late DatabaseReference _completedTripsRef;
  List<Map<String, dynamic>> _completedTrips = [];

  @override
  void initState() {
    super.initState();
    _completedTripsRef = FirebaseDatabase.instance.ref().child('completed_trips').child(widget.driverId);
    _fetchCompletedTrips();
  }

  void _fetchCompletedTrips() {
    _completedTripsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      List<Map<String, dynamic>> loaded = [];

      if (data != null) {
        data.forEach((key, value) {
          loaded.add(Map<String, dynamic>.from(value));
        });
      }

      setState(() {
        _completedTrips = loaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completed Trips',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // ✅ updated path
            fit: BoxFit.cover,
          ),
        ),
        child: _completedTrips.isEmpty
            ? const Center(
          child: Text(
            'No completed trips.',
            style: TextStyle(color: Colors.black),
          ),
        )
            : ListView.builder(
          itemCount: _completedTrips.length,
          itemBuilder: (context, index) {
            final trip = _completedTrips[index];
            return Card(
              color: Colors.white, // ✅ white background for card
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client: ${trip['client']}", style: const TextStyle(color: Colors.black)),
                    Text("Contact: ${trip['contact']}", style: const TextStyle(color: Colors.black)),
                    Text("Pickup: ${trip['pickup']}", style: const TextStyle(color: Colors.black)),
                    Text("Drop: ${trip['drop']}", style: const TextStyle(color: Colors.black)),
                    Text("Distance: ${trip['distance']} km", style: const TextStyle(color: Colors.black)),
                    Text("Date: ${trip['date']}", style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
