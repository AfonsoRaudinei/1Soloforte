import 'package:flutter/material.dart';
import 'theme_provider.dart';
import 'theme_clean_ios.dart';
import 'theme_avenue.dart';
import 'theme_dark_black_gold.dart';

/// Central theme mapping - Single source of truth for theme selection
/// Maps AppTheme enum to concrete ThemeData implementations
ThemeData getThemeData(AppTheme theme) {
  switch (theme) {
    case AppTheme.cleanIOS:
      return cleanIosTheme;
    case AppTheme.avenue:
      return avenueTheme;
    case AppTheme.dark:
      return darkBlackGoldTheme;
  }
}

// ========== LEGACY COMPATIBILITY ==========
// These methods maintain backward compatibility with existing code
// that may still reference AppThemeData.blue(), green(), dark()

/// Legacy AppThemeData class for backward compatibility
class AppThemeData {
  /// Tema Clean iOS (Azul Samsung)
  static ThemeData blue() => cleanIosTheme;

  /// Tema Avenue (Verde Avenue)
  static ThemeData green() => avenueTheme;

  /// Tema Escuro (Black Gold)
  static ThemeData dark() => darkBlackGoldTheme;

  /// Mantém compatibilidade com código existente
  static ThemeData get lightTheme => blue();
  static ThemeData get darkTheme => dark();
}
