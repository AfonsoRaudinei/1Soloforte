// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AreaDtoImpl _$$AreaDtoImplFromJson(Map<String, dynamic> json) =>
    _$AreaDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      hectares: (json['hectares'] as num).toDouble(),
      clientId: json['clientId'] as String? ?? '',
      clienteNome: json['clienteNome'] as String,
      fazendaNome: json['fazendaNome'] as String,
      status: json['status'] as String? ?? 'active',
      coordinates: _latLngListFromJson(json['coordinates'] as List),
      culture: json['culture'] as String?,
      safra: json['safra'] as String?,
      ndviAverage: (json['ndviAverage'] as num?)?.toDouble() ?? 0.0,
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$$AreaDtoImplToJson(_$AreaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hectares': instance.hectares,
      'clientId': instance.clientId,
      'clienteNome': instance.clienteNome,
      'fazendaNome': instance.fazendaNome,
      'status': instance.status,
      'coordinates': _latLngListToJson(instance.coordinates),
      'culture': instance.culture,
      'safra': instance.safra,
      'ndviAverage': instance.ndviAverage,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };
