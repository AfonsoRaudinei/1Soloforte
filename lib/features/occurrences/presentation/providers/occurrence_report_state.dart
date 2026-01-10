import 'package:freezed_annotation/freezed_annotation.dart';

part 'occurrence_report_state.freezed.dart';

@freezed
class OccurrenceReportState with _$OccurrenceReportState {
  const factory OccurrenceReportState({
    required DateTime selectedDate,
    DateTime? plantingDate,
    @Default(0) int dap,
    String? selectedStage,
    @Default({}) Set<String> selectedCategories,
    @Default({}) Set<String> selectedNutrients,
    @Default({}) Map<String, double> severityData,
    @Default({}) Map<String, String> categoryNotes,
    @Default('sazonal') String occurrenceType,
    @Default(false) bool soilSample,
    double? latitude,
    double? longitude,
    @Default(false) bool isSaving,
  }) = _OccurrenceReportState;

  factory OccurrenceReportState.initial() =>
      OccurrenceReportState(selectedDate: DateTime.now());
}
