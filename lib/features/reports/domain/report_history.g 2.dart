// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedReport _$SavedReportFromJson(Map<String, dynamic> json) => _SavedReport(
  id: json['id'] as String,
  title: json['title'] as String,
  template: $enumDecode(_$ReportTemplateEnumMap, json['template']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  configuration: ReportConfiguration.fromJson(
    json['configuration'] as Map<String, dynamic>,
  ),
  pdfPath: json['pdfPath'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  sharedLink: json['sharedLink'] as String?,
  lastViewedAt: json['lastViewedAt'] == null
      ? null
      : DateTime.parse(json['lastViewedAt'] as String),
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SavedReportToJson(_SavedReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'template': _$ReportTemplateEnumMap[instance.template]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'configuration': instance.configuration,
      'pdfPath': instance.pdfPath,
      'fileSizeBytes': instance.fileSizeBytes,
      'isFavorite': instance.isFavorite,
      'sharedLink': instance.sharedLink,
      'lastViewedAt': instance.lastViewedAt?.toIso8601String(),
      'viewCount': instance.viewCount,
    };

const _$ReportTemplateEnumMap = {
  ReportTemplate.weekly: 'weekly',
  ReportTemplate.ndvi: 'ndvi',
  ReportTemplate.cropSummary: 'cropSummary',
  ReportTemplate.pest: 'pest',
  ReportTemplate.custom: 'custom',
};

_ReportSchedule _$ReportScheduleFromJson(Map<String, dynamic> json) =>
    _ReportSchedule(
      id: json['id'] as String,
      title: json['title'] as String,
      template: $enumDecode(_$ReportTemplateEnumMap, json['template']),
      configuration: ReportConfiguration.fromJson(
        json['configuration'] as Map<String, dynamic>,
      ),
      frequency: $enumDecode(_$ScheduleFrequencyEnumMap, json['frequency']),
      nextRunAt: DateTime.parse(json['nextRunAt'] as String),
      lastRunAt: json['lastRunAt'] == null
          ? null
          : DateTime.parse(json['lastRunAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      emailRecipients: (json['emailRecipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReportScheduleToJson(_ReportSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'template': _$ReportTemplateEnumMap[instance.template]!,
      'configuration': instance.configuration,
      'frequency': _$ScheduleFrequencyEnumMap[instance.frequency]!,
      'nextRunAt': instance.nextRunAt.toIso8601String(),
      'lastRunAt': instance.lastRunAt?.toIso8601String(),
      'isActive': instance.isActive,
      'emailRecipients': instance.emailRecipients,
      'notes': instance.notes,
    };

const _$ScheduleFrequencyEnumMap = {
  ScheduleFrequency.daily: 'daily',
  ScheduleFrequency.weekly: 'weekly',
  ScheduleFrequency.monthly: 'monthly',
  ScheduleFrequency.custom: 'custom',
};
