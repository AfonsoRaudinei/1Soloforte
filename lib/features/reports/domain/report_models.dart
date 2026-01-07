import 'dart:typed_data';
import 'package:soloforte_app/features/ndvi/domain/ndvi_heatmap_point.dart';

// --- Weekly Report Models ---
class WeeklyReportData {
  final List<String> activities;
  final int occurrences;
  final int applications;
  final int teamCheckins;
  final String weatherSummary;
  final List<String> nextActions;

  WeeklyReportData({
    required this.activities,
    required this.occurrences,
    required this.applications,
    required this.teamCheckins,
    required this.weatherSummary,
    required this.nextActions,
  });
}

class NdviAnalysisData {
  final List<NdviDataPoint> temporalEvolution;
  final List<AreaComparison> areaComparisons;
  final Uint8List? attentionZoneImageBytes; // Image bytes
  final List<NdviHeatmapPoint>? heatmapPoints; // List of parsed points
  final double correlationWithWeather; // -1.0 to 1.0

  NdviAnalysisData({
    required this.temporalEvolution,
    required this.areaComparisons,
    this.attentionZoneImageBytes,
    this.heatmapPoints, // New field for real data
    required this.correlationWithWeather,
  });
}

class NdviDataPoint {
  final DateTime date;
  final double value;

  NdviDataPoint(this.date, this.value);
}

class AreaComparison {
  final String areaName;
  final double currentNdvi;
  final double growth; // percentage

  AreaComparison({
    required this.areaName,
    required this.currentNdvi,
    required this.growth,
  });
}

// --- Crop Summary Models ---
class CropSummaryData {
  final double plantedArea; // Hectares
  final String phenologicalStage;
  final double estimatedProductivity; // sc/ha
  final double realProductivity; // sc/ha (if available)
  final double costPerHectare; // R$
  final List<String> problemsFaces;
  final List<String> lessonsLearned;

  CropSummaryData({
    required this.plantedArea,
    required this.phenologicalStage,
    required this.estimatedProductivity,
    this.realProductivity = 0,
    required this.costPerHectare,
    required this.problemsFaces,
    required this.lessonsLearned,
  });
}

// --- Pest Report Models ---
class PestReportData {
  final int totalOccurrences;
  final Map<String, int>
  distributionByType; // e.g., {'Lagartas': 10, 'Percevejos': 5}
  final String averageSeverity; // Leve, Moderada, Alta
  final List<TreatmentData> treatments;
  final double totalCost;

  PestReportData({
    required this.totalOccurrences,
    required this.distributionByType,
    required this.averageSeverity,
    required this.treatments,
    required this.totalCost,
  });
}

class TreatmentData {
  final String name;
  final DateTime date;
  final double efficacy; // 0.0 to 1.0

  TreatmentData({
    required this.name,
    required this.date,
    required this.efficacy,
  });
}

// --- Custom Report Models ---
enum ReportSectionType { chart, text, table, map, metrics }

class ReportSection {
  final String id;
  final String title;
  final ReportSectionType type;
  bool isVisible;

  ReportSection({
    required this.id,
    required this.title,
    required this.type,
    this.isVisible = true,
  });
}
