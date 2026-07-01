import 'package:flutter/material.dart';

/// Stitch RIIDER design system — project 14264213561128025470 (Kinetic Precision / light)
abstract final class AppColors {
  static const Color background = Color(0xFFFAF8FF);
  static const Color onBackground = Color(0xFF131B2E);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF43474D);

  static const Color primary = Color(0xFF001628);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF062B45);
  static const Color onPrimaryContainer = Color(0xFF7593B2);
  static const Color primaryFixed = Color(0xFFC9E6FF);
  static const Color primaryFixedDim = Color(0xFFABCAEB);

  static const Color secondary = Color(0xFF895100);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFD9D1A);
  static const Color onSecondaryContainer = Color(0xFF663B00);
  static const Color secondaryFixed = Color(0xFFFFDCBC);

  static const Color tertiary = Color(0xFF001624);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF002C42);
  static const Color onTertiaryContainer = Color(0xFF0099D9);
  static const Color tertiaryFixed = Color(0xFFC9E6FF);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);
  static const Color surfaceVariant = Color(0xFFDAE2FD);
  static const Color surfaceDim = Color(0xFFD2D9F4);

  static const Color outline = Color(0xFF73777E);
  static const Color outlineVariant = Color(0xFFC3C7CE);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color glassFill = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x1A062B45);
  static const Color glassPremiumFill = Color(0xE6FAF8FF);

  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF062B45), Color(0xFF43617E)],
  );

  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF001628), Color(0xFF062B45)],
  );
}
