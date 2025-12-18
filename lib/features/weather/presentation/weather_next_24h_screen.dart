import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/weather/domain/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherNext24hScreen extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherNext24hScreen({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Previsão Horária'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '← Scroll horizontal →',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Hourly List Scroll
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: forecast.hourly.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = forecast.hourly[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(item.time),
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      // Icon based on condition (mock logic or real if available)
                      Icon(
                        _getIconForCondition(item.condition),
                        color: Colors.orange, // Dynamic color normally
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.temp.round()}°',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.precipitation}mm',
                        style: AppTypography.caption,
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 32),

            // Temperature Chart Box
            _buildChartBox(
              title: '📊 GRÁFICO TEMPERATURA',
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    'Chart Placeholder: ${forecast.hourly.map((e) => e.temp).join(", ")}',
                  ),
                ), // Charts need a library or custom painter. Using placeholder for now to match structure.
              ),
            ),
            const SizedBox(height: 16),

            // Precipitation Chart Box
            _buildChartBox(
              title: '🌧️ GRÁFICO PRECIPITAÇÃO',
              child: SizedBox(
                height: 150,
                child: Center(child: Text('Precipitation Chart Placeholder')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCondition(String condition) {
    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('chuva'))
      return Icons.water_drop;
    if (condition.toLowerCase().contains('cloud') ||
        condition.toLowerCase().contains('nuve'))
      return Icons.cloud;
    return Icons.wb_sunny;
  }

  Widget _buildChartBox({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Text(
              title,
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16.0), child: child),
        ],
      ),
    );
  }
}
