import 'package:flutter/material.dart';
import 'package:soloforte_app/features/visits/domain/visit_constants.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/active_visit/visit_section.dart';

class ProblemDetailsForm extends StatelessWidget {
  final Set<String> selectedCategories;
  final Map<String, Map<String, String>> problemsData;
  final Set<String> selectedNutrients;
  final Function(String, String, String) onSeverityChanged;
  final ValueChanged<String> onToggleNutrient;

  const ProblemDetailsForm({
    super.key,
    required this.selectedCategories,
    required this.problemsData,
    required this.selectedNutrients,
    required this.onSeverityChanged,
    required this.onToggleNutrient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: selectedCategories.map((catKey) {
        final cat = visitCategories[catKey];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: VisitSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(cat['icon'], style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      cat['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (cat['type'] == 'multi')
                  ...(cat['levels'] as List).map(
                    (level) => _buildSeveritySelector(
                      catKey,
                      level['id'],
                      level['name'],
                    ),
                  ),

                if (cat['type'] == 'standard')
                  _buildSeveritySelector(catKey, 'main', 'Severidade'),

                if (cat['type'] == 'nutrients')
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: nutrientsList.map((nut) {
                      final isSelected = selectedNutrients.contains(nut['id']);
                      return ChoiceChip(
                        label: Text('${nut['name']} (${nut['symbol']})'),
                        selected: isSelected,
                        onSelected: (_) => onToggleNutrient(nut['id']!),
                        selectedColor: (cat['color'] as Color).withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? (cat['color'] as Color).withAlpha(255)
                              : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        avatar: isSelected
                            ? Icon(Icons.check, size: 16, color: cat['color'])
                            : null,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySelector(String catKey, String subKey, String label) {
    const options = ['Nenhum', 'Baixa', 'Média', 'Alta'];
    final currentVal = problemsData[catKey]?[subKey];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: options.map((opt) {
              final isSelected = currentVal == opt;
              Color color = Colors.grey.shade100;
              Color textColor = Colors.black87;

              if (isSelected) {
                if (opt == 'Baixa') {
                  color = Colors.orange;
                  textColor = Colors.white;
                } else if (opt == 'Média') {
                  color = Colors.deepOrange;
                  textColor = Colors.white;
                } else if (opt == 'Alta') {
                  color = Colors.red;
                  textColor = Colors.white;
                } else {
                  color = Colors.green;
                  textColor = Colors.white;
                }
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => onSeverityChanged(catKey, subKey, opt),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
