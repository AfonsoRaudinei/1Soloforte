import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/features/reports/application/custom_report_layout_provider.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

class CustomReportTab extends ConsumerStatefulWidget {
  const CustomReportTab({super.key});

  @override
  ConsumerState<CustomReportTab> createState() => _CustomReportTabState();
}

class _CustomReportTabState extends ConsumerState<CustomReportTab> {
  bool _isGenerating = false;

  Future<void> _generateCustomReport(List<ReportSection> sections) async {
    if (_isGenerating) return;

    // Get only visible sections in current order
    final visibleSections = sections.where((s) => s.isVisible).toList();

    if (visibleSections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos uma seção para o relatório'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final reportService = ref.read(reportServiceProvider);

      // Fetch all necessary data
      final weeklyData = await reportService.getWeeklyReport();
      final cropData = await reportService.getCropSummary();
      final pestData = await reportService.getPestReport();

      // Generate custom PDF with selected sections
      await reportService.generateAndShareCustomReport(
        sections: visibleSections,
        weeklyData: weeklyData,
        cropData: cropData,
        pestData: pestData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Relatório personalizado gerado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar relatório: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _resetLayout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Layout Padrão'),
        content: const Text(
          'Tem certeza que deseja restaurar o layout padrão? '
          'Todas as personalizações serão perdidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              foregroundColor: Colors.white,
            ),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(customReportLayoutProvider).resetToDefault();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Layout restaurado para o padrão'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wait for SharedPreferences to initialize
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro ao carregar: $error')),
      data: (_) {
        // Now we can safely watch the layout provider
        final layoutNotifier = ref.watch(customReportLayoutProvider);
        final sections = layoutNotifier.sections;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildDragAndDropList(layoutNotifier, sections),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetLayout,
                      icon: const Icon(Icons.restore),
                      label: const Text('Restaurar Padrão'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: _isGenerating
                          ? 'Gerando...'
                          : 'Gerar Relatório Personalizado',
                      onPressed: _isGenerating
                          ? null
                          : () => _generateCustomReport(sections),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personalize seu Relatório', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text(
                      'Arraste os itens para reordenar ou desmarque para ocultar.',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, size: 14, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Auto-salvo',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDragAndDropList(
    CustomReportLayoutNotifier notifier,
    List<ReportSection> sections,
  ) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      onReorder: (oldIndex, newIndex) {
        notifier.reorderSections(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final section = sections[index];
        return AppCard(
          key: ValueKey(section.id),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.drag_handle, color: Colors.grey[400]),
            title: Text(section.title, style: AppTypography.bodySmall),
            subtitle: Text(
              _getSectionTypeLabel(section.type),
              style: AppTypography.caption,
            ),
            trailing: Switch(
              value: section.isVisible,
              onChanged: (val) {
                notifier.toggleVisibility(section.id);
              },
              activeThumbColor: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  String _getSectionTypeLabel(ReportSectionType type) {
    switch (type) {
      case ReportSectionType.chart:
        return 'Gráfico';
      case ReportSectionType.text:
        return 'Texto Descritivo';
      case ReportSectionType.table:
        return 'Tabela de Dados';
      case ReportSectionType.map:
        return 'Mapa Visual';
      case ReportSectionType.metrics:
        return 'Indicadores';
    }
  }
}
