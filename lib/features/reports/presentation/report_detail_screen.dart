import 'package:flutter/material.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/reports/application/report_export_service.dart';
import 'package:soloforte_app/features/reports/application/date_filter_provider.dart';
import 'package:soloforte_app/features/reports/application/report_history_provider.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/features/reports/domain/report_history.dart';
import 'package:soloforte_app/features/reports/data/report_repository.dart';

class ReportDetailScreen extends ConsumerStatefulWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  bool _loggedInHistory = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    ref.listen<AsyncValue<ReportSummary?>>(
      reportByIdProvider(widget.reportId),
      (previous, next) {
        next.whenOrNull(
          data: (report) async {
            if (report == null || _loggedInHistory) return;
            final template = _mapReportTemplate(report.type);
            if (template == null) return;

            final savedReport = SavedReport(
              id: report.id,
              title: report.title,
              template: template,
              createdAt: report.createdAt,
              configuration: ReportConfiguration(
                template: template,
                customTitle: report.title,
              ),
            );

            await ref.read(reportHistoryProvider).addReport(savedReport);
            await ref.read(reportHistoryProvider).updateViewCount(report.id);
            _loggedInHistory = true;
          },
        );
      },
    );
  }

  ReportTemplate? _mapReportTemplate(String type) {
    switch (type) {
      case 'Semanal':
        return ReportTemplate.weekly;
      case 'NDVI':
        return ReportTemplate.ndvi;
      case 'Safra':
        return ReportTemplate.cropSummary;
      default:
        return null;
    }
  }

  Future<void> _exportReport(ReportSummary report) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final template = _mapReportTemplate(report.type);
      if (template == null) {
        throw Exception('Tipo de relatório não suportado.');
      }
      final exporter = ref.read(reportExportServiceProvider);
      switch (template) {
        case ReportTemplate.weekly:
          final range = ref.read(dateFilterProvider).dateRange;
          await exporter.exportByTemplate(
            template: template,
            weeklyRange: DateTimeRange(start: range.start, end: range.end),
          );
          break;
        case ReportTemplate.ndvi:
          final drawingState = ref.read(drawingControllerProvider);
          await exporter.exportByTemplate(
            template: template,
            areas: drawingState.savedAreas,
          );
          break;
        case ReportTemplate.cropSummary:
          await exporter.exportByTemplate(template: template);
          break;
        case ReportTemplate.pest:
        case ReportTemplate.custom:
          throw Exception('Exportação indisponível para este relatório.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Falha ao exportar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportByIdProvider(widget.reportId));

    return reportAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
          leading: const BackButton(),
          centerTitle: true,
        ),
        body: Center(child: Text('Erro: $err')),
      ),
      data: (report) {
        if (report == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Não Encontrado'),
              leading: const BackButton(),
              centerTitle: true,
            ),
            body: const Center(child: Text('Relatório não encontrado')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhe do Relatório'),
            leading: const BackButton(),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 24,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.description,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        report.title,
                        style: AppTypography.h4,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        report.period,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resumo Executivo
                _SectionCard(
                  title: "RESUMO EXECUTIVO",
                  icon: Icons.bar_chart,
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Áreas Monitoradas',
                        value: '${report.areaCount}',
                      ),
                      _SummaryRow(
                        label: 'Ocorrências',
                        value: '${report.occurrenceCount}',
                      ),
                      _SummaryRow(label: 'Aplicações', value: '5'), // Mock
                      _SummaryRow(
                        label: 'NDVI Médio',
                        value: '0.68 (+0.05)',
                      ), // Mock
                    ],
                  ),
                ),

                // Áreas
                _SectionCard(
                  title: "ÁREAS MONITORADAS",
                  icon: Icons.grass,
                  child: Column(
                    children: [
                      _AreaRow(
                        name: 'Talhão Norte',
                        size: '45.3 ha',
                        ndvi: '0.72 (Bom)',
                        issues: 3,
                      ),
                      const Divider(),
                      _AreaRow(
                        name: 'Lavoura Sul',
                        size: '32.1 ha',
                        ndvi: '0.65 (Regular)',
                        issues: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _exportReport(report),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('VER RELATÓRIO COMPLETO (PDF)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                              label: const Text('Compartilhar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.print),
                              label: const Text('Imprimir'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('• $label', style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _AreaRow extends StatelessWidget {
  final String name;
  final String size;
  final String ndvi;
  final int issues;

  const _AreaRow({
    required this.name,
    required this.size,
    required this.ndvi,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$name - $size',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'NDVI: $ndvi',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          Text(
            'Ocorrências: $issues',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
