import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextStyle get displayLg => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -1.92,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.48,
        color: AppColors.onSurface,
      );

  static TextStyle get titleMd => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.7,
        color: AppColors.onSurface,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppColors.onSurfaceVariant,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLg,
        headlineMedium: headlineLgMobile,
        headlineSmall: titleMd,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        labelLarge: labelMd,
        labelSmall: caption,
      );

  static TextStyle get headlineMdMobile => headlineLgMobile;
}
