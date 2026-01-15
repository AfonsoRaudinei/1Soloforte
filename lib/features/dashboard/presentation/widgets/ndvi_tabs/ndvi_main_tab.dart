import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';

class NdviMainTab extends ConsumerWidget {
  const NdviMainTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ndviState = ref.watch(ndviControllerProvider);
    final controller = ref.read(ndviControllerProvider.notifier);

    if (ndviState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ndviState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            ndviState.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (ndviState.availableDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Nenhuma imagem encontrada.'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  controller.initializeForArea(ndviState.currentArea!),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Legend Box (Fixed, checklist requirement)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legenda NDVI',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildLegendItem(Colors.red, 'Solo/Estresse'),
                  const SizedBox(width: 8),
                  _buildLegendItem(Colors.yellow, 'Vegetação Média'),
                  const SizedBox(width: 8),
                  _buildLegendItem(Colors.green, 'Vegetação Alta'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.yellow, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('-1.0', style: TextStyle(fontSize: 10)),
                  Text('1.0', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text('Datas Disponíveis', style: AppTypography.h4),
        const SizedBox(height: 8),

        // Date List
        ...ndviState.availableDates.map((date) {
          final isSelected = ndviState.selectedDate == date;
          return Card(
            elevation: isSelected ? 2 : 0,
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
              title: Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
              trailing: isSelected
                  ? (ndviState.isImageLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ))
                  : null,
              onTap: () {
                if (!isSelected) {
                  controller.loadNdviImage(date);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
