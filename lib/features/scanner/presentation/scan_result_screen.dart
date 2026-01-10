import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';
import 'package:soloforte_app/features/scanner/presentation/widgets/interactive_result_image.dart';
import 'package:soloforte_app/features/scanner/presentation/widgets/recommendation_tabs.dart';
import 'package:soloforte_app/features/scanner/presentation/widgets/result_summary_card.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class ScanResultsScreen extends StatelessWidget {
  final String imagePath;
  final ScanResult result;

  const ScanResultsScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Análise Concluída",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 1. Interactive Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InteractiveResultImage(
                imagePath: imagePath,
                detections: result.detections,
              ),
            ),

            const SizedBox(height: 16),

            // 2. Summary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ResultSummaryCard(result: result),
            ),

            const SizedBox(height: 16),

            // 3. Weather Widget
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: WeatherValidationWidget(),
            ),

            const SizedBox(height: 24),

            // 4. Recommendations Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.medication_liquid,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Recomendações de Controle",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 5. Recommendations Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RecommendationTabs(result: result),
            ),

            // 6. Action Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: "CONVERTER EM OCORRÊNCIA",
                onPressed: () {
                  context.push(
                    '/occurrences/new',
                    extra: {
                      'title': result.commonName,
                      'description': result.description,
                      'type': result.type.name,
                      'imagePath': imagePath,
                      'severity': result.severity,
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class WeatherValidationWidget extends StatelessWidget {
  const WeatherValidationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cloud_done, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Condições Ideais para Aplicação",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Vento: 5km/h • Umidade: 65% • Sem chuva prevista",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}
