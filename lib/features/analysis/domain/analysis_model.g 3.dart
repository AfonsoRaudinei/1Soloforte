// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Analysis _$AnalysisFromJson(Map<String, dynamic> json) => _Analysis(
  id: json['id'] as String,
  code: json['code'] as String,
  client: Client.fromJson(json['client'] as Map<String, dynamic>),
  area: GeoArea.fromJson(json['area'] as Map<String, dynamic>),
  type: $enumDecode(_$AnalysisTypeEnumMap, json['type']),
  status: $enumDecode(_$AnalysisStatusEnumMap, json['status']),
  date: DateTime.parse(json['date'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AnalysisToJson(_Analysis instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'client': instance.client,
  'area': instance.area,
  'type': _$AnalysisTypeEnumMap[instance.type]!,
  'status': _$AnalysisStatusEnumMap[instance.status]!,
  'date': instance.date.toIso8601String(),
  'notes': instance.notes,
};

const _$AnalysisTypeEnumMap = {
  AnalysisType.chemical: 'chemical',
  AnalysisType.physical: 'physical',
  AnalysisType.biological: 'biological',
};

const _$AnalysisStatusEnumMap = {
  AnalysisStatus.pending: 'pending',
  AnalysisStatus.collecting: 'collecting',
  AnalysisStatus.processing: 'processing',
  AnalysisStatus.completed: 'completed',
};
