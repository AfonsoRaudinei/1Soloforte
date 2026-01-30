import 'package:freezed_annotation/freezed_annotation.dart';

part 'technical_report.freezed.dart';
part 'technical_report.g.dart';

@freezed
class TechnicalReport with _$TechnicalReport {
  const factory TechnicalReport({
    required String id,
    required String visitId,
    required String clientId,
    required String clientName,
    required DateTime generatedAt,
    required String technicalResponsible,
    @Default([]) List<ConsolidatedOccurrence> occurrences,
    @Default([]) List<String> visitPhotos,
    String? visitNotes,
    double? visitLatitude,
    double? visitLongitude,
  }) = _TechnicalReport;

  factory TechnicalReport.fromJson(Map<String, dynamic> json) =>
      _$TechnicalReportFromJson(json);
}

@freezed
class ConsolidatedOccurrence with _$ConsolidatedOccurrence {
  const factory ConsolidatedOccurrence({
    required String originalId,
    required String type,
    required String title,
    required String description,
    required DateTime date,
    required double latitude,
    required double longitude,
    required List<String> photos,
    required double severity,
    String? technicalRecommendation,
    required String riskLevel, // Derived or mapped from severity
  }) = _ConsolidatedOccurrence;

  factory ConsolidatedOccurrence.fromJson(Map<String, dynamic> json) =>
      _$ConsolidatedOccurrenceFromJson(json);
}
