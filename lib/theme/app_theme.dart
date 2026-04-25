import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Sage family
  static const sage = Color(0xFF2D4A3E);
  static const sageMid = Color(0xFF4A7C6A);
  static const sageLight = Color(0xFF8FBCAA);
  static const sagePale = Color(0xFFD4E9E1);

  // Mauve family
  static const mauve = Color(0xFF6B5B7B);
  static const mauveMid = Color(0xFF9B88AE);
  static const mauveLight = Color(0xFFC4B3D4);
  static const mauvePale = Color(0xFFEDE7F5);

  // Cream & warm neutrals
  static const cream = Color(0xFFFAF6F0);
  static const creamWarm = Color(0xFFF2ECE0);
  static const creamDeep = Color(0xFFE8E0D4);

  // Ember
  static const ember = Color(0xFFC47C3A);
  static const emberLight = Color(0xFFE8B87A);
  static const emberPale = Color(0xFFFDF5E8);

  // Blue (for sad state)
  static const softBlue = Color(0xFF4E72A8);
  static const softBluePale = Color(0xFFE8EEF8);

  // Coral (for angry state)
  static const coral = Color(0xFFC45530);
  static const coralPale = Color(0xFFFDEEE8);

  // Text
  static const textDark = Color(0xFF2A2320);
  static const textMid = Color(0xFF5A5250);
  static const textSoft = Color(0xFF9A9290);
  static const textHint = Color(0xFFBBB5B0);

  // Card & surface
  static const cardBg = Colors.white;
  static const cardBorder = Color(0xFFEDE7DF);
  static const surfaceBg = Color(0xFFF5F0E8);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.sage,
      background: AppColors.cream,
    ),
    textTheme: GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 36,
        color: AppColors.sage,
        letterSpacing: -1,
      ),
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 28,
        color: AppColors.sage,
      ),
      displaySmall: GoogleFonts.dmSerifDisplay(
        fontSize: 22,
        color: AppColors.sage,
      ),
      headlineMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 20,
        color: AppColors.sage,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 15,
        color: AppColors.textMid,
        height: 1.7,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        color: AppColors.textMid,
        height: 1.65,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        color: AppColors.textSoft,
        height: 1.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.07,
        color: AppColors.textSoft,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.dmSerifDisplay(
        fontSize: 20,
        color: AppColors.sage,
      ),
      iconTheme: const IconThemeData(color: AppColors.sage),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cream,
      selectedItemColor: AppColors.sage,
      unselectedItemColor: AppColors.textSoft,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
