import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/templates/before_after_template.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/templates/highlight_result_template.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/templates/ndvi_evolution_template.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/templates/story_template.dart';

enum TemplateType {
  beforeAfter,
  ndviEvolution,
  highlightResult,
  story,
  generic,
}

class TemplateBuilderScreen extends StatelessWidget {
  final TemplateType templateType;

  const TemplateBuilderScreen({super.key, required this.templateType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(_getTitle(), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save/Export
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Template salvo!')));
            },
            child: const Text(
              'Concluir',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 600,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: _buildTemplateContent(),
              ),
              SizedBox(height: AppSpacing.lg),
              const Text(
                'Toque nos elementos para editar',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (templateType) {
      case TemplateType.beforeAfter:
        return 'Antes e Depois';
      case TemplateType.ndviEvolution:
        return 'Evolução NDVI';
      case TemplateType.highlightResult:
        return 'Destaque de Resultado';
      case TemplateType.story:
        return 'Story (9:16)';
      default:
        return 'Template';
    }
  }

  Widget _buildTemplateContent() {
    switch (templateType) {
      case TemplateType.beforeAfter:
        return const BeforeAfterTemplate();
      case TemplateType.ndviEvolution:
        return const NdviEvolutionTemplate();
      case TemplateType.highlightResult:
        return const HighlightResultTemplate();
      case TemplateType.story:
        return const StoryTemplate();
      default:
        return const Center(child: Text('Template não encontrado'));
    }
  }
}
