import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  final String clientName;
  final String vehicleNumber;
  final String tripType;
  final String startKm;
  final String endKm;
  final String ratePerKm;
  final String driverBata;
  final String tollParking;
  final String total;

  const InvoiceScreen({
    super.key,
    required this.clientName,
    required this.vehicleNumber,
    required this.tripType,
    required this.startKm,
    required this.endKm,
    required this.ratePerKm,
    required this.driverBata,
    required this.tollParking,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Preview")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/adminbackground.png"), // ✅ Your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 5,
            color: Colors.white.withOpacity(0.9), // Semi-transparent card
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "INVOICE",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Client: $clientName", style: const TextStyle(color: Colors.black)),
                  Text("Vehicle Number: $vehicleNumber", style: const TextStyle(color: Colors.black)),
                  Text("Trip Type: $tripType", style: const TextStyle(color: Colors.black)),
                  const Divider(),
                  Text("Start KM: $startKm", style: const TextStyle(color: Colors.black)),
                  Text("End KM: $endKm", style: const TextStyle(color: Colors.black)),
                  Text("Rate per KM: ₹$ratePerKm", style: const TextStyle(color: Colors.black)),
                  Text("Driver Bata: ₹$driverBata", style: const TextStyle(color: Colors.black)),
                  Text("Toll / Parking: ₹$tollParking", style: const TextStyle(color: Colors.black)),
                  const Divider(),
                  Text(
                    "Total Amount (Incl. 5% GST): ₹$total",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
