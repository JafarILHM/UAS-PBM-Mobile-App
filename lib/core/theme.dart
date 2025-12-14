import 'package:flutter/material.dart';

class AdminKitTheme {
  // Warna Utama AdminKit
  static const Color primary = Color(0xFF3B7DDD);
  static const Color secondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF1CBB8C);
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFCB92C);
  
  // Warna Layout
  static const Color background = Color(0xFFF5F7FB);
  static const Color sidebar = Color(0xFF222E3C);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF495057);

  // Text Style
  static TextStyle get titleStyle => const TextStyle(
    color: textDark,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get subTitleStyle => const TextStyle(
    color: secondary,
    fontSize: 14,
  );

  // Theme Data untuk Material App
  static ThemeData get themeData => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primary,
      secondary: sidebar,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textDark, 
      elevation: 0, 
      iconTheme: IconThemeData(color: textDark),
    ),
    
    cardTheme: CardThemeData( 
      color: cardColor,
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    
    useMaterial3: true,
  );
}