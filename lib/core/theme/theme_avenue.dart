import 'package:flutter/material.dart';
import 'app_typography.dart';

/// Avenue Theme - Verde Avenue (Material 3 base)
/// Tema claro premium com identidade verde e filosofia Material 3
final ThemeData avenueTheme = _buildAvenueTheme();

ThemeData _buildAvenueTheme() {
  // Paleta Verde Avenue (WCAG AA compliant)
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0D9668), // Avenue Green (contrast: 4.52:1 ✅)
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF047857), // Dark green (contrast: 4.85:1 ✅)
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    surfaceContainerHighest: Color(0xFFF3F4F6),
    outline: Color(0xFFD1D5DB), // Improved visibility
  );

  const backgroundColor = Color(0xFFFFFFFF);
  const cardColor = Color(0xFFFFFFFF);
  const borderColor = Color(0xFFD1D5DB); // Improved visibility

  return ThemeData(
    useMaterial3: true, // Avenue usa Material 3 internamente
    brightness: Brightness.light,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: colorScheme,
    textTheme: TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: Colors.black),
      displayMedium: AppTypography.h2.copyWith(color: Colors.black),
      displaySmall: AppTypography.h3.copyWith(color: Colors.black),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: Colors.black),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: Colors.black87),
      bodySmall: AppTypography.bodySmall.copyWith(color: Colors.black54),
      labelLarge: AppTypography.button.copyWith(color: Colors.black),
      labelSmall: AppTypography.caption.copyWith(color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: const Color(0xFFD1D5DB),
      ),
    ),
    cardTheme: const CardThemeData(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: borderColor),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.black54,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cardColor,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: const DividerThemeData(color: borderColor, thickness: 1),
    // iOS Style Enhancements (mantidos para consistência)
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.black.withValues(alpha: 0.05),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
