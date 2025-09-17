import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/role_selection_screen.dart';
import 'screens/driver/driver_login_screen.dart';
import 'screens/driver/driver_signup_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_signup_screen.dart';
import 'screens/auth/driver_admin_login_selector.dart';

import 'screens/driver/home_screen.dart';
import 'screens/driver/fuel_screen.dart';
import 'screens/driver/attendance_screen.dart';
import 'screens/driver/advance_screen.dart';
import 'screens/driver/bank_screen.dart';
import 'screens/driver/performance_screen.dart';

import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/driver_management_screen.dart';
import 'screens/admin/vehicle_management_screen.dart';
import 'screens/admin/billing_screen.dart';
import 'screens/admin/attendance_admin_screen.dart';
import 'screens/admin/mileage_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet & Driver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade800,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/login': (context) => const LoginSelectorScreen(),
        '/login/driver': (context) => const DriverLoginScreen(),
        '/signup/driver': (context) => const DriverSignupScreen(),
        '/login/admin': (context) => const AdminLoginScreen(),
        '/signup/admin': (context) => const AdminSignupScreen(),

        // ❗ Do NOT use routes for screens requiring parameters. Use push instead.
        // Example usage:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => BankScreen(driverId: driverId)));

        '/admin/dashboard': (context) => const AdminDashboard(),
        '/admin/drivers': (context) => const DriverManagementScreen(),
        '/admin/vehicles': (context) => const VehicleManagementScreen(),
        '/admin/billing': (context) => const BillingScreen(),
        '/admin/attendance': (context) => const AdminAttendanceScreen(),
      },
    );
  }
}
