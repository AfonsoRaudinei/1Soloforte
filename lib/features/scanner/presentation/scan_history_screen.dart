import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

// Mock Provider for History
final scanHistoryProvider = FutureProvider<List<ScanResult>>((ref) async {
  // Simulate DB fetch
  await Future.delayed(const Duration(milliseconds: 800));
  return [
    ScanResult(
      id: '1',
      imagePath: 'assets/images/mock_pest_1.jpg', // Placeholder
      scientificName: 'Spodoptera frugiperda',
      commonName: 'Lagarta-do-cartucho',
      confidence: 0.98,
      severity: 0.7,
      description:
          'Infestação severa identificada nas folhas novas. Requer atenção imediata.',
      symptoms: ['Folhas roídas', 'Excrementos visíveis', 'Lagartas ativas'],
      scanDate: DateTime.now().subtract(const Duration(hours: 2)),
      type: ScanType.pest,
      detections: [],
      recommendation: '',
    ),
    ScanResult(
      id: '2',
      imagePath: 'assets/images/mock_pest_2.jpg',
      scientificName: 'Phakopsora pachyrhizi',
      commonName: 'Ferrugem Asiática',
      confidence: 0.92,
      severity: 0.4,
      description: 'Pústulas iniciais observadas no terço inferior da planta.',
      symptoms: [
        'Manchas marrons',
        'Pústulas na face inferior',
        'Amarelecimento',
      ],
      scanDate: DateTime.now().subtract(const Duration(days: 1)),
      type: ScanType.disease,
      detections: [],
      recommendation: '',
    ),
    ScanResult(
      id: '3',
      imagePath: 'assets/images/mock_pest_3.jpg',
      scientificName: 'Dichelops melacanthus',
      commonName: 'Percevejo barriga-verde',
      confidence: 0.85,
      severity: 0.2,
      description: 'Presença isolada de adultos. Nível de dano ainda baixo.',
      symptoms: ['Picadas nas vagens', 'Grãos chochos'],
      scanDate: DateTime.now().subtract(const Duration(days: 3)),
      type: ScanType.pest,
      detections: [],
      recommendation: '',
    ),
  ];
});

class ScanHistoryScreen extends ConsumerWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(scanHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Histórico de Análises'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: historyAsync.when(
        data: (history) => ListView.separated(
          padding: EdgeInsets.all(AppSpacing.md),
          itemCount: history.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final scan = history[index];
            return _HistoryCard(scan: scan);
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) =>
            Center(child: Text('Erro ao carregar histórico: $err')),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ScanResult scan;

  const _HistoryCard({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to details (reusing Result Screen)
          // In a real app check if file exists, else show placeholder
          context.push(
            '/dashboard/scanner/results',
            extra: {'imagePath': scan.imagePath, 'result': scan},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  // In real app use FileImage or CachedNetworkImage
                ),
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.commonName,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scan.scientificName,
                      style: AppTypography.caption.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy • HH:mm',
                          ).format(scan.scanDate),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Badge
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(
                        scan.confidence,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getConfidenceColor(scan.confidence),
                      ),
                    ),
                    child: Text(
                      '${(scan.confidence * 100).toInt()}%',
                      style: TextStyle(
                        color: _getConfidenceColor(scan.confidence),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.9) return AppColors.success;
    if (confidence > 0.7) return AppColors.warning;
    return AppColors.error;
  }
}
