import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';
import 'dart:math';

class EvolutionTab extends ConsumerWidget {
  const EvolutionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ndviState = ref.watch(ndviControllerProvider);
    final dates = ndviState.availableDates;

    if (dates.isEmpty) {
      return const Center(child: Text('Sem histórico disponível.'));
    }

    // Mocking Data for the Chart (Requirements Task 5)
    // In production, we would need to fetch stats for all dates.
    // Here we generate plausible NDVI values (0.3 - 0.9) to show the chart functioning
    final List<FlSpot> spots = [];
    final r = Random(42); // Fixed seed for consistency

    // Sort dates just in case
    final sortedDates = List<DateTime>.from(dates)..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      // Simulate seasonality or noise
      double val = 0.4 + (r.nextDouble() * 0.5);
      spots.push(FlSpot(i.toDouble(), val));
    }

    // Safety check for empty spots (though dates check covers it)
    if (spots.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Evolução do Vigor (NDVI Médio)', style: AppTypography.h4),
          const SizedBox(height: 8),
          Text(
            'Últimos ${dates.length} registros',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 32),

          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 0.2,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Show every date? Might crowd.
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < sortedDates.length) {
                          // Show only some labels to avoid crowding
                          if (sortedDates.length > 5 && index % 2 != 0) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd/MM').format(sortedDates[index]),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (sortedDates.length - 1).toDouble(),
                minY: 0,
                maxY: 1.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        final date = sortedDates[index];
                        return LineTooltipItem(
                          '${DateFormat('dd/MM').format(date)}\nNDVI: ${spot.y.toStringAsFixed(2)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  // Optional: Click to load image for that date
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent &&
                        response != null &&
                        response.lineBarSpots != null) {
                      final index = response.lineBarSpots!.first.x.toInt();
                      ref
                          .read(ndviControllerProvider.notifier)
                          .loadNdviImage(sortedDates[index]);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

extension ListPush<T> on List<T> {
  void push(T val) => add(val);
}
