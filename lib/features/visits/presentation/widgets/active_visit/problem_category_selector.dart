import 'package:flutter/material.dart';
import 'package:soloforte_app/features/visits/domain/visit_constants.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/active_visit/visit_section.dart';

class ProblemCategorySelector extends StatelessWidget {
  final Set<String> selectedCategories;
  final ValueChanged<String> onToggleCategory;

  const ProblemCategorySelector({
    super.key,
    required this.selectedCategories,
    required this.onToggleCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VisitSectionHeader(title: 'Categorias'),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: visitCategories.keys.map((key) {
              final cat = visitCategories[key];
              final isSelected = selectedCategories.contains(key);

              return GestureDetector(
                onTap: () => onToggleCategory(key),
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'] : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? cat['color']
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: (cat['color'] as Color).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cat['icon'],
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['title'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
