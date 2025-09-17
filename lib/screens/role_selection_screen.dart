import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image filling the entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/roleselection_background.png', // <-- Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40), // 2cm spacing from top
                const Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login/driver'),
                          child: const Text('Driver'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login/admin'),
                          child: const Text('Admin'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
