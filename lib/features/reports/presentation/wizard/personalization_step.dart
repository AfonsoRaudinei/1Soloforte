import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_wizard_provider.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';

/// Passo 3 do Wizard: Personalização
class PersonalizationStep extends ConsumerStatefulWidget {
  const PersonalizationStep({super.key});

  @override
  ConsumerState<PersonalizationStep> createState() =>
      _PersonalizationStepState();
}

class _PersonalizationStepState extends ConsumerState<PersonalizationStep> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  String? _selectedHeaderTemplate;

  @override
  void initState() {
    super.initState();
    final config = ref.read(reportWizardProvider).configuration;
    _titleController = TextEditingController(text: config.customTitle ?? '');
    _notesController = TextEditingController(text: config.generalNotes ?? '');
    _selectedHeaderTemplate = config.headerTemplate ?? 'default';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wizard = ref.watch(reportWizardProvider);
    final template = wizard.configuration.template;

    if (template == null) {
      return const Center(child: Text('Selecione um template primeiro'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalização', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            'Customize a aparência e conteúdo do relatório',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Título
          _buildTitleSection(),
          const SizedBox(height: 24),

          // Logo/Cabeçalho
          _buildHeaderSection(),
          const SizedBox(height: 24),

          // Seções a incluir
          _buildSectionsSection(template),
          const SizedBox(height: 24),

          // Observações gerais
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.title, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Título do Relatório', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Ex: Relatório Semanal - Fazenda São João',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: IconButton(
                icon: const Icon(Icons.auto_awesome),
                tooltip: 'Gerar título automático',
                onPressed: () {
                  final template = ref
                      .read(reportWizardProvider)
                      .configuration
                      .template;
                  final suggestedTitle = _generateTitle(template!);
                  _titleController.text = suggestedTitle;
                  ref.read(reportWizardProvider).setCustomTitle(suggestedTitle);
                },
              ),
            ),
            onChanged: (value) {
              ref.read(reportWizardProvider).setCustomTitle(value);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Deixe vazio para usar o título padrão',
            style: AppTypography.caption.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final templates = [
      {'id': 'default', 'name': 'Padrão', 'icon': Icons.article},
      {'id': 'professional', 'name': 'Profissional', 'icon': Icons.business},
      {'id': 'minimal', 'name': 'Minimalista', 'icon': Icons.minimize},
      {'id': 'colorful', 'name': 'Colorido', 'icon': Icons.palette},
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Cabeçalho', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 16),

          // Seleção de template de cabeçalho
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: templates.map((template) {
              final isSelected = _selectedHeaderTemplate == template['id'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHeaderTemplate = template['id'] as String;
                  });
                  ref
                      .read(reportWizardProvider)
                      .setHeaderTemplate(template['id'] as String);
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        template['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey[600],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        template['name'] as String,
                        style: AppTypography.caption.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Upload de logo (placeholder)
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Upload de logo será implementado em breve'),
                ),
              );
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Adicionar Logo Personalizado'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsSection(template) {
    // Note: template.availableMetrics are shown via the info box below

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.view_module, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Seções a Incluir', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Todas as métricas selecionadas serão incluídas',
            style: AppTypography.caption.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'As seções seguirão a ordem das métricas selecionadas no passo anterior',
                    style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Observações Gerais', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Adicione observações, comentários ou notas importantes...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) {
              ref.read(reportWizardProvider).setGeneralNotes(value);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Estas observações aparecerão no final do relatório',
            style: AppTypography.caption.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _generateTitle(template) {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    return '${template.name} - $dateStr';
  }
}
