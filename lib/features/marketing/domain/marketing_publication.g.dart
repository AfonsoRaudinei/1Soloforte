// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketing_publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicationPhotoImpl _$$PublicationPhotoImplFromJson(
  Map<String, dynamic> json,
) => _$PublicationPhotoImpl(
  id: json['id'] as String,
  path: json['path'] as String,
  caption: json['caption'] as String? ?? '',
  isCover: json['isCover'] as bool? ?? false,
  order: (json['order'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$PublicationPhotoImplToJson(
  _$PublicationPhotoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'path': instance.path,
  'caption': instance.caption,
  'isCover': instance.isCover,
  'order': instance.order,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_$ComparisonEntryImpl _$$ComparisonEntryImplFromJson(
  Map<String, dynamic> json,
) => _$ComparisonEntryImpl(
  id: json['id'] as String,
  label: json['label'] as String,
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PublicationPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  productivity: (json['productivity'] as num?)?.toDouble(),
  ndvi: (json['ndvi'] as num?)?.toDouble(),
  biomass: (json['biomass'] as num?)?.toDouble(),
  productivityUnit: json['productivityUnit'] as String? ?? 'sc/ha',
  notes: json['notes'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ComparisonEntryImplToJson(
  _$ComparisonEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'photos': instance.photos,
  'productivity': instance.productivity,
  'ndvi': instance.ndvi,
  'biomass': instance.biomass,
  'productivityUnit': instance.productivityUnit,
  'notes': instance.notes,
  'order': instance.order,
};

_$MarketingPinImpl _$$MarketingPinImplFromJson(Map<String, dynamic> json) =>
    _$MarketingPinImpl(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      publicationId: json['publicationId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MarketingPinImplToJson(_$MarketingPinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'publicationId': instance.publicationId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$MarketingPublicationImpl _$$MarketingPublicationImplFromJson(
  Map<String, dynamic> json,
) => _$MarketingPublicationImpl(
  id: json['id'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  clientId: json['clientId'] as String?,
  clientName: json['clientName'] as String?,
  areaId: json['areaId'] as String?,
  areaName: json['areaName'] as String?,
  type:
      $enumDecodeNullable(_$PublicationTypeEnumMap, json['type']) ??
      PublicationType.caseSucesso,
  title: json['title'] as String?,
  description: json['description'] as String?,
  product: json['product'] as String?,
  campaign: json['campaign'] as String?,
  harvest: json['harvest'] as String?,
  sellerName: json['sellerName'] as String?,
  sellerPhone: json['sellerPhone'] as String?,
  companyName: json['companyName'] as String?,
  comparisons:
      (json['comparisons'] as List<dynamic>?)
          ?.map((e) => ComparisonEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  comparisonType: json['comparisonType'] as String? ?? 'custom',
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PublicationPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  highlightMetric: json['highlightMetric'] as String?,
  highlightValue: (json['highlightValue'] as num?)?.toDouble(),
  highlightUnit: json['highlightUnit'] as String? ?? 'sc/ha',
  showPercentage: json['showPercentage'] as bool? ?? true,
  investmentLevel: json['investmentLevel'] as String? ?? 'prata',
  isVisible: json['isVisible'] as bool? ?? true,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  status: json['status'] as String? ?? 'draft',
);

Map<String, dynamic> _$$MarketingPublicationImplToJson(
  _$MarketingPublicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'areaId': instance.areaId,
  'areaName': instance.areaName,
  'type': _$PublicationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'description': instance.description,
  'product': instance.product,
  'campaign': instance.campaign,
  'harvest': instance.harvest,
  'sellerName': instance.sellerName,
  'sellerPhone': instance.sellerPhone,
  'companyName': instance.companyName,
  'comparisons': instance.comparisons,
  'comparisonType': instance.comparisonType,
  'photos': instance.photos,
  'highlightMetric': instance.highlightMetric,
  'highlightValue': instance.highlightValue,
  'highlightUnit': instance.highlightUnit,
  'showPercentage': instance.showPercentage,
  'investmentLevel': instance.investmentLevel,
  'isVisible': instance.isVisible,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'publishedAt': instance.publishedAt?.toIso8601String(),
  'status': instance.status,
};

const _$PublicationTypeEnumMap = {
  PublicationType.antesDepois: 'antes_depois',
  PublicationType.aplicacao: 'aplicacao',
  PublicationType.resultado: 'resultado',
  PublicationType.comparativo: 'comparativo',
  PublicationType.caseSucesso: 'case_sucesso',
};
