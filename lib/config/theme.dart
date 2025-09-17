import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7B1FA2); // violet-purple
  static const Color accentColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: accentColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: accentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: accentColor,
      ),
    ),
  );
}
