import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'occurrence_report_state.dart';

part 'occurrence_report_controller.g.dart';

@riverpod
class OccurrenceReportController extends _$OccurrenceReportController {
  @override
  OccurrenceReportState build() {
    return OccurrenceReportState.initial();
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    _calculateDap();
  }

  void updatePlantingDate(DateTime? date) {
    state = state.copyWith(plantingDate: date);
    _calculateDap();
  }

  void _calculateDap() {
    if (state.plantingDate != null) {
      final dap = state.selectedDate.difference(state.plantingDate!).inDays;
      state = state.copyWith(dap: dap);
    }
  }

  void setStage(String? stage) {
    state = state.copyWith(selectedStage: stage);
  }

  void toggleCategory(String category) {
    final current = Set<String>.from(state.selectedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    state = state.copyWith(selectedCategories: current);
  }

  void toggleNutrient(String nutrient) {
    final current = Set<String>.from(state.selectedNutrients);
    if (current.contains(nutrient)) {
      current.remove(nutrient);
    } else {
      current.add(nutrient);
    }
    state = state.copyWith(selectedNutrients: current);
  }

  void updateSeverity(String key, double value) {
    final newMap = Map<String, double>.from(state.severityData);
    newMap[key] = value;
    state = state.copyWith(severityData: newMap);
  }

  void updateCategoryNote(String key, String note) {
    final newMap = Map<String, String>.from(state.categoryNotes);
    newMap[key] = note;
    state = state.copyWith(categoryNotes: newMap);
  }

  void setOccurrenceType(String type) {
    state = state.copyWith(occurrenceType: type);
  }

  void toggleSoilSample(bool value) {
    state = state.copyWith(soilSample: value);
  }

  void setCoordinates(double lat, double long) {
    state = state.copyWith(latitude: lat, longitude: long);
  }

  Future<void> saveReport({
    required String produtor,
    required String propriedade,
    required String area,
    required String cultivar,
    required String tecnico,
    required String observacoes,
    required String recomendacoes,
  }) async {
    state = state.copyWith(isSaving: true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Here logic maps state to domain Entity and calls repo

    state = state.copyWith(isSaving: false);
  }
}
