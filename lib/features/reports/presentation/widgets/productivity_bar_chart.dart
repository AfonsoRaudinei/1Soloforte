import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';

class ProductivityBarChart extends StatefulWidget {
  final List<ProductivityData>? data;
  final Function(ProductivityData)? onBarTap;

  const ProductivityBarChart({super.key, this.data, this.onBarTap});

  @override
  State<ProductivityBarChart> createState() => _ProductivityBarChartState();
}

class _ProductivityBarChartState extends State<ProductivityBarChart> {
  int _touchedIndex = -1;

  // Default mock data if none provided
  List<ProductivityData> get _chartData =>
      widget.data ??
      [
        ProductivityData(
          label: 'T1',
          value: 60,
          details:
              'Talhão 1: 60 sacas/ha\n120 ha plantados\nTotal: 7,200 sacas',
        ),
        ProductivityData(
          label: 'T2',
          value: 80,
          details:
              'Talhão 2: 80 sacas/ha\n135 ha plantados\nTotal: 10,800 sacas',
        ),
        ProductivityData(
          label: 'T3',
          value: 50,
          details:
              'Talhão 3: 50 sacas/ha\n150 ha plantados\nTotal: 7,500 sacas',
        ),
        ProductivityData(
          label: 'T4',
          value: 90,
          details:
              'Talhão 4: 90 sacas/ha\n105 ha plantados\nTotal: 9,450 sacas',
        ),
        ProductivityData(
          label: 'T5',
          value: 70,
          details:
              'Talhão 5: 70 sacas/ha\n120 ha plantados\nTotal: 8,400 sacas',
        ),
      ];

  void _showDetailSheet(ProductivityData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bar_chart,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalhes - ${data.label}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${data.value.toStringAsFixed(1)} sacas/ha',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
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
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to detailed view
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navegando para detalhes de ${data.label}'),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Ver Análise Completa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Produtividade por Talhão',
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
                        'Toque para detalhes',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });

                      // Handle tap
                      if (event is FlTapUpEvent && _touchedIndex >= 0) {
                        final data = _chartData[_touchedIndex];
                        _showDetailSheet(data);
                        widget.onBarTap?.call(data);
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} sacas/ha\nToque para detalhes',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= _chartData.length) {
                            return const SizedBox();
                          }

                          final style = TextStyle(
                            color: _touchedIndex == value.toInt()
                                ? AppColors.primary
                                : Colors.black,
                            fontWeight: _touchedIndex == value.toInt()
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          );

                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              _chartData[value.toInt()].label,
                              style: style,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(_chartData.length, (index) {
                    final isTouched = index == _touchedIndex;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: _chartData[index].value,
                          color: isTouched
                              ? AppColors.primary.withValues(alpha: 0.8)
                              : AppColors.primary,
                          width: isTouched ? 24 : 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductivityData {
  final String label;
  final double value;
  final String details;

  ProductivityData({
    required this.label,
    required this.value,
    required this.details,
  });
}
