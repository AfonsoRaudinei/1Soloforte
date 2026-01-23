import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import '../domain/ndvi_record.dart';
import 'ndvi_detail_screen.dart';

class NDVIHistoryScreen extends StatefulWidget {
  const NDVIHistoryScreen({super.key});

  @override
  State<NDVIHistoryScreen> createState() => _NDVIHistoryScreenState();
}

class _NDVIHistoryScreenState extends State<NDVIHistoryScreen> {
  // Mock Data
  final List<NDVIRecord> _records = [
    NDVIRecord(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'placeholder_1.png',
      description: 'Talhão 1 - Safra 23/24',
      averageValue: 0.75,
    ),
    NDVIRecord(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 15)),
      imageUrl: 'placeholder_2.png',
      description: 'Talhão 1 - Safra 23/24',
      averageValue: 0.68,
    ),
    NDVIRecord(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 30)),
      imageUrl: 'placeholder_3.png',
      description: 'Talhão 1 - Safra 23/24',
      averageValue: 0.45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      itemCount: _records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final record = _records[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NDVIDetailScreen(
                    area: GeoArea(
                      id: record.id,
                      name: record.description,
                      points: const [],
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.satellite_alt,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(record.date),
                          style: AppTypography.h3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(record.date),
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'NDVI: ${record.averageValue.toStringAsFixed(2)}',
                        style: AppTypography.h4.copyWith(
                          color: _getColorForValue(record.averageValue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForValue(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.6) return Colors.orange;
    return Colors.green;
  }
}
