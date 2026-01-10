import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/features/reports/presentation/widgets/cost_distribution_chart.dart';
import 'package:soloforte_app/features/reports/presentation/widgets/productivity_bar_chart.dart';
import 'package:soloforte_app/features/reports/presentation/widgets/summary_card.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';

class CropSummaryTab extends ConsumerWidget {
  const CropSummaryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<CropSummaryData>(
      future: ref.read(reportServiceProvider).getCropSummary(),
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
              _buildOverviewCards(data),
              const SizedBox(height: 24),
              _buildPhenologyCard(data),
              const SizedBox(height: 24),
              Text('Produtividade Estimada', style: AppTypography.h3),
              const SizedBox(height: 12),
              const ProductivityBarChart(), // Reusing existing widget
              const SizedBox(height: 24),
              Text('Distribuição de Custos', style: AppTypography.h3),
              const SizedBox(height: 12),
              const CostDistributionChart(), // Reusing existing widget
              const SizedBox(height: 24),
              _buildLessonsLearned(data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewCards(CropSummaryData data) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Área Plantada',
            value: '${data.plantedArea.toStringAsFixed(0)} ha',
            trend: '100%',
            isPositive: true,
            icon: Icons.landscape,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: 'Custo Total',
            value: 'R\$ ${data.costPerHectare.toStringAsFixed(0)}/ha',
            trend: '+5%',
            isPositive: false,
            icon: Icons.attach_money,
          ),
        ),
      ],
    );
  }

  Widget _buildPhenologyCard(CropSummaryData data) {
    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.grass, color: Colors.white),
        ),
        title: const Text(
          'Estágio Fenológico Atual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(data.phenologicalStage),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green),
          ),
          child: const Text(
            'Em Andamento',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsLearned(CropSummaryData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lições Aprendidas', style: AppTypography.h3),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.lessonsLearned.map((lesson) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(lesson, style: AppTypography.bodySmall),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
