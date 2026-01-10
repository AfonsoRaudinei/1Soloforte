import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/visits/domain/visit_constants.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/active_visit/visit_section.dart';

class PhenologyCard extends StatelessWidget {
  final String? selectedStageKey;
  final ValueChanged<String?> onStageChanged;

  const PhenologyCard({
    super.key,
    required this.selectedStageKey,
    required this.onStageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final stage = selectedStageKey != null
        ? visitStages[selectedStageKey]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VisitSectionHeader(title: 'Estádio Fenológico'),
        VisitSectionCard(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedStageKey,
                hint: const Text('Selecione o estádio'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: visitStages.keys.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(visitStages[key]['name']),
                  );
                }).toList(),
                onChanged: onStageChanged,
              ),
              if (stage != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(stage['icon'], style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text(
                        stage['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        stage['description'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stage['dap'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (stage['attention'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PONTOS DE ATENÇÃO',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...(stage['attention'] as List).map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
