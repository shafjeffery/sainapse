import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Color palette
  static const Color primaryColor = Color(0xFF4E342E); // dark brown for text
  static const Color secondaryColor = Color(0xFF8B7355); // medium brown
  static const Color accentColor = Color(
    0xFFFFD93D,
  ); // yellow for backgrounds/accents
  static const Color backgroundColor = Color(0xFFFFF9DB); // Light cream
  static const Color cardColor = Colors.white;

  // 🌈 Support colors
  static const Color greenAccent = Color(0xFF81C784);
  static const Color blueAccent = Color(0xFF64B5F6);
  static const Color orangeAccent = Color.fromARGB(255, 207, 135, 84);

  // 🖋️ Base text styles
  static TextStyle get headline => GoogleFonts.museoModerno(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  static TextStyle get subhead =>
      GoogleFonts.museoModerno(color: Colors.brown[400], fontSize: 15);

  static TextStyle get body =>
      GoogleFonts.museoModerno(color: primaryColor, fontSize: 14);

  static TextStyle get button => GoogleFonts.museoModerno(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  );

  // 🌍 ThemeData
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    textTheme: GoogleFonts.museoModernoTextTheme().copyWith(
      headlineSmall: headline,
      titleMedium: subhead,
      bodyMedium: body,
      labelLarge: button,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        textStyle: button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
