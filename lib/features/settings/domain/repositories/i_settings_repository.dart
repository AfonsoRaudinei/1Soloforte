import '../entities/app_settings.dart';

/// Contract for Settings Repository
abstract class ISettingsRepository {
  /// Get current settings
  Future<AppSettings> getSettings();

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
  });

  /// Clear all settings (logout/reset)
  Future<void> clearSettings();
}
