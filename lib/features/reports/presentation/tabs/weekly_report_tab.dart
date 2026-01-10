import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/features/reports/application/date_filter_provider.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/features/reports/presentation/widgets/date_filter_dropdown.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';

class WeeklyReportTab extends ConsumerStatefulWidget {
  const WeeklyReportTab({super.key});

  @override
  ConsumerState<WeeklyReportTab> createState() => _WeeklyReportTabState();
}

class _WeeklyReportTabState extends ConsumerState<WeeklyReportTab> {
  late Future<WeeklyReportData> _reportFuture;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  void _loadReport() {
    final dateRange = ref.read(dateFilterProvider).dateRange;
    _reportFuture = ref
        .read(reportServiceProvider)
        .getWeeklyReport(startDate: dateRange.start, endDate: dateRange.end);
  }

  void _refreshReport() {
    setState(() {
      _loadReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date Filter Header
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[50],
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Período:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              DateFilterDropdown(onFilterChanged: _refreshReport),
              const Spacer(),
              const DateFilterChip(),
            ],
          ),
        ),

        // Report Content
        Expanded(
          child: FutureBuilder<WeeklyReportData>(
            future: _reportFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: EmptyStateWidget(
                    title: 'Falha ao carregar relatório',
                    message:
                        'Não foi possível gerar o relatório semanal.\n${snapshot.error}',
                    icon: Icons.error_outline,
                    actionLabel: 'Tentar Novamente',
                    onAction: _refreshReport,
                  ),
                );
              }

              final data = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(data),
                    const SizedBox(height: 24),
                    _buildSummaryStats(data),
                    const SizedBox(height: 24),
                    _buildActivitiesList(data),
                    const SizedBox(height: 24),
                    _buildNextActions(data),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(WeeklyReportData data) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Clima da Semana', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text(
                      data.weatherSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(WeeklyReportData data) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Ocorrências',
            value: data.occurrences.toString(),
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Aplicações',
            value: data.applications.toString(),
            icon: Icons.water_drop,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Check-ins',
            value: data.teamCheckins.toString(),
            icon: Icons.group,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesList(WeeklyReportData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Atividades Realizadas', style: AppTypography.h3),
        const SizedBox(height: 12),
        AppCard(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.activities.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.check, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  data.activities[index],
                  style: AppTypography.bodySmall,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNextActions(WeeklyReportData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Próximas Ações', style: AppTypography.h3),
        const SizedBox(height: 12),
        AppCard(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.nextActions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.arrow_forward, color: Colors.grey),
                title: Text(
                  data.nextActions[index],
                  style: AppTypography.bodySmall,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
