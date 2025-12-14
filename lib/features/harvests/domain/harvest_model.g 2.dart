// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Harvest _$HarvestFromJson(Map<String, dynamic> json) => _Harvest(
  id: json['id'] as String,
  areaId: json['areaId'] as String,
  areaName: json['areaName'] as String,
  cropType: json['cropType'] as String,
  plantedDate: DateTime.parse(json['plantedDate'] as String),
  harvestDate: json['harvestDate'] == null
      ? null
      : DateTime.parse(json['harvestDate'] as String),
  plantedAreaHa: (json['plantedAreaHa'] as num).toDouble(),
  totalProductionBags: (json['totalProductionBags'] as num).toDouble(),
  totalCost: (json['totalCost'] as num).toDouble(),
  status: json['status'] as String,
  notes:
      (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$HarvestToJson(_Harvest instance) => <String, dynamic>{
  'id': instance.id,
  'areaId': instance.areaId,
  'areaName': instance.areaName,
  'cropType': instance.cropType,
  'plantedDate': instance.plantedDate.toIso8601String(),
  'harvestDate': instance.harvestDate?.toIso8601String(),
  'plantedAreaHa': instance.plantedAreaHa,
  'totalProductionBags': instance.totalProductionBags,
  'totalCost': instance.totalCost,
  'status': instance.status,
  'notes': instance.notes,
};
