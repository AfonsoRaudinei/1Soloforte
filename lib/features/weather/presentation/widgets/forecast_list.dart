import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import '../../domain/weather_model.dart';

class ForecastList extends StatelessWidget {
  final List<DailyForecast> forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // Scroll handled by parent
      shrinkWrap: true,
      itemCount: forecast.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final day = forecast[index];
        return _ForecastExpansionTile(day: day);
      },
    );
  }
}

class _ForecastExpansionTile extends StatelessWidget {
  final DailyForecast day;

  const _ForecastExpansionTile({required this.day});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getIconForCondition(day.condition),
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        DateFormat('EEEE, d MMM', 'pt_BR').format(day.date).toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(day.condition, style: const TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day.maxTemp.round()}°',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text('/', style: TextStyle(color: Colors.grey[400])),
          const SizedBox(width: 4),
          Text(
            '${day.minTemp.round()}°',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.expand_more, color: Colors.grey[400]),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DetailItem(
                icon: Icons.water_drop,
                label: 'Chuva',
                value: '${day.rainProbability}%',
              ),
              _DetailItem(
                icon: Icons.umbrella,
                label: 'Volume',
                value: '${day.precipitation}mm',
              ),
              _DetailItem(
                icon: Icons.air,
                label: 'Vento',
                value: '${day.windSpeed.round()} km/h',
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Icons.shower;
      case 'cloudy':
        return Icons.cloud;
      case 'sunny':
        return Icons.wb_sunny;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
