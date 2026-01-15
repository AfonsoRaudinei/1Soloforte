import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

abstract class ISettingsRemoteDataSource {
  Future<AppSettings?> getSettings(String userId);
  Future<void> saveSettings(String userId, AppSettings settings);
}

class SettingsRemoteDataSource implements ISettingsRemoteDataSource {
  final SupabaseClient _supabase;

  SettingsRemoteDataSource(this._supabase);

  @override
  Future<AppSettings?> getSettings(String userId) async {
    try {
      // 1. Fetch User Settings
      final userData = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      // 2. Fetch Farm Settings (Assuming user has one main farm for now or taking the first one)
      // The prompt says "Persist by farm_id", but we need to know WHICH farm.
      // For simplicity/requirement, we'll try to find a farm where user is owner or associated.
      // Or we can just store everything in user_settings if farm_id isn't strictly managed yet.
      // REQUIREMENT: "farm_settings -> user_id (owner)"
      final farmData = await _supabase
          .from('farm_settings')
          .select()
          .eq('user_id', userId)
          //.limit(1) // Assuming 1 farm per user for this MVP/Phase
          .maybeSingle();

      if (userData == null && farmData == null) {
        return null;
      }

      // Map User Data
      // user_settings: theme, language, notifications_push, notifications_email, notifications_automatic
      // farm_settings: name, data_json, active_crop_year, crops_json, integrations_json, auto_sync, logo_ref

      final userMap = userData ?? {};
      final farmMap = farmData ?? {};

      // Parse JSONBs
      final farmInfo = farmMap['data_json'] ?? {}; // Address, contacts
      final cropsList =
          (farmMap['crops_json'] as List?)
              ?.map((e) => HarvestSetting.fromJson(e))
              .toList() ??
          [];
      final integrationsMap = Map<String, bool>.from(
        farmMap['integrations_json'] ?? {},
      );

      // Helper to parse ThemeMode
      ThemeMode mode = ThemeMode.system;
      if (userMap['theme'] == 'light') mode = ThemeMode.light;
      if (userMap['theme'] == 'dark') mode = ThemeMode.dark;

      return AppSettings(
        // User Settings
        themeMode: mode,
        language: userMap['language'],
        pushNotificationsEnabled: userMap['notifications_push'] ?? true,
        emailNotificationsEnabled: userMap['notifications_email'] ?? true,
        automaticAlertsEnabled: userMap['notifications_automatic'] ?? true,

        // Farm Settings
        farmName: farmMap['name'],
        farmLogoPath: farmMap['logo_ref'], // Just the ref/path
        autoSyncEnabled: farmMap['auto_sync'] ?? true,

        // Farm Info (from data_json)
        farmCnpj: farmInfo['cnpj'],
        farmAddress: farmInfo['address'],
        farmCity: farmInfo['city'],
        farmState: farmInfo['state'],
        farmPhone: farmInfo['phone'],
        farmEmail: farmInfo['email'],

        // Collections
        harvests: cropsList,
        integrations: integrationsMap,

        // Note: active_crop_year from DB could be used to set 'isActive' in harvests list if needed,
        // but our AppSettings entity has 'isActive' inside HarvestSetting.
        // We assume the stored JSON list has the correct active state.
      );
    } catch (e) {
      debugPrint('Error fetching remote settings: $e');
      return null;
    }
  }

  @override
  Future<void> saveSettings(String userId, AppSettings settings) async {
    try {
      // 1. Upsert User Settings
      final userPayload = {
        'user_id': userId,
        'theme': settings.themeMode.name, // system, light, dark
        'language': settings.language,
        'notifications_push': settings.pushNotificationsEnabled,
        'notifications_email': settings.emailNotificationsEnabled,
        'notifications_automatic': settings.automaticAlertsEnabled,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('user_settings')
          .upsert(
            userPayload,
          ); // upsert requires primary key constraint (usually user_id)

      // 2. Upsert Farm Settings
      // We need a farm_id. If specific one exists in settings, use it.
      // If not, we might generate one or rely on user_id as owner if schema allows.
      // For this MVP, let's assume valid user_id is the key or we create a deterministic UUID?
      // Actually, if we don't have farm_id in AppSettings, we can't reliably update a SPECIFIC farm record
      // without first querying "What is this user's farm?".
      // But 'saveSettings' implies we persist current state.

      // We'll try to find an existing farm for this user to get the ID, or create new.
      final existingFarm = await _supabase
          .from('farm_settings')
          .select('farm_id')
          .eq('user_id', userId)
          .maybeSingle();
      final farmId =
          existingFarm?['farm_id']; // If null, Supabase might generate if we omit, or we need to gen UUID.

      // Structure farm info JSON
      final farmInfoJson = {
        'cnpj': settings.farmCnpj,
        'address': settings.farmAddress,
        'city': settings.farmCity,
        'state': settings.farmState,
        'phone': settings.farmPhone,
        'email': settings.farmEmail,
      };

      // Structure crops JSON
      final cropsJson = settings.harvests.map((e) => e.toJson()).toList();

      final farmPayload = {
        if (farmId != null)
          'farm_id':
              farmId, // Include only if we have it, otherwise let DB gen or fail?
        'user_id': userId,
        'name': settings.farmName,
        'data_json': farmInfoJson,
        'active_crop_year': settings.harvests
            .firstWhere(
              (h) => h.isActive,
              orElse: () => const HarvestSetting(id: '', name: ''),
            )
            .name,
        'crops_json': cropsJson,
        'integrations_json': settings.integrations,
        'auto_sync': settings.autoSyncEnabled,
        'logo_ref': settings.farmLogoPath,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // If we don't have farmId, we assume upsert on 'user_id' if that's unique? NO, farm_settings PK is usually farm_id.
      // But prompt says "Persist por farm_id".
      // If we are creating, we insert. If updating, we update.
      // 'upsert' works if we provide the PK.
      if (farmId != null) {
        await _supabase.from('farm_settings').upsert(farmPayload);
      } else {
        // Create new
        await _supabase.from('farm_settings').insert(farmPayload);
      }
    } catch (e) {
      debugPrint('Error saving remote settings: $e');
      rethrow;
    }
  }
}
