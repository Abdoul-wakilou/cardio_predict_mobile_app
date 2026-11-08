import 'package:flutter/material.dart';

import '../models/prediction_result.dart';

/// Espacements communs, pour garder un rythme régulier d'un écran à l'autre.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
}

abstract final class AppColors {
  static const Color brand = Color(0xFF2E7D32);
  static const Color brandDeep = Color(0xFF1B5E20);
  static const Color brandDarkMode = Color(0xFF81C784);

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF12491A), brandDeep, brand],
  );

  /// Tons distincts selon le mode, choisis pour rester lisibles sur la carte
  /// du résultat : le niveau de risque est l'information principale de l'écran.
  static Color risk(RiskLevel level, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (level) {
      RiskLevel.veryLow => isDark ? const Color(0xFFA5D6A7) : brand,
      RiskLevel.low =>
        isDark ? const Color(0xFFC5E1A5) : const Color(0xFF558B2F),
      RiskLevel.moderate =>
        isDark ? const Color(0xFFFFCC80) : const Color(0xFFB26A00),
      RiskLevel.high =>
        isDark ? const Color(0xFFFFAB91) : const Color(0xFFD84315),
      RiskLevel.veryHigh =>
        isDark ? const Color(0xFFEF9A9A) : const Color(0xFFC62828),
    };
  }
}

abstract final class AppTheme {
  static ThemeData get light => _build(
    ColorScheme.fromSeed(seedColor: AppColors.brand).copyWith(
      primary: AppColors.brand,
      onPrimary: Colors.white,
      surface: const Color(0xFFF6F8F5),
      surfaceContainerLowest: Colors.white,
    ),
  );

  static ThemeData get dark => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.dark,
    ).copyWith(primary: AppColors.brandDarkMode),
  );

  static ThemeData _build(ColorScheme scheme) {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: 18,
    );

    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final buttonText = base.textTheme.labelLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final text = base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
      labelSmall: base.textTheme.labelSmall?.copyWith(letterSpacing: 0.6),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleMedium?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
    );
  }
}
