// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occurrence_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OccurrenceDtoImpl _$$OccurrenceDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OccurrenceDtoImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  severity: (json['severity'] as num).toDouble(),
  areaName: json['areaName'] as String,
  date: DateTime.parse(json['date'] as String),
  status: json['status'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineEventDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  assignedTo: json['assignedTo'] as String?,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  phenologicalStage: json['phenologicalStage'] as String? ?? 'VE - Emergência',
  categorySeverities:
      (json['categorySeverities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  categoryImages:
      (json['categoryImages'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const {},
  technicalRecommendation: json['technicalRecommendation'] as String? ?? '',
  technicalResponsible: json['technicalResponsible'] as String? ?? '',
  temporalType: json['temporalType'] as String? ?? 'Sazonal',
  hasSoilSample: json['hasSoilSample'] as bool? ?? false,
);

Map<String, dynamic> _$$OccurrenceDtoImplToJson(_$OccurrenceDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'severity': instance.severity,
      'areaName': instance.areaName,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'images': instance.images,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timeline': instance.timeline,
      'assignedTo': instance.assignedTo,
      'recommendations': instance.recommendations,
      'phenologicalStage': instance.phenologicalStage,
      'categorySeverities': instance.categorySeverities,
      'categoryImages': instance.categoryImages,
      'technicalRecommendation': instance.technicalRecommendation,
      'technicalResponsible': instance.technicalResponsible,
      'temporalType': instance.temporalType,
      'hasSoilSample': instance.hasSoilSample,
    };

_$TimelineEventDtoImpl _$$TimelineEventDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TimelineEventDtoImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  type: json['type'] as String,
  authorName: json['authorName'] as String,
);

Map<String, dynamic> _$$TimelineEventDtoImplToJson(
  _$TimelineEventDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'type': instance.type,
  'authorName': instance.authorName,
};
