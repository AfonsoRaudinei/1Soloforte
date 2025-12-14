// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ndvi_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NDVIRecord _$NDVIRecordFromJson(Map<String, dynamic> json) => _NDVIRecord(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  averageValue: (json['averageValue'] as num).toDouble(),
);

Map<String, dynamic> _$NDVIRecordToJson(_NDVIRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'averageValue': instance.averageValue,
    };
