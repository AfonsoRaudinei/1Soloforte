import 'package:soloforte_app/features/settings/domain/entities/app_settings.dart';
import 'package:soloforte_app/features/settings/domain/repositories/i_settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    try {
      return await _localDataSource.getSettings();
    } catch (e) {
      // Return default settings on error
      return const AppSettings();
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _localDataSource.saveSettings(settings);
  }

  @override
  Future<void> updateSetting({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? automaticAlerts,
    bool? offlineMode,
    bool? autoSync,
    String? visualStyle,
    String? farmLogoPath,
  }) async {
    final currentSettings = await getSettings();
    final newSettings = currentSettings.copyWith(
      pushNotificationsEnabled:
          pushNotifications ?? currentSettings.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotifications ?? currentSettings.emailNotificationsEnabled,
      automaticAlertsEnabled:
          automaticAlerts ?? currentSettings.automaticAlertsEnabled,
      offlineModeEnabled: offlineMode ?? currentSettings.offlineModeEnabled,
      autoSyncEnabled: autoSync ?? currentSettings.autoSyncEnabled,
      visualStyle: visualStyle ?? currentSettings.visualStyle,
      farmLogoPath: farmLogoPath ?? currentSettings.farmLogoPath,
    );
    await saveSettings(newSettings);
  }

  @override
  Future<void> clearSettings() async {
    await _localDataSource.clearSettings();
  }
}
