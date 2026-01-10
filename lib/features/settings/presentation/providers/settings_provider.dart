import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../data/datasources/settings_local_datasource.dart';
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
ISettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final localDataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(localDataSource);
}

// --- Presentation Layer Controller ---

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<AppSettings> build() async {
    return _getSettings();
  }

  Future<AppSettings> _getSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getSettings();
  }

  Future<void> updateSetting({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? automaticAlerts,
    bool? offlineMode,
    bool? autoSync,
    String? visualStyle,
    String? farmLogoPath,
  }) async {
    final repository = ref.read(settingsRepositoryProvider);

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
      );
    } catch (e, st) {
      // Revert on error
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }
}
