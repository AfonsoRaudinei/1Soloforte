import 'package:flutter/material.dart';

import 'app_typography.dart';

/// AppTheme - Sistema de temas com três variações de cores
/// Mantém estrutura única de ThemeData, variando apenas ColorScheme
class AppTheme {
  // ========== PALETAS DE CORES ==========

  /// Paleta Azul Samsung (Clean iOS)
  static const _blueScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0057FF), // Samsung Blue
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF2563EB),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    surfaceContainerHighest: Color(0xFFF3F4F6),
    outline: Color(0xFFE5E7EB),
  );

  /// Paleta Verde iOS (Material 3)
  static const _greenScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF10B981), // iOS Green
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF059669),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    surfaceContainerHighest: Color(0xFFF3F4F6),
    outline: Color(0xFFE5E7EB),
  );

  /// Paleta Black Gold (Tema Escuro)
  static const _darkScheme = ColorScheme(
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
    outline: Color(0xFF3D3D3D),
  );

  // ========== MÉTODOS PÚBLICOS ==========

  /// Tema Clean iOS (Azul Samsung)
  static ThemeData blue() => _buildTheme(_blueScheme, false);

  /// Tema Material 3 (Verde iOS)
  static ThemeData green() => _buildTheme(_greenScheme, false);

  /// Tema Escuro (Black Gold)
  static ThemeData dark() => _buildTheme(_darkScheme, true);

  /// Mantém compatibilidade com código existente
  static ThemeData get lightTheme => blue();
  static ThemeData get darkTheme => dark();

  // ========== BUILDER INTERNO ==========

  static ThemeData _buildTheme(ColorScheme scheme, bool isDark) {
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFFFFFFF);
    final cardColor = isDark
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFFFFFFF);
    final borderColor = scheme.outline;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: scheme,
      textTheme: TextTheme(
        displayLarge: AppTypography.h1.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        displayMedium: AppTypography.h2.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        displaySmall: AppTypography.h3.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: isDark ? Colors.white60 : Colors.black54,
        ),
        labelLarge: AppTypography.button.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: AppTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? Colors.white38 : const Color(0xFFD1D5DB),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardColor,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: scheme.onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(color: borderColor, thickness: 1),
      // iOS Style Enhancements
      splashFactory: NoSplash.splashFactory,
      highlightColor: (isDark ? Colors.white : Colors.black).withValues(
        alpha: 0.05,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
