// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[900],
    scaffoldBackgroundColor: Color(0xFFB5CBB7),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF564240),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.blueGrey[900]),
      titleTextStyle: TextStyle(
        color: Colors.blueGrey[900],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
      cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold, // fontWeight.w700 may be more appropriate
        color: Colors.blueGrey[800]!, // Non-nullable type Color
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.blueGrey[600]!, // Non-nullable type Color
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.deepOrangeAccent,
      background: Colors.grey[100]!, // Non-nullable type Color
    ),
  );
}