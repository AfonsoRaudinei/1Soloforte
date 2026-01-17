// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AreaImpl _$$AreaImplFromJson(Map<String, dynamic> json) => _$AreaImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  hectares: (json['hectares'] as num).toDouble(),
  clientId: json['clientId'] as String? ?? '',
  clienteNome: json['clienteNome'] as String,
  fazendaNome: json['fazendaNome'] as String,
  status: json['status'] as String? ?? 'active',
  coordinates: (json['coordinates'] as List<dynamic>)
      .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
      .toList(),
  culture: json['culture'] as String?,
  safra: json['safra'] as String?,
  ndviAverage: (json['ndviAverage'] as num?)?.toDouble() ?? 0.0,
  lastUpdate: json['lastUpdate'] == null
      ? null
      : DateTime.parse(json['lastUpdate'] as String),
);

Map<String, dynamic> _$$AreaImplToJson(_$AreaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hectares': instance.hectares,
      'clientId': instance.clientId,
      'clienteNome': instance.clienteNome,
      'fazendaNome': instance.fazendaNome,
      'status': instance.status,
      'coordinates': instance.coordinates,
      'culture': instance.culture,
      'safra': instance.safra,
      'ndviAverage': instance.ndviAverage,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };
