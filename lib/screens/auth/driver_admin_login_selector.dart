import 'package:flutter/material.dart';

class LoginSelectorScreen extends StatefulWidget {
  const LoginSelectorScreen({super.key});

  @override
  State<LoginSelectorScreen> createState() => _LoginSelectorScreenState();
}

class _LoginSelectorScreenState extends State<LoginSelectorScreen> {
  bool isDriver = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Portal')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ToggleButtons(
            borderRadius: BorderRadius.circular(10),
            isSelected: [isDriver, !isDriver],
            onPressed: (index) {
              setState(() {
                isDriver = index == 0;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text("Driver Side"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text("Admin Side"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isDriver
                ? const _DriverLoginSection()
                : const _AdminLoginSection(),
          ),
        ],
      ),
    );
  }
}

class _DriverLoginSection extends StatelessWidget {
  const _DriverLoginSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Driver Login Form here..."),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup/driver'),
            child: const Text("Create a new account? Signup"),
          )
        ],
      ),
    );
  }
}

class _AdminLoginSection extends StatelessWidget {
  const _AdminLoginSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Admin Login Form here..."),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup/admin'),
            child: const Text("Create a new account? Signup"),
          )
        ],
      ),
    );
  }
}
