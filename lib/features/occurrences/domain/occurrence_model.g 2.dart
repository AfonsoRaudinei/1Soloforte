// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Occurrence _$OccurrenceFromJson(Map<String, dynamic> json) => _Occurrence(
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
          ?.map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  assignedTo: json['assignedTo'] as String?,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$OccurrenceToJson(_Occurrence instance) =>
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
    };

_TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    _TimelineEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      authorName: json['authorName'] as String,
    );

Map<String, dynamic> _$TimelineEventToJson(_TimelineEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'authorName': instance.authorName,
    };
