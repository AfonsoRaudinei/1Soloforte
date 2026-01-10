import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

abstract class ISettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> clearSettings();
}

class SettingsLocalDataSource implements ISettingsLocalDataSource {
  static const String _settingsKey = 'app_settings_v1';

  // Keep individual keys for backward compatibility / specific access if needed
  static const String _themeModeKey = 'theme_mode';
  static const String _visualStyleKey = 'visual_style';

  @override
  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to load full object first
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      try {
        return AppSettings.fromJson(jsonDecode(jsonString));
      } catch (_) {
        // Fallback if schema changed
      }
    }

    // Fallback to legacy individual keys if full object not found
    final themeIndex = prefs.getInt(_themeModeKey);
    final themeMode = themeIndex != null
        ? ThemeMode.values[themeIndex]
        : ThemeMode.system;
    final visualStyle = prefs.getString(_visualStyleKey) ?? 'ios';

    return AppSettings(
      themeMode: themeMode,
      visualStyle: visualStyle,
      // Default others
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    // Save full object
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

    // Sync specific keys used by other parts of the app (like ThemeProvider)
    await prefs.setInt(_themeModeKey, settings.themeMode.index);
    await prefs.setString(_visualStyleKey, settings.visualStyle);
  }

  @override
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
    await prefs.remove(_themeModeKey);
    await prefs.remove(_visualStyleKey);
  }
}
