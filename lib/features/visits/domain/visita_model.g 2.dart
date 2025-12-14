// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visita_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Visita _$VisitaFromJson(Map<String, dynamic> json) => _Visita(
  id: json['id'] as String,
  clienteId: json['clienteId'] as String,
  fazendaId: json['fazendaId'] as String,
  clienteNome: json['clienteNome'] as String,
  fazendaNome: json['fazendaNome'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  status: json['status'] as String? ?? 'em_andamento',
  observacoes: json['observacoes'] as String?,
  fotos: (json['fotos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  talhaoId: json['talhaoId'] as String?,
  talhaoNome: json['talhaoNome'] as String?,
);

Map<String, dynamic> _$VisitaToJson(_Visita instance) => <String, dynamic>{
  'id': instance.id,
  'clienteId': instance.clienteId,
  'fazendaId': instance.fazendaId,
  'clienteNome': instance.clienteNome,
  'fazendaNome': instance.fazendaNome,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'status': instance.status,
  'observacoes': instance.observacoes,
  'fotos': instance.fotos,
  'talhaoId': instance.talhaoId,
  'talhaoNome': instance.talhaoNome,
};
