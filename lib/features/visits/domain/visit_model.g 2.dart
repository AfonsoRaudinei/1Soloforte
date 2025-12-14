// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Visit _$VisitFromJson(Map<String, dynamic> json) => _Visit(
  id: json['id'] as String,
  client: Client.fromJson(json['client'] as Map<String, dynamic>),
  checkInTime: DateTime.parse(json['checkInTime'] as String),
  checkOutTime: json['checkOutTime'] == null
      ? null
      : DateTime.parse(json['checkOutTime'] as String),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  checkOutNotes: json['checkOutNotes'] as String?,
);

Map<String, dynamic> _$VisitToJson(_Visit instance) => <String, dynamic>{
  'id': instance.id,
  'client': instance.client,
  'checkInTime': instance.checkInTime.toIso8601String(),
  'checkOutTime': instance.checkOutTime?.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'checkOutNotes': instance.checkOutNotes,
};
