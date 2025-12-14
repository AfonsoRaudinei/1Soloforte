// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_radar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherRadar _$WeatherRadarFromJson(Map<String, dynamic> json) =>
    _WeatherRadar(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      zoom: (json['zoom'] as num).toInt(),
      radarType: json['radarType'] as String,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WeatherRadarToJson(_WeatherRadar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'zoom': instance.zoom,
      'radarType': instance.radarType,
      'imageUrl': instance.imageUrl,
      'metadata': instance.metadata,
    };
