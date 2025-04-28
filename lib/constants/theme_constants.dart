import 'package:flutter/material.dart';

class ThemeConstants {
  // Primary color palette
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryLightColor = Color(0xFF9E47FF);
  static const Color primaryDarkColor = Color(0xFF3700B3);
  
  // Secondary color palette
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryLightColor = Color(0xFF66FFF8);
  static const Color secondaryDarkColor = Color(0xFF00A896);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  
  // Card colors
  static const Color cardBackColor = primaryColor;
  static const Color cardMatchedColor = Color(0xFF4CAF50);
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textOnPrimaryColor = Colors.white;
  static const Color textOnSecondaryColor = Colors.black;
  
  // Gradient colors
  static const List<Color> backgroundGradient = [
    Color(0xFF6200EE),
    Color(0xFF3700B3),
  ];
  
  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 5,
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: textOnSecondaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 5,
  );
  
  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: textOnPrimaryColor,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black26,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );
  
  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 6.0,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  static BoxDecoration cardBackDecoration = BoxDecoration(
    color: cardBackColor,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 6.0,
        offset: const Offset(0, 3),
      ),
    ],
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryColor, primaryDarkColor],
    ),
  );
  
  static BoxDecoration cardMatchedDecoration = BoxDecoration(
    color: cardMatchedColor,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 6.0,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // Container decorations
  static BoxDecoration gradientBackgroundDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: backgroundGradient,
    ),
  );
  
  static BoxDecoration infoContainerDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
