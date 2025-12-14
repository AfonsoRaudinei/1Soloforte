// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertConfig _$AlertConfigFromJson(Map<String, dynamic> json) => _AlertConfig(
  id: json['id'] as String,
  type: $enumDecode(_$AlertTypeEnumMap, json['type']),
  title: json['title'] as String,
  isEnabled: json['isEnabled'] as bool,
  pushNotification: json['pushNotification'] as bool? ?? true,
  emailNotification: json['emailNotification'] as bool? ?? false,
  smsNotification: json['smsNotification'] as bool? ?? false,
  conditions: json['conditions'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AlertConfigToJson(_AlertConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'title': instance.title,
      'isEnabled': instance.isEnabled,
      'pushNotification': instance.pushNotification,
      'emailNotification': instance.emailNotification,
      'smsNotification': instance.smsNotification,
      'conditions': instance.conditions,
    };

const _$AlertTypeEnumMap = {
  AlertType.weather: 'weather',
  AlertType.pest: 'pest',
  AlertType.ndvi: 'ndvi',
  AlertType.visit: 'visit',
  AlertType.report: 'report',
};
