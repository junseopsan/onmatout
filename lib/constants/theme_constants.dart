import 'package:flutter/material.dart';

class ThemeConstants {
  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF81C784);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
} 