import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class PhenologySection extends StatelessWidget {
  final String? selectedStage;
  final Map<String, Map<String, dynamic>> stages;
  final ValueChanged<String?> onChanged;

  const PhenologySection({
    super.key,
    required this.selectedStage,
    required this.stages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: InputBorder.none),
          initialValue: selectedStage,
          hint: const Text('Selecione o estádio'),
          items: stages.entries.map((e) {
            return DropdownMenuItem(value: e.key, child: Text(e.value['name']));
          }).toList(),
          onChanged: onChanged,
        ),
        if (selectedStage != null) ...[
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade50, Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Icon(
                  stages[selectedStage]!['icon'],
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  stages[selectedStage]!['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stages[selectedStage]!['desc'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stages[selectedStage]!['dap'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
