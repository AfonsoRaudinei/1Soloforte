// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Farm _$FarmFromJson(Map<String, dynamic> json) => _Farm(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  name: json['name'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  address: json['address'] as String?,
  totalAreaHa: (json['totalAreaHa'] as num?)?.toDouble(),
  totalAreas: (json['totalAreas'] as num?)?.toInt(),
  description: json['description'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FarmToJson(_Farm instance) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'name': instance.name,
  'city': instance.city,
  'state': instance.state,
  'address': instance.address,
  'totalAreaHa': instance.totalAreaHa,
  'totalAreas': instance.totalAreas,
  'description': instance.description,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
