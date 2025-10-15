import 'package:erp_admin/AppColors/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData buildThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: kPrimary,
      scaffoldBackgroundColor: kBackground,

      // Text Theme
      textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(fontSize: 16),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimary,
          textStyle: GoogleFonts.roboto(),
        ),
      ),

      // Floating Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: kPrimary),

      // Input TextField Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
        hintStyle: GoogleFonts.roboto(color: kTextSecondary),
        labelStyle: GoogleFonts.roboto(color: kTextPrimary),
      ),

      // Date Picker Theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: kCardBackground,
        headerBackgroundColor: kPrimary,
        headerForegroundColor: Colors.white,
        dayForegroundColor: WidgetStateProperty.all(kTextPrimary),
        dayOverlayColor: WidgetStateProperty.all(kPrimary.withOpacity(0.15)),
        todayForegroundColor: WidgetStateProperty.all(Colors.white),
        todayBackgroundColor: WidgetStateProperty.all(kPrimary),
        yearForegroundColor: WidgetStateProperty.all(kTextPrimary),
        yearOverlayColor: WidgetStateProperty.all(kPrimary.withOpacity(0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Dialog / AlertBox Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: kCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: kTextPrimary,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(color: kTextSecondary, fontSize: 15),
      ),
    );
  }
}