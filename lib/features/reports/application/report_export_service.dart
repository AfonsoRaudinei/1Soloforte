import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';

class ReportExportService {
  final ReportService _reportService;

  ReportExportService(this._reportService);

  Future<void> exportByTemplate({
    required ReportTemplate template,
    DateTimeRange? weeklyRange,
    List<GeoArea>? areas,
    List<ReportSection>? sections,
  }) async {
    switch (template) {
      case ReportTemplate.weekly:
        final range = weeklyRange;
        final data = await _reportService.getWeeklyReport(
          startDate: range?.start,
          endDate: range?.end,
        );
        await _reportService.generateAndShareWeeklyReport(data);
        return;
      case ReportTemplate.ndvi:
        final targetAreas = areas ?? const [];
        if (targetAreas.isEmpty) {
          throw Exception('Nenhuma área disponível para exportação NDVI.');
        }
        final data = await _reportService.getNdviAnalysis(areas: targetAreas);
        await _reportService.generateAndShareNDVIReport(
          area: targetAreas.first,
          date: DateTime.now(),
          ndviImageBytes: data.attentionZoneImageBytes,
          stats: null,
        );
        return;
      case ReportTemplate.cropSummary:
        final data = await _reportService.getCropSummary();
        await _reportService.generateAndShareCropSummary(data);
        return;
      case ReportTemplate.pest:
        final data = await _reportService.getPestReport();
        await _reportService.generateAndSharePestReport(data);
        return;
      case ReportTemplate.custom:
        final visibleSections = sections
            ?.where((section) => section.isVisible)
            .toList();
        if (visibleSections == null || visibleSections.isEmpty) {
          throw Exception('Nenhuma seção selecionada para exportação.');
        }
        final weeklyData = await _reportService.getWeeklyReport();
        final cropData = await _reportService.getCropSummary();
        final pestData = await _reportService.getPestReport();
        await _reportService.generateAndShareCustomReport(
          sections: visibleSections,
          weeklyData: weeklyData,
          cropData: cropData,
          pestData: pestData,
        );
        return;
    }
  }
}

final reportExportServiceProvider = Provider<ReportExportService>((ref) {
  return ReportExportService(ref.watch(reportServiceProvider));
});
