import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/weather/domain/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherNext7dScreen extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherNext7dScreen({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Previsão Semanal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            ...forecast.daily.map((day) => _buildDayCard(day)),

            const SizedBox(height: 16),
            const Text(
              '[Ver detalhes completos...]',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 32),

            // Tip Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                border: Border.all(color: Colors.yellow.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dica Agronômica:',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"Evite aplicações nos próximos 2 dias devido a previsão de chuvas acima de 20mm"',
                    style: AppTypography.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(DailyForecast day) {
    //  │  ┌───────────────────────────┐  │
    //  │  │ SEG 30/Out                │  │
    //  │  │ ☀️  28° / 18°     0mm     │  │
    //  │  │ Ensolarado                │  │
    //  │  └───────────────────────────┘  │
    final dateStr = DateFormat(
      'EEE dd/MMM',
      'pt_BR',
    ).format(day.date).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Text(
              dateStr,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIconForCondition(day.condition),
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${day.maxTemp.round()}° / ${day.minTemp.round()}°',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${day.precipitation}mm',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  day.condition,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCondition(String condition) {
    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('chuva'))
      return Icons.water_drop;
    if (condition.toLowerCase().contains('cloud') ||
        condition.toLowerCase().contains('nuve') ||
        condition.toLowerCase().contains('nublado'))
      return Icons.cloud;
    return Icons.wb_sunny;
  }
}
