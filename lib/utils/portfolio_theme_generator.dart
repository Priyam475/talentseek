import 'package:flutter/material.dart';
import 'dart:math';

/// A class to hold a generated theme palette for a portfolio.
class PortfolioTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Gradient backgroundGradient;
  final String fontFamily;

  PortfolioTheme({
    required this.primaryColor,
    required this.backgroundColor,
    required this.backgroundGradient,
    this.fontFamily = 'Inter', // Default font
  });
}

/// A utility to generate a unique but consistent theme for each user.
class PortfolioThemeGenerator {
  // A curated list of modern, attractive color palettes.
  static final List<Color> _primaryColors = [
    Colors.blue.shade800, Colors.teal.shade800, Colors.deepPurple.shade700,
    Colors.orange.shade900, Colors.indigo.shade700, Colors.red.shade800,
    Colors.green.shade800, Colors.pink.shade700,
  ];

  static final List<Color> _backgroundColors = [
    Colors.grey.shade50, Colors.blueGrey.shade50, Colors.teal.shade50,
    Colors.deepPurple.shade50, Colors.orange.shade50,
  ];

  /// Generates a unique theme based on the user's ID.
  /// The same UID will always produce the same theme.
  static PortfolioTheme generateTheme(String userId) {
    // Use the hash code of the user's ID as a seed for randomness.
    final random = Random(userId.hashCode);

    final primaryColor = _primaryColors[random.nextInt(_primaryColors.length)];
    final backgroundColor = _backgroundColors[random.nextInt(_backgroundColors.length)];

    return PortfolioTheme(
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      backgroundGradient: LinearGradient(
        colors: [backgroundColor, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}