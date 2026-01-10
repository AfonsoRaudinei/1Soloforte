// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$AppSettingsImpl(
  pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? true,
  emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? true,
  automaticAlertsEnabled: json['automaticAlertsEnabled'] as bool? ?? true,
  offlineModeEnabled: json['offlineModeEnabled'] as bool? ?? false,
  autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? true,
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  visualStyle: json['visualStyle'] as String? ?? 'ios',
  farmLogoPath: json['farmLogoPath'] as String?,
  language: json['language'] as String?,
);

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'automaticAlertsEnabled': instance.automaticAlertsEnabled,
      'offlineModeEnabled': instance.offlineModeEnabled,
      'autoSyncEnabled': instance.autoSyncEnabled,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'visualStyle': instance.visualStyle,
      'farmLogoPath': instance.farmLogoPath,
      'language': instance.language,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
