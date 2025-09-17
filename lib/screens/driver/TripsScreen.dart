import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'completed_trip_screen.dart';

class TripsScreen extends StatefulWidget {
  final String driverId;

  const TripsScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  late DatabaseReference _activeTripsRef;
  late DatabaseReference _completedTripsRef;
  List<Map<String, dynamic>> _trips = [];
  Set<String> startedTrips = {};

  @override
  void initState() {
    super.initState();
    _activeTripsRef = FirebaseDatabase.instance.ref().child('assigned_trips').child(widget.driverId);
    _completedTripsRef = FirebaseDatabase.instance.ref().child('completed_trips').child(widget.driverId);
    _fetchTrips();
  }

  void _fetchTrips() {
    _activeTripsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      List<Map<String, dynamic>> loaded = [];

      if (data != null) {
        data.forEach((key, value) {
          loaded.add({
            'id': key,
            ...Map<String, dynamic>.from(value),
          });
        });
      }

      setState(() {
        _trips = loaded;
      });
    });
  }

  void _startTrip(String tripId) {
    setState(() {
      startedTrips.add(tripId);
    });
  }

  void _endTrip(Map<String, dynamic> trip) async {
    String tripId = trip['id'];

    await _completedTripsRef.child(tripId).set({
      'client': trip['client'],
      'contact': trip['contact'],
      'pickup': trip['pickup'],
      'drop': trip['drop'],
      'distance': trip['distance'],
      'date': trip['date'],
    });

    await _activeTripsRef.child(tripId).remove();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompletedTripsScreen(driverId: widget.driverId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _trips.isEmpty
            ? const Center(
          child: Text(
            'No active trips available.',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.only(top: kToolbarHeight + 16, bottom: 24),
          itemCount: _trips.length,
          itemBuilder: (context, index) {
            final trip = _trips[index];
            final tripId = trip['id'];
            final hasStarted = startedTrips.contains(tripId);

            return Card(
              color: Colors.white.withOpacity(0.85),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
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
                    const SizedBox(height: 12),
                    if (!hasStarted)
                      ElevatedButton(
                        onPressed: () => _startTrip(tripId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Start Trip"),
                      ),
                    if (hasStarted)
                      ElevatedButton(
                        onPressed: () => _endTrip(trip),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: const Text("End Trip"),
                      ),
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
