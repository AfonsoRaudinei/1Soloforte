import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/features/reports/application/report_wizard_provider.dart';

/// Passo 1 do Wizard: Seleção de Template
class TemplateSelectionStep extends ConsumerWidget {
  const TemplateSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(reportWizardProvider);
    final selectedTemplate = wizard.configuration.template;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Escolha um Template', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            'Selecione o tipo de relatório que deseja criar',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Grid de templates
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: ReportTemplate.values.length,
            itemBuilder: (context, index) {
              final template = ReportTemplate.values[index];
              final isSelected = selectedTemplate == template;

              return _TemplateCard(
                template: template,
                isSelected: isSelected,
                onTap: () {
                  ref.read(reportWizardProvider).selectTemplate(template);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final ReportTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? template.color : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? template.color.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: template.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(template.icon, size: 40, color: template.color),
            ),
            const SizedBox(height: 16),

            // Nome
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                template.name,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? template.color : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Descrição
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                template.description,
                style: AppTypography.caption.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Indicador de seleção
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: template.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Selecionado',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
