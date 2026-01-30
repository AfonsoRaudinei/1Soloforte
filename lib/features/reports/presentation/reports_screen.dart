import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/crop_summary_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/custom_report_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/marketing_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/ndvi_analysis_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/pest_report_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/weekly_report_tab.dart';

import 'package:soloforte_app/features/reports/application/report_export_service.dart';
import 'package:soloforte_app/features/reports/application/report_history_provider.dart';
import 'package:soloforte_app/features/reports/application/date_filter_provider.dart';
import 'package:soloforte_app/features/reports/application/custom_report_layout_provider.dart'
    as report_layout;
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:intl/intl.dart';

import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_list_view.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportCurrentReport() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final exporter = ref.read(reportExportServiceProvider);
      final currentIndex = _tabController.index;

      switch (currentIndex) {
        case 3: // Semanal
          final range = ref.read(dateFilterProvider).dateRange;
          await exporter.exportByTemplate(
            template: ReportTemplate.weekly,
            weeklyRange: DateTimeRange(start: range.start, end: range.end),
          );
          break;
        case 4: // NDVI
          final drawingState = ref.read(drawingControllerProvider);
          await exporter.exportByTemplate(
            template: ReportTemplate.ndvi,
            areas: drawingState.savedAreas,
          );
          break;
        case 5: // Safra
          await exporter.exportByTemplate(template: ReportTemplate.cropSummary);
          break;
        case 6: // Pragas
          await exporter.exportByTemplate(template: ReportTemplate.pest);
          break;
        case 7: // Personalizado
          final prefs = ref.read(report_layout.sharedPreferencesProvider).value;
          if (prefs == null) {
            throw Exception('Preferências ainda não carregadas.');
          }
          final sections = ref
              .read(report_layout.customReportLayoutProvider)
              .sections;
          await exporter.exportByTemplate(
            template: ReportTemplate.custom,
            sections: sections,
          );
          break;
        default:
          throw Exception('Exportação indisponível para esta aba.');
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
    // Watch history for the badges or counts if we wanted
    final history = ref.watch(reportHistoryProvider).reports;

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                const Tab(text: 'Histórico'),
                const Tab(text: 'Ocorrências'),
                const Tab(text: 'Marketing'),
                const Tab(text: 'Semanal'),
                const Tab(text: 'NDVI'),
                const Tab(text: 'Safra'),
                const Tab(text: 'Pragas'),
                const Tab(text: 'Personalizado'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Histórico Tab (Inline List to use provider)
                history.isEmpty
                    ? const EmptyStateWidget(
                        title: 'Nenhum relatório no histórico',
                        message:
                            'Relatórios gerados ou visualizados aparecerão aqui.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: history.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final report = history[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: const Icon(
                                  Icons.description,
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                report.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt)}\nTipo: ${report.template.name}',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                // Open Detail or PDF
                              },
                            ),
                          );
                        },
                      ),
                const OccurrenceListView(),
                const MarketingTab(),
                const WeeklyReportTab(),
                const NdviAnalysisTab(),
                const CropSummaryTab(),
                const PestReportTab(),
                const CustomReportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
