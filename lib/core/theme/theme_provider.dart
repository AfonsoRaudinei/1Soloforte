import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode preference key for SharedPreferences.
const _themeModeKey = 'theme_mode';

/// Provider for the current theme mode.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Notifier that manages theme mode and persists to SharedPreferences.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load theme from SharedPreferences.
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeModeKey);
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (_) {
      // Use default on error
    }
  }

  /// Set theme mode and persist.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Toggle between light and dark mode.
  /// If system, switches to light first.
  Future<void> toggle() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    await setThemeMode(newMode);
  }

  /// Check if dark mode is active (considering system theme).
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}

/// Extension for easy theme access in widgets.
extension ThemeExtension on WidgetRef {
  /// Get current theme mode.
  ThemeMode get themeMode => watch(themeModeProvider);

  /// Check if dark mode is currently active.
  bool isDarkMode(BuildContext context) {
    return read(themeModeProvider.notifier).isDarkMode(context);
  }

  /// Toggle theme mode.
  Future<void> toggleTheme() async {
    await read(themeModeProvider.notifier).toggle();
  }

  /// Set specific theme mode.
  Future<void> setTheme(ThemeMode mode) async {
    await read(themeModeProvider.notifier).setThemeMode(mode);
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
