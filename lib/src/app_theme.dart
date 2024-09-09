import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractian/src/app_colors.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      toolbarHeight: 64,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
        color: AppColors.whiteFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.whiteFont,
      secondary: AppColors.secondary,
      onSecondary: AppColors.whiteFont,
      surface: AppColors.background,
      onSurface: AppColors.blackFont,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.blackFont,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteFont,
      ),
    ),
  );

  static ColorScheme getScheme() {
    return lightTheme.colorScheme;
  }

  static TextTheme getTextTheme() {
    return lightTheme.textTheme;
  }
}
