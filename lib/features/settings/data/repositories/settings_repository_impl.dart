import 'package:soloforte_app/features/settings/data/datasources/settings_local_datasource.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import '../datasources/settings_remote_datasource.dart';
import 'package:soloforte_app/core/services/security_service.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsLocalDataSource _localDataSource;
  final ISettingsRemoteDataSource _remoteDataSource;
  final bool _useRemote;

  SettingsRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource, {
    bool useRemote = true,
  }) : _useRemote = useRemote;

  @override
  Future<AppSettings> getSettings({String? userId}) async {
    // 1. Try to get from Local first (Quick load)
    var settings = await _localDataSource.getSettings();

    // 2. If we have a user and remote is enabled, try to sync
    if (userId != null && _useRemote) {
      try {
        final remoteSettings = await _remoteDataSource.getSettings(userId);
        if (remoteSettings != null) {
          // "Se existir -> hidratar estado local"
          // We should merge or replace? Usually replace local with remote truth.
          // But we must preserve fields that might not be in remote if any?
          // Our remote impl creates a full AppSettings object.

          // Should we check timestamps? For now, we assume Remote > Local on fresh load.
          settings = remoteSettings;

          // Persist valid remote data locally
          await _localDataSource.saveSettings(settings);
        } else {
          // "Se não existir -> criar registro com defaults locais"
          // We have 'settings' from local (or defaults).
          // We should push this to remote.
          // "Fire and forget" or await?
          // Since this is 'getSettings', user expects data.
          // We can spawn a save in background.
          _safeSaveRemote(userId, settings);
        }
      } catch (e) {
        // Offline or error -> Fallback to local (which we already have in 'settings')
        debugPrint('Sync failed: $e');
      }
    }

    return settings;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    // Save Local
    await _localDataSource.saveSettings(settings);
    // Remote is usually handled via updateSetting or specific sync calls,
    // but if this is called directly, we should sync if possible.
    // However, saveSettings doesn't take userId here.
    // This method signature in interface is `saveSettings(AppSettings)`.
    // If we want to sync, we need the userId.
    // But we don't have it here.
    // We only have it in `getSettings` and `updateSetting` (now).
    // So this generic save might be local only unless we store userId in the Repo or Settings?
    // Given the constraints, meaningful sync happens in updateSetting.
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
  }) async {
    final currentSettings = await _localDataSource.getSettings();
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
      farmName: farmName ?? currentSettings.farmName,
      farmCnpj: farmCnpj ?? currentSettings.farmCnpj,
      farmAddress: farmAddress ?? currentSettings.farmAddress,
      farmCity: farmCity ?? currentSettings.farmCity,
      farmState: farmState ?? currentSettings.farmState,
      farmPhone: farmPhone ?? currentSettings.farmPhone,
      farmEmail: farmEmail ?? currentSettings.farmEmail,
      harvests: harvests ?? currentSettings.harvests,
      integrations: integrations ?? currentSettings.integrations,
      language: language ?? currentSettings.language,
      themeMode: themeMode ?? currentSettings.themeMode,
    );

    try {
      if (userId != null) {
        // Rate Limit: 20 updates per minute (prevent spamming toggles)
        await SecurityService().validateAction(
          'settings_update',
          userId: userId,
          limit: 20,
          window: const Duration(minutes: 1),
        );
      }
    } catch (e) {
      rethrow;
    }

    // 1. Update Local Immediately (Optimistic)
    await _localDataSource.saveSettings(newSettings);

    // 2. Persist in Supabase in background
    if (userId != null && _useRemote) {
      _safeSaveRemote(userId, newSettings);

      // 3. Audit Critical Changes
      _auditChanges(userId, currentSettings, newSettings);
    }
  }

  @override
  Future<void> clearSettings() async {
    await _localDataSource.clearSettings();
  }

  Future<void> _safeSaveRemote(String userId, AppSettings settings) async {
    try {
      await _remoteDataSource.saveSettings(userId, settings);
    } catch (e) {
      debugPrint('Remote save failed: $e');
    }
  }

  void _auditChanges(String userId, AppSettings oldS, AppSettings newS) {
    final changes = <String, dynamic>{};

    if (oldS.pushNotificationsEnabled != newS.pushNotificationsEnabled) {
      changes['push_notifications'] = newS.pushNotificationsEnabled;
    }
    if (oldS.emailNotificationsEnabled != newS.emailNotificationsEnabled) {
      changes['email_notifications'] = newS.emailNotificationsEnabled;
    }
    if (oldS.visualStyle != newS.visualStyle) {
      changes['visual_style'] = newS.visualStyle;
    }
    if (oldS.language != newS.language) {
      changes['language'] = newS.language;
    }
    if (oldS.themeMode != newS.themeMode) {
      changes['theme_mode'] = newS.themeMode.toString();
    }
    if (oldS.harvests != newS.harvests) {
      changes['harvests_changed'] = true;
    }
    if (oldS.integrations != newS.integrations) {
      changes['integrations_changed'] = true;
    }

    if (changes.isNotEmpty) {
      SecurityService().logSecurityEvent(userId, 'settings_changed', changes);
    }
  }
}
