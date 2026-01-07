import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/crop_summary_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/custom_report_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/ndvi_analysis_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/pest_report_tab.dart';
import 'package:soloforte_app/features/reports/presentation/tabs/weekly_report_tab.dart';

import 'package:soloforte_app/features/reports/application/report_history_provider.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:intl/intl.dart';

import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_list_view.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportCurrentReport() async {
    // ... (existing export logic)
  }

  @override
  Widget build(BuildContext context) {
    // Watch history for the badges or counts if we wanted
    final history = ref.watch(reportHistoryProvider).reports;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
            onPressed: _isExporting ? null : _exportCurrentReport,
            tooltip: 'Exportar PDF',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            const Tab(text: 'Histórico'),
            const Tab(text: 'Ocorrências'),
            const Tab(text: 'Semanal'),
            const Tab(text: 'NDVI'),
            const Tab(text: 'Safra'),
            const Tab(text: 'Pragas'),
            const Tab(text: 'Personalizado'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Histórico Tab (Inline List to use provider)
          ListView.separated(
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
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: const Icon(Icons.description, color: Colors.blue),
                  ),
                  title: Text(
                    report.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt)}\nTipo: ${report.template.name}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Open Detail or PDF
                  },
                ),
              );
            },
          ),
          const OccurrenceListView(),
          const WeeklyReportTab(),
          const NdviAnalysisTab(),
          const CropSummaryTab(),
          const PestReportTab(),
          const CustomReportTab(),
        ],
      ),
    );
  }
}
