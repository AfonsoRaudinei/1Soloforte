import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:soloforte_app/features/harvests/data/harvest_repository.dart';
import 'package:soloforte_app/features/harvests/data/firestore_harvest_repository.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/ndvi/data/services/sentinel_service.dart';
import 'package:soloforte_app/features/occurrences/data/repositories/occurrence_repository_impl.dart';
import 'package:soloforte_app/features/occurrences/domain/repositories/occurrence_repository.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/features/visits/data/repositories/visit_repository_impl.dart';
import 'package:soloforte_app/features/visits/domain/repositories/visit_repository.dart';

/// Service responsible for collecting and aggregating data for reports.
///
/// This service fetches data from various repositories and services,
/// processes it, and returns structured data models for PDF generation.
class ReportDataService {
  final OccurrenceRepository _occurrenceRepository;
  final HarvestRepository _harvestRepository;
  final VisitRepository _visitRepository;
  final SentinelService _sentinelService;

  ReportDataService({
    required OccurrenceRepository occurrenceRepository,
    required HarvestRepository harvestRepository,
    required VisitRepository visitRepository,
    required SentinelService sentinelService,
  }) : _occurrenceRepository = occurrenceRepository,
       _harvestRepository = harvestRepository,
       _visitRepository = visitRepository,
       _sentinelService = sentinelService;

  // --- Weekly Report Data ---

  Future<WeeklyReportData> getWeeklyReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final start = startDate ?? now.subtract(const Duration(days: 7));
      final end = endDate ?? now;

      // Fetch Data
      final allOccurrences = await _occurrenceRepository.getOccurrences();
      final recentOccurrences = allOccurrences
          .where((o) => o.date.isAfter(start) && o.date.isBefore(end))
          .toList();

      final allVisits = await _visitRepository.getVisits();
      final recentVisits = allVisits
          .where(
            (v) => v.checkInTime.isAfter(start) && v.checkInTime.isBefore(end),
          )
          .toList();

      // Aggregate Activities
      List<String> activities = [];
      activities.addAll(
        recentVisits.map(
          (v) =>
              'Visita: ${v.client.name} - ${DateFormat('dd/MM').format(v.checkInTime)}',
        ),
      );
      activities.addAll(
        recentOccurrences.map(
          (o) =>
              'Ocorrência: ${o.title} - ${DateFormat('dd/MM').format(o.date)}',
        ),
      );

      // Fallback if empty
      if (activities.isEmpty) {
        activities = ['Nenhuma atividade registrada neste período.'];
      }

      return WeeklyReportData(
        activities: activities.take(5).toList(),
        occurrences: recentOccurrences.length,
        applications: 0, // TODO: Implement applications tracking
        teamCheckins: recentVisits.length,
        weatherSummary:
            'Clima predominantemente ensolarado com temperaturas entre 22°C e 30°C.',
        nextActions: [
          'Monitorar áreas com alta incidência de pragas',
          'Planejar próxima aplicação de defensivos',
          'Verificar níveis de umidade do solo',
        ],
      );
    } catch (e) {
      LoggerService.e(
        'Error generating weekly report',
        error: e,
        tag: 'REPORT',
      );
      return WeeklyReportData(
        activities: ['Erro ao carregar atividades'],
        occurrences: 0,
        applications: 0,
        teamCheckins: 0,
        weatherSummary: 'Dados climáticos indisponíveis',
        nextActions: [],
      );
    }
  }

  // --- NDVI Analysis Data ---

  Future<NdviAnalysisData> getNdviAnalysis({
    required List<GeoArea> areas,
  }) async {
    if (areas.isEmpty) {
      return NdviAnalysisData(
        temporalEvolution: [NdviDataPoint(DateTime.now(), 0.0)],
        areaComparisons: [],
        correlationWithWeather: 0.0,
      );
    }

    final now = DateTime.now();
    final mainArea = areas.first;

    // 1. Fetch Temporal Data
    List<NdviDataPoint> temporalData = [];

    try {
      // Use fetchStatistics which is available in SentinelService
      final stats = await _sentinelService.fetchStatistics(
        geoJsonGeometry: GeometryUtils.toGeoJsonGeometry(mainArea.points),
        startDate: now.subtract(const Duration(days: 90)),
        endDate: now,
      );

      // Parse stats into temporal data (simplified)
      if (stats['data'] != null) {
        final dataList = stats['data'] as List;
        temporalData = dataList.map((item) {
          final date =
              DateTime.tryParse(item['interval']?['from'] ?? '') ?? now;
          final value =
              (item['outputs']?['ndvi']?['bands']?['B0']?['stats']?['mean'] ??
                      0.0)
                  as double;
          return NdviDataPoint(date, value);
        }).toList();
      }

      if (temporalData.isEmpty) {
        temporalData = [NdviDataPoint(now, 0.0)];
      }
    } catch (e) {
      LoggerService.e('Error fetching Sentinel data', error: e, tag: 'REPORT');
      temporalData = [NdviDataPoint(now, 0.0)];
    }

    // 2. Build Comparisons
    List<AreaComparison> comparisons = [];
    for (var area in areas.take(5)) {
      comparisons.add(
        AreaComparison(
          areaName: area.name,
          currentNdvi: 0.6, // Placeholder
          growth: 2.5, // Placeholder percentage
        ),
      );
    }

    return NdviAnalysisData(
      temporalEvolution: temporalData,
      areaComparisons: comparisons,
      correlationWithWeather: 0.3, // Placeholder
    );
  }

  // --- Crop Summary Data ---

  Future<CropSummaryData> getCropSummary() async {
    try {
      final harvests = await _harvestRepository.getHarvests();
      final occurrences = await _occurrenceRepository.getOccurrences();

      if (harvests.isEmpty) {
        return CropSummaryData(
          plantedArea: 0,
          phenologicalStage: 'Sem dados',
          estimatedProductivity: 0,
          realProductivity: 0,
          costPerHectare: 0,
          problemsFaces: ['Nenhuma safra cadastrada'],
          lessonsLearned: [],
        );
      }

      // Aggregate data from harvests
      double totalArea = 0;
      double totalProduction = 0;
      double totalCost = 0;
      Set<String> allProblems = {};

      for (var harvest in harvests) {
        totalArea += harvest.plantedAreaHa;
        totalProduction += harvest.totalProductionBags;
        totalCost += harvest.totalCost;
      }

      // Find current phenological stage
      final activeHarvest = harvests.firstWhere(
        (h) => h.status != 'harvested',
        orElse: () => harvests.last,
      );

      // Map occurrences to problems
      final recentProblems = occurrences
          .where(
            (o) => o.date.isAfter(
              DateTime.now().subtract(const Duration(days: 90)),
            ),
          )
          .map((o) => o.title)
          .take(5);
      allProblems.addAll(recentProblems);

      return CropSummaryData(
        plantedArea: totalArea,
        phenologicalStage: _mapStatusToPhenology(activeHarvest.status),
        estimatedProductivity: totalArea > 0 ? totalProduction / totalArea : 0,
        realProductivity: totalArea > 0 ? totalProduction / totalArea : 0,
        costPerHectare: totalArea > 0 ? totalCost / totalArea : 0,
        problemsFaces: allProblems.take(5).toList(),
        lessonsLearned: activeHarvest.notes.take(5).toList(),
      );
    } catch (e) {
      LoggerService.e('Error generating crop summary', error: e, tag: 'REPORT');
      return CropSummaryData(
        plantedArea: 0,
        phenologicalStage: 'Erro',
        estimatedProductivity: 0,
        realProductivity: 0,
        costPerHectare: 0,
        problemsFaces: [],
        lessonsLearned: [],
      );
    }
  }

  String _mapStatusToPhenology(String status) {
    return switch (status) {
      'planned' => 'Planejamento',
      'active' => 'Em Andamento',
      'harvested' => 'Safra Finalizada',
      _ => status,
    };
  }

  // --- Pest Report Data ---

  Future<PestReportData> getPestReport() async {
    try {
      final occurrences = await _occurrenceRepository.getOccurrences();

      // Filter to pest/disease occurrences
      final pestOccurrences = occurrences
          .where((o) => o.type == 'pest' || o.type == 'disease')
          .toList();

      if (pestOccurrences.isEmpty) {
        return PestReportData(
          totalOccurrences: 0,
          averageSeverity: 'N/A',
          distributionByType: {},
          treatments: [],
          totalCost: 0,
        );
      }

      // Calculate distribution by type
      final Map<String, int> distribution = {};
      double severitySum = 0;

      for (var occ in pestOccurrences) {
        distribution[occ.type] = (distribution[occ.type] ?? 0) + 1;
        severitySum += occ.severity;
      }

      // Map average severity to label
      final avgSeverity = severitySum / pestOccurrences.length;
      String severityLabel;
      if (avgSeverity >= 0.7) {
        severityLabel = 'Alta';
      } else if (avgSeverity >= 0.4) {
        severityLabel = 'Média';
      } else {
        severityLabel = 'Baixa';
      }

      // Build treatments list (placeholder)
      List<TreatmentData> treatments = [
        TreatmentData(
          name: 'Aplicação preventiva de fungicida',
          date: DateTime.now().subtract(const Duration(days: 14)),
          efficacy: 0.85,
        ),
        TreatmentData(
          name: 'Controle biológico de pragas',
          date: DateTime.now().subtract(const Duration(days: 7)),
          efficacy: 0.70,
        ),
      ];

      return PestReportData(
        totalOccurrences: pestOccurrences.length,
        averageSeverity: severityLabel,
        distributionByType: distribution,
        treatments: treatments,
        totalCost: 2500.0, // Placeholder
      );
    } catch (e) {
      LoggerService.e('Error generating pest report', error: e, tag: 'REPORT');
      return PestReportData(
        totalOccurrences: 0,
        averageSeverity: 'Erro',
        distributionByType: {},
        treatments: [],
        totalCost: 0,
      );
    }
  }
}

// Provider
final reportDataServiceProvider = Provider<ReportDataService>((ref) {
  return ReportDataService(
    occurrenceRepository: ref.watch(occurrenceRepositoryProvider),
    harvestRepository: ref.watch(harvestRepositoryProvider),
    visitRepository: ref.watch(visitRepositoryProvider),
    sentinelService: ref.watch(sentinelServiceProvider),
  );
});
