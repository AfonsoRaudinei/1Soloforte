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
  farmName: json['farmName'] as String?,
  farmCnpj: json['farmCnpj'] as String?,
  farmAddress: json['farmAddress'] as String?,
  farmCity: json['farmCity'] as String?,
  farmState: json['farmState'] as String?,
  farmPhone: json['farmPhone'] as String?,
  farmEmail: json['farmEmail'] as String?,
  harvests:
      (json['harvests'] as List<dynamic>?)
          ?.map((e) => HarvestSetting.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  integrations:
      (json['integrations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
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
      'farmName': instance.farmName,
      'farmCnpj': instance.farmCnpj,
      'farmAddress': instance.farmAddress,
      'farmCity': instance.farmCity,
      'farmState': instance.farmState,
      'farmPhone': instance.farmPhone,
      'farmEmail': instance.farmEmail,
      'harvests': instance.harvests,
      'integrations': instance.integrations,
      'language': instance.language,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

_$HarvestSettingImpl _$$HarvestSettingImplFromJson(Map<String, dynamic> json) =>
    _$HarvestSettingImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$HarvestSettingImplToJson(
  _$HarvestSettingImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isActive': instance.isActive,
};
