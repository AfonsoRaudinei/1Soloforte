// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparison_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComparisonItemImpl _$$ComparisonItemImplFromJson(Map<String, dynamic> json) =>
    _$ComparisonItemImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      imagePaths:
          (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      productivity: (json['productivity'] as num?)?.toDouble() ?? null,
      ndvi: (json['ndvi'] as num?)?.toDouble() ?? null,
      biomass: (json['biomass'] as num?)?.toDouble() ?? null,
      productivityUnit: json['productivityUnit'] as String? ?? 'sc/ha',
      order: (json['order'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String? ?? null,
      color: json['color'] as String? ?? null,
    );

Map<String, dynamic> _$$ComparisonItemImplToJson(
  _$ComparisonItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'imagePaths': instance.imagePaths,
  'productivity': instance.productivity,
  'ndvi': instance.ndvi,
  'biomass': instance.biomass,
  'productivityUnit': instance.productivityUnit,
  'order': instance.order,
  'notes': instance.notes,
  'color': instance.color,
};

_$ComparisonSetImpl _$$ComparisonSetImplFromJson(Map<String, dynamic> json) =>
    _$ComparisonSetImpl(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ComparisonItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      title: json['title'] as String? ?? null,
      notes: json['notes'] as String? ?? null,
      comparisonType: json['comparisonType'] as String? ?? 'custom',
    );

Map<String, dynamic> _$$ComparisonSetImplToJson(_$ComparisonSetImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'title': instance.title,
      'notes': instance.notes,
      'comparisonType': instance.comparisonType,
    };
