import 'package:flutter/material.dart';
import '../../../domain/report_constants.dart';

class CategoriesSection extends StatelessWidget {
  final Set<String> selectedCategories;
  final ValueChanged<String> onToggle;

  const CategoriesSection({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: ReportConstants.categories.entries.map((e) {
        final isSelected = selectedCategories.contains(e.key);
        return GestureDetector(
          onTap: () => onToggle(e.key),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: isSelected ? e.value['color'] : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (e.value['color'] as Color).withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  e.value['icon'],
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.value['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
