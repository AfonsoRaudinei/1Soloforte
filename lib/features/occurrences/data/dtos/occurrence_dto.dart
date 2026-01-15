import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/occurrence.dart';

part 'occurrence_dto.freezed.dart';
part 'occurrence_dto.g.dart';

@freezed
class OccurrenceDto with _$OccurrenceDto {
  const OccurrenceDto._();

  const factory OccurrenceDto({
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
    @Default([]) List<TimelineEventDto> timeline,
    String? assignedTo,
    @Default([]) List<String> recommendations,
    @Default('VE - Emergência') String phenologicalStage,
    @Default({}) Map<String, double> categorySeverities,
    @Default({}) Map<String, List<String>> categoryImages,
    @Default('') String technicalRecommendation,
    @Default('') String technicalResponsible,
    @Default('Sazonal') String temporalType,
    @Default(false) bool hasSoilSample,
  }) = _OccurrenceDto;

  factory OccurrenceDto.fromJson(Map<String, dynamic> json) =>
      _$OccurrenceDtoFromJson(json);

  factory OccurrenceDto.fromDomain(Occurrence occurrence) {
    return OccurrenceDto(
      id: occurrence.id,
      title: occurrence.title,
      description: occurrence.description,
      type: occurrence.type,
      severity: occurrence.severity,
      areaName: occurrence.areaName,
      date: occurrence.date,
      status: occurrence.status,
      images: occurrence.images,
      latitude: occurrence.latitude,
      longitude: occurrence.longitude,
      timeline: occurrence.timeline
          .map((e) => TimelineEventDto.fromDomain(e))
          .toList(),
      assignedTo: occurrence.assignedTo,
      recommendations: occurrence.recommendations,
      phenologicalStage: occurrence.phenologicalStage,
      categorySeverities: occurrence.categorySeverities,
      categoryImages: occurrence.categoryImages,
      technicalRecommendation: occurrence.technicalRecommendation,
      technicalResponsible: occurrence.technicalResponsible,
      temporalType: occurrence.temporalType,
      hasSoilSample: occurrence.hasSoilSample,
    );
  }

  Occurrence toDomain() {
    return Occurrence(
      id: id,
      title: title,
      description: description,
      type: type,
      severity: severity,
      areaName: areaName,
      date: date,
      status: status,
      images: images,
      latitude: latitude,
      longitude: longitude,
      timeline: timeline.map((e) => e.toDomain()).toList(),
      assignedTo: assignedTo,
      recommendations: recommendations,
      phenologicalStage: phenologicalStage,
      categorySeverities: categorySeverities,
      categoryImages: categoryImages,
      technicalRecommendation: technicalRecommendation,
      technicalResponsible: technicalResponsible,
      temporalType: temporalType,
      hasSoilSample: hasSoilSample,
    );
  }
}

@freezed
class TimelineEventDto with _$TimelineEventDto {
  const TimelineEventDto._();

  const factory TimelineEventDto({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required String type,
    required String authorName,
  }) = _TimelineEventDto;

  factory TimelineEventDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventDtoFromJson(json);

  factory TimelineEventDto.fromDomain(TimelineEvent event) {
    return TimelineEventDto(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      type: event.type,
      authorName: event.authorName,
    );
  }

  TimelineEvent toDomain() {
    return TimelineEvent(
      id: id,
      title: title,
      description: description,
      date: date,
      type: type,
      authorName: authorName,
    );
  }
}
