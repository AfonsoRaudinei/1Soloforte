// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportConfiguration _$ReportConfigurationFromJson(Map<String, dynamic> json) =>
    ReportConfiguration(
      template: $enumDecodeNullable(_$ReportTemplateEnumMap, json['template']),
      dateRange: ReportConfiguration._dateRangeFromJson(
        json['dateRange'] as Map<String, dynamic>?,
      ),
      selectedAreaIds:
          (json['selectedAreaIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      filters: json['filters'] as Map<String, dynamic>? ?? const {},
      selectedMetrics:
          (json['selectedMetrics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customTitle: json['customTitle'] as String?,
      logoPath: json['logoPath'] as String?,
      headerTemplate: json['headerTemplate'] as String?,
      includedSections:
          (json['includedSections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      generalNotes: json['generalNotes'] as String?,
    );

Map<String, dynamic> _$ReportConfigurationToJson(
  ReportConfiguration instance,
) => <String, dynamic>{
  'template': _$ReportTemplateEnumMap[instance.template],
  'dateRange': ReportConfiguration._dateRangeToJson(instance.dateRange),
  'selectedAreaIds': instance.selectedAreaIds,
  'filters': instance.filters,
  'selectedMetrics': instance.selectedMetrics,
  'customTitle': instance.customTitle,
  'logoPath': instance.logoPath,
  'headerTemplate': instance.headerTemplate,
  'includedSections': instance.includedSections,
  'generalNotes': instance.generalNotes,
};

const _$ReportTemplateEnumMap = {
  ReportTemplate.weekly: 'weekly',
  ReportTemplate.ndvi: 'ndvi',
  ReportTemplate.cropSummary: 'cropSummary',
  ReportTemplate.pest: 'pest',
  ReportTemplate.custom: 'custom',
};
