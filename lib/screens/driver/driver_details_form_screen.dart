import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class DriverDetailsFormScreen extends StatefulWidget {
  final String uid;

  const DriverDetailsFormScreen({super.key, required this.uid});

  @override
  State<DriverDetailsFormScreen> createState() => _DriverDetailsFormScreenState();
}

class _DriverDetailsFormScreenState extends State<DriverDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseRef = FirebaseDatabase.instance.ref().child('drivers');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _email = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _email = user.email ?? "";
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> driverData = {
        'driverId': widget.uid,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'vehicle_number': _vehicleController.text.trim(),
        'vehicle_type': _vehicleTypeController.text.trim(),
        'license_number': _licenseController.text.trim(),
        'address': _addressController.text.trim(),
        'email': _email,
      };

      await _databaseRef.child(widget.uid).set(driverData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Driver details saved')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(uid: widget.uid),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Driver Details')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Driver ID: ${widget.uid}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text("Email: $_email", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _vehicleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Vehicle Number'),
                validator: (value) => value!.isEmpty ? 'Enter vehicle number' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _vehicleTypeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Vehicle Type (e.g., Bus, Van)'),
                validator: (value) => value!.isEmpty ? 'Enter vehicle type' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _licenseController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('License Number'),
                validator: (value) => value!.isEmpty ? 'Enter license number' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
