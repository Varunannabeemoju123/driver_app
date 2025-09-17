import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'invoice_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final clientController = TextEditingController();
  final vehicleController = TextEditingController();
  final startKmController = TextEditingController();
  final endKmController = TextEditingController();
  final ratePerKmController = TextEditingController();
  final driverBataController = TextEditingController();
  final tollParkingController = TextEditingController();

  String tripType = "Local";
  double? calculatedTotal;

  final DatabaseReference billingRef =
  FirebaseDatabase.instance.ref().child('billings');

  double calculateTotal() {
    final start = double.tryParse(startKmController.text) ?? 0;
    final end = double.tryParse(endKmController.text) ?? 0;
    final distance = (end - start).clamp(0, double.infinity);

    final rate = double.tryParse(ratePerKmController.text) ?? 0;
    final bata = double.tryParse(driverBataController.text) ?? 0;
    final toll = double.tryParse(tollParkingController.text) ?? 0;

    final base = distance * rate;
    final subtotal = base + bata + toll;
    final gst = subtotal * 0.05;

    return subtotal + gst;
  }

  void generateInvoiceAndSave() {
    final total = calculateTotal();

    billingRef.push().set({
      'clientName': clientController.text,
      'vehicleNumber': vehicleController.text,
      'tripType': tripType,
      'startKm': startKmController.text,
      'endKm': endKmController.text,
      'ratePerKm': ratePerKmController.text,
      'driverBata': driverBataController.text,
      'tollParking': tollParkingController.text,
      'total': total.toStringAsFixed(2),
      'timestamp': DateTime.now().toIso8601String(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          clientName: clientController.text,
          vehicleNumber: vehicleController.text,
          tripType: tripType,
          startKm: startKmController.text,
          endKm: endKmController.text,
          ratePerKm: ratePerKmController.text,
          driverBata: driverBataController.text,
          tollParking: tollParkingController.text,
          total: total.toStringAsFixed(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔹 Background image
        Positioned.fill(
          child: Image.asset(
            "assets/adminbackground.png",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text("Billing")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: clientController,
                  decoration: const InputDecoration(labelText: "Client Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: vehicleController,
                  decoration: const InputDecoration(labelText: "Vehicle Number"),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Trip Type: "),
                    Radio(
                      value: "Local",
                      groupValue: tripType,
                      onChanged: (value) => setState(() => tripType = value!),
                    ),
                    const Text("Local"),
                    Radio(
                      value: "Outstation",
                      groupValue: tripType,
                      onChanged: (value) => setState(() => tripType = value!),
                    ),
                    const Text("Outstation"),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: startKmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Start KM"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: endKmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "End KM"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ratePerKmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Rate per KM"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: driverBataController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Driver Bata"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tollParkingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Toll / Parking"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      calculatedTotal = calculateTotal();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Get Total"),
                ),
                if (calculatedTotal != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Total: ₹${calculatedTotal!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: generateInvoiceAndSave,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text("Generate Invoice"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
