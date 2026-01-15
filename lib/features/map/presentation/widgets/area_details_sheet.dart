import 'package:flutter/material.dart';
import '../../domain/geo_area.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:flutter/services.dart';
import 'package:soloforte_app/core/presentation/widgets/premium_dialog.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreaDetailsSheet extends ConsumerWidget {
  final GeoArea area;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onAnalyze;
  final Function(GeoArea) onStartVisit;

  const AreaDetailsSheet({
    super.key,
    required this.area,
    required this.onDelete,
    required this.onEdit,
    required this.onAnalyze,
    required this.onStartVisit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumGlassContainer(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      padding: const EdgeInsets.all(16),
      borderRadius: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(area.name, style: AppTypography.h3),
                  if (area.clientName != null)
                    Text(area.clientName!, style: AppTypography.bodySmall),
                  if (area.activeVisitId != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'Visita em andamento',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (area.lastVisitDate != null)
                    Text(
                      'Última visita: ${DateFormat('dd/MM HH:mm').format(area.lastVisitDate!)}',
                      style: AppTypography.caption,
                    )
                  else
                    Text(
                      'Criado em ${DateFormat('dd/MM/yyyy HH:mm').format(area.createdAt ?? DateTime.now())}',
                      style: AppTypography.caption,
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  label: 'Área',
                  value: '${area.areaHectares.toStringAsFixed(2)} ha',
                  icon: Icons.landscape,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  label: 'Perímetro',
                  value: '${area.perimeterKm.toStringAsFixed(2)} km',
                  icon: Icons.linear_scale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: area.activeVisitId != null
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          // Confirm delete
                          PremiumDialog.show(
                            context: context,
                            builder: (context) => PremiumDialog(
                              title: 'Excluir Área?',
                              content: const Text(
                                'Esta ação não pode ser desfeita e removerá todos os dados associados.',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.textSecondary,
                                  ),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.pop(context); // Close dialog
                                    onDelete();
                                    Navigator.pop(context); // Close sheet
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );
                        },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  label: const Text(
                    'Excluir',
                    style: TextStyle(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: area.activeVisitId != null
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          onEdit();
                        },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              onAnalyze();
            },
            icon: const Icon(Icons.satellite_alt),
            label: const Text('Análise NDVI & Satélite'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              onStartVisit(area);
            },
            icon: Icon(
              area.activeVisitId != null
                  ? Icons.work_history
                  : Icons.play_circle_outline,
            ),
            label: Text(
              area.activeVisitId != null
                  ? 'Gerenciar Visita'
                  : 'Iniciar Visita',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: area.activeVisitId != null
                  ? Colors.orange
                  : Colors.green,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h3.copyWith(fontSize: 18)),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
