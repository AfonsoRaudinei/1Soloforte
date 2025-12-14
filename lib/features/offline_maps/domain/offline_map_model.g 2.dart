// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_map_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfflineMap _$OfflineMapFromJson(Map<String, dynamic> json) => _OfflineMap(
  id: json['id'] as String,
  name: json['name'] as String,
  minLat: (json['minLat'] as num).toDouble(),
  maxLat: (json['maxLat'] as num).toDouble(),
  minLng: (json['minLng'] as num).toDouble(),
  maxLng: (json['maxLng'] as num).toDouble(),
  zoomLevel: (json['zoomLevel'] as num).toInt(),
  downloadedAt: DateTime.parse(json['downloadedAt'] as String),
  sizeBytes: (json['sizeBytes'] as num).toInt(),
  isDownloading: json['isDownloading'] as bool? ?? false,
  downloadProgress: (json['downloadProgress'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$OfflineMapToJson(_OfflineMap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'minLat': instance.minLat,
      'maxLat': instance.maxLat,
      'minLng': instance.minLng,
      'maxLng': instance.maxLng,
      'zoomLevel': instance.zoomLevel,
      'downloadedAt': instance.downloadedAt.toIso8601String(),
      'sizeBytes': instance.sizeBytes,
      'isDownloading': instance.isDownloading,
      'downloadProgress': instance.downloadProgress,
    };
