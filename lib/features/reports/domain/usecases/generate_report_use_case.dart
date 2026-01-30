import 'package:uuid/uuid.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:soloforte_app/features/visits/domain/repositories/visit_repository.dart';
import 'package:soloforte_app/features/occurrences/domain/repositories/occurrence_repository.dart';
import '../entities/technical_report.dart';
import '../repositories/technical_report_repository.dart';

class GenerateReportParams {
  final String visitId;
  final String technicalResponsible; // Could be current user name

  GenerateReportParams({
    required this.visitId,
    required this.technicalResponsible,
  });
}

class GenerateReportUseCase {
  final VisitRepository _visitRepository;
  final OccurrenceRepository _occurrenceRepository;
  final TechnicalReportRepository _reportRepository;
  final Uuid _uuid = const Uuid();

  GenerateReportUseCase(
    this._visitRepository,
    this._occurrenceRepository,
    this._reportRepository,
  );

  Future<TechnicalReport> call(GenerateReportParams params) async {
    try {
      LoggerService.i('Generating report for visit ${params.visitId}');

      // 1. Fetch Visit
      final visit = await _visitRepository.getVisitById(params.visitId);
      if (visit == null) {
        throw Exception('Visit not found: ${params.visitId}');
      }

      // 2. Fetch Occurrences
      final occurrences = await _occurrenceRepository.getOccurrencesByVisitId(
        params.visitId,
      );

      // 3. Transform to Consolidated Occurrences with AI/Mock recommendations directly here
      final consolidatedOccurrences = occurrences.map((occ) {
        final severity = occ.severity;
        String riskLevel;
        String recommendation = occ.technicalRecommendation;

        if (severity >= 0.7) {
          riskLevel = 'Alto';
          if (recommendation.isEmpty) {
            recommendation =
                'Recomenda-se intervenção química imediata. Monitorar diariamente.';
          }
        } else if (severity >= 0.4) {
          riskLevel = 'Médio';
          if (recommendation.isEmpty) {
            recommendation =
                'Monitorar a evolução a cada 3 dias. Considerar controle biológico.';
          }
        } else {
          riskLevel = 'Baixo';
          if (recommendation.isEmpty) {
            recommendation = 'Manter monitoramento padrão semanal.';
          }
        }

        return ConsolidatedOccurrence(
          originalId: occ.id,
          type: occ.type,
          title: occ.title,
          description: occ.description,
          date: occ.date,
          latitude: occ.latitude ?? 0.0,
          longitude: occ.longitude ?? 0.0,
          photos: occ.images,
          severity: severity,
          riskLevel: riskLevel,
          technicalRecommendation: recommendation,
        );
      }).toList();

      // 4. Create Technical Report
      final report = TechnicalReport(
        id: _uuid.v4(),
        visitId: visit.id,
        clientId: visit.client.id,
        clientName: visit.client.name,
        generatedAt: DateTime.now(),
        technicalResponsible: params.technicalResponsible,
        occurrences: consolidatedOccurrences,
        visitPhotos: visit.photos,
        visitNotes: visit.checkOutNotes ?? visit.checkInNotes,
        visitLatitude: visit.latitude,
        visitLongitude: visit.longitude,
      );

      // 5. Save Report
      await _reportRepository.saveReport(report);

      return report;
    } catch (e, s) {
      LoggerService.e('Failed to generate report', error: e, stackTrace: s);
      rethrow;
    }
  }
}
