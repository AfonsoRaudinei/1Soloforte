import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';

part 'settings_provider.g.dart';

// --- Data Layer Providers ---

@riverpod
ISettingsLocalDataSource settingsLocalDataSource(
  SettingsLocalDataSourceRef ref,
) {
  return SettingsLocalDataSource();
}

@riverpod
ISettingsRemoteDataSource settingsRemoteDataSource(
  SettingsRemoteDataSourceRef ref,
) {
  return SettingsRemoteDataSource(Supabase.instance.client);
}

@riverpod
ISettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final localDataSource = ref.watch(settingsLocalDataSourceProvider);
  final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);
  return SettingsRepositoryImpl(localDataSource, remoteDataSource);
}

// --- Presentation Layer Controller ---

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<AppSettings> build() async {
    // Watch auth state to reload settings on user change
    final authState = ref.watch(authStateProvider).value;
    return _getSettings(authState?.userId);
  }

  Future<AppSettings> _getSettings(String? userId) async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getSettings(userId: userId);
  }

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
  }) async {
    final repository = ref.read(settingsRepositoryProvider);
    final authState = ref.read(authStateProvider).value;
    final userId = authState?.userId;

    // Optimistic update state
    final previousState = state;
    if (previousState.value != null) {
      final current = previousState.value!;
      state = AsyncValue.data(
        current.copyWith(
          pushNotificationsEnabled:
              pushNotifications ?? current.pushNotificationsEnabled,
          emailNotificationsEnabled:
              emailNotifications ?? current.emailNotificationsEnabled,
          automaticAlertsEnabled:
              automaticAlerts ?? current.automaticAlertsEnabled,
          offlineModeEnabled: offlineMode ?? current.offlineModeEnabled,
          autoSyncEnabled: autoSync ?? current.autoSyncEnabled,
          visualStyle: visualStyle ?? current.visualStyle,
          farmLogoPath: farmLogoPath ?? current.farmLogoPath,
          farmName: farmName ?? current.farmName,
          farmCnpj: farmCnpj ?? current.farmCnpj,
          farmAddress: farmAddress ?? current.farmAddress,
          farmCity: farmCity ?? current.farmCity,
          farmState: farmState ?? current.farmState,
          farmPhone: farmPhone ?? current.farmPhone,
          farmEmail: farmEmail ?? current.farmEmail,
          harvests: harvests ?? current.harvests,
          integrations: integrations ?? current.integrations,
          language: language ?? current.language,
          themeMode: themeMode ?? current.themeMode,
        ),
      );
    }

    try {
      await repository.updateSetting(
        pushNotifications: pushNotifications,
        emailNotifications: emailNotifications,
        automaticAlerts: automaticAlerts,
        offlineMode: offlineMode,
        autoSync: autoSync,
        visualStyle: visualStyle,
        farmLogoPath: farmLogoPath,
        farmName: farmName,
        farmCnpj: farmCnpj,
        farmAddress: farmAddress,
        farmCity: farmCity,
        farmState: farmState,
        farmPhone: farmPhone,
        farmEmail: farmEmail,
        harvests: harvests,
        integrations: integrations,
        language: language,
        themeMode: themeMode,
        userId: userId,
      );
    } catch (e, st) {
      // Revert on error
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }
}
