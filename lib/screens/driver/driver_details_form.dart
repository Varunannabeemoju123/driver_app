import 'package:flutter/material.dart';

class DriverDetailsForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;
  const DriverDetailsForm({required this.onSubmit, super.key});

  @override
  State<DriverDetailsForm> createState() => _DriverDetailsFormState();
}

class _DriverDetailsFormState extends State<DriverDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _driverData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Driver Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField("First Name", "firstName"),
              buildField("Middle Name", "middleName"),
              buildField("Last Name", "lastName"),
              buildField("Age", "age"),
              buildField("Address", "address"),
              buildField("Experience", "experience"),
              buildField("Blood Group", "bloodGroup"),
              buildField("Date of Birth", "dob"),
              buildField("Gender", "gender"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(_driverData);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        onSaved: (val) => _driverData[key] = val ?? '',
      ),
    );
  }
}
