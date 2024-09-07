import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractian/src/app_colors.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onSurface: AppColors.blackFont,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
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
}
