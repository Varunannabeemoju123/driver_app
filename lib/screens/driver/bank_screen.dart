import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class BankScreen extends StatefulWidget {
  final String driverId;
  const BankScreen({super.key, required this.driverId});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final nameController = TextEditingController();
  final accountController = TextEditingController();
  final ifscController = TextEditingController();

  final picker = ImagePicker();

  File? licenseImage;
  File? rcImage;
  File? insuranceImage;
  File? pollutionImage;

  bool isSubmitted = false;

  Future<void> pickImage(String docType) async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      File image = File(picked.path);
      setState(() {
        switch (docType) {
          case 'license':
            licenseImage = image;
            break;
          case 'rc':
            rcImage = image;
            break;
          case 'insurance':
            insuranceImage = image;
            break;
          case 'pollution':
            pollutionImage = image;
            break;
        }
      });
    }
  }

  Future<String> imageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitDetails() async {
    if (nameController.text.isEmpty ||
        accountController.text.isEmpty ||
        ifscController.text.isEmpty ||
        licenseImage == null ||
        rcImage == null ||
        insuranceImage == null ||
        pollutionImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload all documents.")),
      );
      return;
    }

    final licenseBase64 = await imageToBase64(licenseImage!);
    final rcBase64 = await imageToBase64(rcImage!);
    final insuranceBase64 = await imageToBase64(insuranceImage!);
    final pollutionBase64 = await imageToBase64(pollutionImage!);

    final data = {
      'name': nameController.text.trim(),
      'account': accountController.text.trim(),
      'ifsc': ifscController.text.trim(),
      'licenseImage': licenseBase64,
      'rcImage': rcBase64,
      'insuranceImage': insuranceBase64,
      'pollutionImage': pollutionBase64,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final ref = FirebaseDatabase.instance.ref().child("bankDetails").child(widget.driverId);
    await ref.set(data);

    setState(() {
      isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Details saved successfully.")),
    );
  }

  Widget _buildImageUploadTile(String label, File? image, VoidCallback onPick) {
    return Column(
      children: [
        if (image == null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: onPick,
            child: Text("Upload $label"),
          ),
        if (image != null)
          Column(
            children: [
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
              const SizedBox(height: 5),
              Image.file(image, height: 100),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank A/C & Documents"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isSubmitted
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("My Bank Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 12),
              Text("Name: ${nameController.text}", style: const TextStyle(color: Colors.black)),
              Text("Account No: ${accountController.text}", style: const TextStyle(color: Colors.black)),
              Text("IFSC Code: ${ifscController.text}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildImageUploadTile("Driving License", licenseImage, () {}),
                  _buildImageUploadTile("RC", rcImage, () {}),
                  _buildImageUploadTile("Insurance", insuranceImage, () {}),
                  _buildImageUploadTile("Pollution", pollutionImage, () {}),
                ],
              )
            ],
          )
              : Column(
            children: [
              const Text("Enter Bank Details",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Holder Name',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accountController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("Upload Documents (via Camera)",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildImageUploadTile("Driving License", licenseImage,
                          () => pickImage('license')),
                  _buildImageUploadTile("RC", rcImage, () => pickImage('rc')),
                  _buildImageUploadTile("Insurance", insuranceImage,
                          () => pickImage('insurance')),
                  _buildImageUploadTile("Pollution", pollutionImage,
                          () => pickImage('pollution')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: _submitDetails,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
