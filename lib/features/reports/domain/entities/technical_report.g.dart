// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TechnicalReportImpl _$$TechnicalReportImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicalReportImpl(
  id: json['id'] as String,
  visitId: json['visitId'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  technicalResponsible: json['technicalResponsible'] as String,
  occurrences:
      (json['occurrences'] as List<dynamic>?)
          ?.map(
            (e) => ConsolidatedOccurrence.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  visitPhotos:
      (json['visitPhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  visitNotes: json['visitNotes'] as String?,
  visitLatitude: (json['visitLatitude'] as num?)?.toDouble(),
  visitLongitude: (json['visitLongitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$TechnicalReportImplToJson(
  _$TechnicalReportImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'visitId': instance.visitId,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'technicalResponsible': instance.technicalResponsible,
  'occurrences': instance.occurrences,
  'visitPhotos': instance.visitPhotos,
  'visitNotes': instance.visitNotes,
  'visitLatitude': instance.visitLatitude,
  'visitLongitude': instance.visitLongitude,
};

_$ConsolidatedOccurrenceImpl _$$ConsolidatedOccurrenceImplFromJson(
  Map<String, dynamic> json,
) => _$ConsolidatedOccurrenceImpl(
  originalId: json['originalId'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  photos: (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
  severity: (json['severity'] as num).toDouble(),
  technicalRecommendation: json['technicalRecommendation'] as String?,
  riskLevel: json['riskLevel'] as String,
);

Map<String, dynamic> _$$ConsolidatedOccurrenceImplToJson(
  _$ConsolidatedOccurrenceImpl instance,
) => <String, dynamic>{
  'originalId': instance.originalId,
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'photos': instance.photos,
  'severity': instance.severity,
  'technicalRecommendation': instance.technicalRecommendation,
  'riskLevel': instance.riskLevel,
};
