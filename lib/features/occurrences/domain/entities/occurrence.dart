import 'package:freezed_annotation/freezed_annotation.dart';

part 'occurrence.freezed.dart';

@freezed
class Occurrence with _$Occurrence {
  const factory Occurrence({
    required String id,
    required String title,
    required String description,
    required String type,
    required double severity,
    required String areaName,
    required DateTime date,
    required String status,
    required List<String> images,
    required double latitude,
    required double longitude,
    @Default([]) List<TimelineEvent> timeline,
    String? assignedTo,
    @Default([]) List<String> recommendations,
    @Default('VE - Emergência') String phenologicalStage,
    @Default({}) Map<String, double> categorySeverities,
    @Default({}) Map<String, List<String>> categoryImages,
    @Default('') String technicalRecommendation,
    @Default('') String technicalResponsible,
    @Default('Sazonal') String temporalType,
    @Default(false) bool hasSoilSample,
  }) = _Occurrence;
}

@freezed
class TimelineEvent with _$TimelineEvent {
  const factory TimelineEvent({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required String type,
    required String authorName,
  }) = _TimelineEvent;
}
