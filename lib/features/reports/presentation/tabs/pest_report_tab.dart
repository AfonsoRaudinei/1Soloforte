import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';

class PestReportTab extends ConsumerWidget {
  const PestReportTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PestReportData>(
      future: ref.read(reportServiceProvider).getPestReport(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar dados: ${snapshot.error}'),
          );
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSeverityCard(data),
              const SizedBox(height: 24),
              _buildDistributionChart(data),
              const SizedBox(height: 24),
              _buildTreatmentsList(data),
              const SizedBox(height: 24),
              _buildCostCard(data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeverityCard(PestReportData data) {
    Color color;
    IconData icon;
    switch (data.averageSeverity) {
      case 'Alta':
        color = Colors.red;
        icon = Icons.error_outline;
        break;
      case 'Moderada':
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;
      default:
        color = Colors.green;
        icon = Icons.check_circle_outline;
    }

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            radius: 24,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Severidade Média', style: AppTypography.caption),
              Text(
                data.averageSeverity,
                style: AppTypography.h2.copyWith(color: color),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Ocorrências', style: AppTypography.caption),
              Text(data.totalOccurrences.toString(), style: AppTypography.h3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart(PestReportData data) {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];
    int colorIndex = 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distribuição por Tipo', style: AppTypography.h3),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: data.distributionByType.entries.map((entry) {
                        final color = colors[colorIndex++ % colors.length];
                        return PieChartSectionData(
                          color: color,
                          value: entry.value.toDouble(),
                          title: '${entry.value}',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.distributionByType.entries.map((entry) {
                      final index = data.distributionByType.keys
                          .toList()
                          .indexOf(entry.key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: colors[index % colors.length],
                            ),
                            const SizedBox(width: 8),
                            Text(entry.key, style: AppTypography.bodySmall),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsList(PestReportData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tratamentos Realizados', style: AppTypography.h3),
        const SizedBox(height: 12),
        AppCard(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.treatments.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final treatment = data.treatments[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                ),
                title: Text(
                  treatment.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Eficácia: ${(treatment.efficacy * 100).toInt()}%',
                ),
                trailing: Text(
                  '${treatment.date.day}/${treatment.date.month}',
                  style: AppTypography.caption,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCostCard(PestReportData data) {
    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.attach_money, color: Colors.white),
        ),
        title: const Text(
          'Custo Total de Controle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          'R\$ ${data.totalCost.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
