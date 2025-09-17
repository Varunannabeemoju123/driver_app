import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class AdvanceScreen extends StatefulWidget {
  final String driverId;

  const AdvanceScreen({super.key, required this.driverId});

  @override
  State<AdvanceScreen> createState() => _AdvanceScreenState();
}

class _AdvanceScreenState extends State<AdvanceScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  List<Map<String, String>> advances = [];

  void addAdvance() async {
    final amount = amountController.text;
    final reason = reasonController.text;
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (amount.isNotEmpty) {
      final newAdvance = {
        'amount': amount,
        'reason': reason,
        'date': date,
      };

      // Save to Firebase under /advances/{driverId}/
      await _dbRef
          .child('advances')
          .child(widget.driverId)
          .push()
          .set(newAdvance);

      setState(() {
        advances.insert(0, newAdvance); // insert to local list
      });

      amountController.clear();
      reasonController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Advance Added")),
      );
    }
  }

  void fetchAdvances() async {
    final snapshot = await _dbRef.child('advances/${widget.driverId}').get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      final temp = <Map<String, String>>[];

      data.forEach((key, value) {
        temp.add(Map<String, String>.from(value));
      });

      setState(() {
        advances = temp.reversed.toList(); // latest first
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdvances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advance", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 16),
          child: Column(
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Advance Amount (₹)',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Reason (optional)',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: addAdvance,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text("Add Advance", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              const Divider(height: 30, color: Colors.black),
              const Text("Advance History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              Expanded(
                child: advances.isEmpty
                    ? const Center(child: Text("No advances yet.", style: TextStyle(color: Colors.black)))
                    : ListView.builder(
                  itemCount: advances.length,
                  itemBuilder: (context, index) {
                    final adv = advances[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        title: Text("₹ ${adv['amount']}", style: const TextStyle(color: Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (adv['reason'] != null && adv['reason']!.isNotEmpty)
                              Text("Reason: ${adv['reason']}", style: const TextStyle(color: Colors.black)),
                            Text("Date: ${adv['date']}", style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
