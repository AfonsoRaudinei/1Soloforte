import 'package:flutter/material.dart';
import 'app_typography.dart';

/// Dark Black Gold Theme - Tema Escuro Premium
/// Tema escuro sofisticado com destaques dourados e alta legibilidade
final ThemeData darkBlackGoldTheme = _buildDarkBlackGoldTheme();

ThemeData _buildDarkBlackGoldTheme() {
  // Paleta Black Gold
  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD4AF37), // Gold accent
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF9CA3AF),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFF2D2D2D),
    outline: Color(0xFF4D4D4D), // Improved dark mode visibility
  );

  const backgroundColor = Color(0xFF121212);
  const cardColor = Color(0xFF2D2D2D);
  const borderColor = Color(0xFF4D4D4D); // Improved visibility

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: colorScheme,
    textTheme: TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: Colors.white),
      displayMedium: AppTypography.h2.copyWith(color: Colors.white),
      displaySmall: AppTypography.h3.copyWith(color: Colors.white),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: Colors.white70),
      bodySmall: AppTypography.bodySmall.copyWith(color: Colors.white60),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
      labelSmall: AppTypography.caption.copyWith(color: Colors.white54),
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
      hintStyle: AppTypography.bodyMedium.copyWith(color: Colors.white38),
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
      unselectedItemColor: Colors.white54,
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
    // Dark theme specific enhancements
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.white.withValues(alpha: 0.05),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
