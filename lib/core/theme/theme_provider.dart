import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme identifier preference key for SharedPreferences.
const _themeIdKey = 'theme_id';

/// Provider for the current theme identifier.
final themeIdProvider = StateNotifierProvider<ThemeIdNotifier, String>(
  (ref) => ThemeIdNotifier(),
);

/// Notifier that manages theme id and persists to SharedPreferences.
class ThemeIdNotifier extends StateNotifier<String> {
  ThemeIdNotifier() : super('blue') {
    _loadTheme();
  }

  /// Load theme from SharedPreferences.
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeId = prefs.getString(_themeIdKey);
      if (themeId != null && ['blue', 'green', 'dark'].contains(themeId)) {
        state = themeId;
      }
    } catch (_) {
      // Use default on error
    }
  }

  /// Set theme id and persist.
  Future<void> setThemeId(String id) async {
    if (!['blue', 'green', 'dark'].contains(id)) return;

    state = id;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeIdKey, id);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Check if dark mode is active.
  bool get isDarkMode => state == 'dark';
}

/// Extension for easy theme access in widgets.
extension ThemeExtension on WidgetRef {
  /// Get current theme id.
  String get themeId => watch(themeIdProvider);

  /// Check if dark mode is currently active.
  bool get isDarkMode => watch(themeIdProvider) == 'dark';

  /// Set specific theme.
  Future<void> setTheme(String themeId) async {
    await read(themeIdProvider.notifier).setThemeId(themeId);
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
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final themeId = ref.watch(themeIdProvider);
  return ThemeModeNotifier(
    themeId == 'dark' ? ThemeMode.dark : ThemeMode.light,
  );
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(ThemeMode mode) : super(mode);
}
