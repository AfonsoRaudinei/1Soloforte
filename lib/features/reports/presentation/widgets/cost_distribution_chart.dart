import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';
import 'package:soloforte_app/features/reports/application/telemetry_logger.dart';
import 'chart_legend_item.dart';

class CostDistributionChart extends StatefulWidget {
  final List<CostCategoryData>? data;
  final Function(CostCategoryData)? onSectionTap;
  final VoidCallback? onExport;

  const CostDistributionChart({
    super.key,
    this.data,
    this.onSectionTap,
    this.onExport,
  });

  @override
  State<CostDistributionChart> createState() => _CostDistributionChartState();
}

class _CostDistributionChartState extends State<CostDistributionChart> {
  int touchedIndex = -1;

  void _showDetailSheet(CostCategoryData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.pie_chart, color: data.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${data.percentage}% do total',
                        style: TextStyle(
                          fontSize: 16,
                          color: data.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              data.details,
              style: const TextStyle(fontSize: 15, height: 1.8),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.onExport != null) {
                        widget.onExport!.call();
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Exportação indisponível no momento.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Navegando para detalhes de ${data.label}',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Ver Mais'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: data.color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartData = widget.data ?? const <CostCategoryData>[];
    if (chartData.isEmpty) {
      TelemetryLogger.logOnce(
        'chart_empty_due_to_no_data',
        context: {'chart': 'cost_distribution'},
      );
      return const AppCard(
        child: EmptyStateWidget(
          title: 'Sem dados',
          message: 'Nao ha dados de custos para exibir.',
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Distribuição de Custos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, size: 14, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Toque no grafico para detalhes',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                          });

                          // Handle tap
                          if (event is FlTapUpEvent && touchedIndex >= 0) {
                            final data = chartData[touchedIndex];
                            _showDetailSheet(data);
                            widget.onSectionTap?.call(data);
                          }
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: chartData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ChartLegendItem(
                          color: data.color,
                          label: '${data.label} (${data.percentage}%)',
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

  List<PieChartSectionData> showingSections() {
    final chartData = widget.data ?? const <CostCategoryData>[];
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 65.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final data = chartData[i];

      return PieChartSectionData(
        color: data.color,
        value: data.percentage.toDouble(),
        title: '${data.percentage}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

class CostCategoryData {
  final String label;
  final int percentage;
  final Color color;
  final String details;

  CostCategoryData({
    required this.label,
    required this.percentage,
    required this.color,
    required this.details,
  });
}
