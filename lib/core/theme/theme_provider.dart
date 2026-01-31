import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum representing the 3 exclusive app themes.
enum AppTheme {
  cleanIOS, // Clean iOS (Light) - Blue theme
  avenue, // Avenue (Light) - Green theme
  dark; // Dark theme - Black & Gold

  /// Get the internal theme ID for backwards compatibility.
  String get id {
    switch (this) {
      case AppTheme.cleanIOS:
        return 'blue';
      case AppTheme.avenue:
        return 'green';
      case AppTheme.dark:
        return 'dark';
    }
  }

  /// Get theme name for display.
  String get displayName {
    switch (this) {
      case AppTheme.cleanIOS:
        return 'Clean iOS';
      case AppTheme.avenue:
        return 'Avenue';
      case AppTheme.dark:
        return 'Black & Gold';
    }
  }

  /// Get theme description.
  String get description {
    switch (this) {
      case AppTheme.cleanIOS:
        return 'Azul Samsung';
      case AppTheme.avenue:
        return 'Verde Avenue';
      case AppTheme.dark:
        return 'Modo escuro';
    }
  }

  /// Get theme icon.
  IconData get icon {
    switch (this) {
      case AppTheme.cleanIOS:
        return Icons.smartphone;
      case AppTheme.avenue:
        return Icons.android;
      case AppTheme.dark:
        return Icons.dark_mode;
    }
  }

  /// Check if this theme uses dark mode.
  bool get isDark => this == AppTheme.dark;

  /// Parse theme from ID string.
  static AppTheme fromId(String id) {
    switch (id) {
      case 'blue':
        return AppTheme.cleanIOS;
      case 'green':
        return AppTheme.avenue;
      case 'dark':
        return AppTheme.dark;
      default:
        return AppTheme.cleanIOS; // Default
    }
  }
}

/// Theme preference key for SharedPreferences.
const _themeKey = 'app_theme';

/// Provider for the current app theme.
final appThemeProvider = StateNotifierProvider<AppThemeNotifier, AppTheme>(
  (ref) => AppThemeNotifier(),
);

/// Notifier that manages app theme and persists to SharedPreferences.
class AppThemeNotifier extends StateNotifier<AppTheme> {
  AppThemeNotifier() : super(AppTheme.cleanIOS) {
    _loadTheme();
  }

  /// Load theme from SharedPreferences.
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeId = prefs.getString(_themeKey);
      if (themeId != null) {
        state = AppTheme.fromId(themeId);
      }
    } catch (_) {
      // Use default on error
    }
  }

  /// Set theme and persist.
  Future<void> setTheme(AppTheme theme) async {
    state = theme;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme.id);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Check if dark mode is active.
  bool get isDarkMode => state.isDark;
}

/// Legacy provider for backwards compatibility.
/// Maps new AppTheme to old string-based theme IDs.
final themeIdProvider = Provider<String>((ref) {
  final theme = ref.watch(appThemeProvider);
  return theme.id;
});

/// Extension for easy theme access in widgets.
extension ThemeExtension on WidgetRef {
  /// Get current theme.
  AppTheme get appTheme => watch(appThemeProvider);

  /// Get current theme id (legacy).
  String get themeId => watch(themeIdProvider);

  /// Check if dark mode is currently active.
  bool get isDarkMode => watch(appThemeProvider).isDark;

  /// Set specific theme.
  Future<void> setTheme(AppTheme theme) async {
    await read(appThemeProvider.notifier).setTheme(theme);
  }
}

/// Helper extension on BuildContext for theme.
extension ThemeContextExtension on BuildContext {
  /// Check if the current theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get the current color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;
}

// Mantém compatibilidade com código antigo usando ThemeMode
final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(appThemeProvider);
  return theme.isDark ? ThemeMode.dark : ThemeMode.light;
});
