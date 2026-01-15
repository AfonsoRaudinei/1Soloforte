import 'package:flutter/material.dart';
import '../entities/app_settings.dart';

/// Contract for Settings Repository
abstract class ISettingsRepository {
  /// Get current settings
  Future<AppSettings> getSettings({String? userId});

  /// Save settings
  Future<void> saveSettings(AppSettings settings);

  /// Update a specific setting
  Future<void> updateSetting({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? automaticAlerts,
    bool? offlineMode,
    bool? autoSync,
    String? visualStyle,
    String? farmLogoPath,
    String? farmName,
    String? farmCnpj,
    String? farmAddress,
    String? farmCity,
    String? farmState,
    String? farmPhone,
    String? farmEmail,
    List<HarvestSetting>? harvests,
    Map<String, bool>? integrations,
    String? language,
    ThemeMode? themeMode,
    String? userId,
  });

  /// Clear all settings (logout/reset)
  Future<void> clearSettings();
}
