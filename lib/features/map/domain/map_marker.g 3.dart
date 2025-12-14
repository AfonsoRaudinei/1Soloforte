// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapPoint _$MapPointFromJson(Map<String, dynamic> json) => _MapPoint(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  type: json['type'] as String,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$MapPointToJson(_MapPoint instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'type': instance.type,
  'timestamp': instance.timestamp?.toIso8601String(),
};
