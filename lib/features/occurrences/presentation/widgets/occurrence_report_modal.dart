import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/occurrences/domain/report_constants.dart';
import 'report_modal/report_form_fields.dart';
import 'report_modal/phenology_section.dart';
import 'report_modal/visit_info_section.dart';
import 'report_modal/categories_section.dart';
import '../providers/occurrence_report_controller.dart';
import '../providers/occurrence_report_state.dart';

class OccurrenceReportModal extends ConsumerStatefulWidget {
  const OccurrenceReportModal({super.key});

  @override
  ConsumerState<OccurrenceReportModal> createState() =>
      _OccurrenceReportModalState();
}

class _OccurrenceReportModalState extends ConsumerState<OccurrenceReportModal> {
  // Form Controllers
  final _produtorController = TextEditingController();
  final _propriedadeController = TextEditingController();
  final _areaController = TextEditingController();
  final _cultivarController = TextEditingController();
  final _tecnicoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _recomendacoesController = TextEditingController();
  final _coordinatesController = TextEditingController();

  // Dynamic controllers for category notes
  final Map<String, TextEditingController> _categoryNoteControllers = {};

  @override
  void dispose() {
    _produtorController.dispose();
    _propriedadeController.dispose();
    _areaController.dispose();
    _cultivarController.dispose();
    _tecnicoController.dispose();
    _observacoesController.dispose();
    _recomendacoesController.dispose();
    _coordinatesController.dispose();
    for (final controller in _categoryNoteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(occurrenceReportControllerProvider);
    final controller = ref.read(occurrenceReportControllerProvider.notifier);

    // Sync Coordinates Text
    if (state.latitude != null && state.longitude != null) {
      final coordText =
          "${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}";
      if (_coordinatesController.text != coordText) {
        _coordinatesController.text = coordText;
      }
    }

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor:
            AppColors.backgroundSecondary, // Apple-like gray background
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Relatório de Visita Agrícola',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exportando PDF... (Simulado)')),
                );
              },
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.blueAccent,
                size: 20,
              ),
              label: const Text(
                'PDF',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.blueAccent),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              _buildSection(
                title: 'Informações da Visita',
                child: VisitInfoSection(
                  produtorController: _produtorController,
                  propriedadeController: _propriedadeController,
                  areaController: _areaController,
                  cultivarController: _cultivarController,
                  selectedDate: state.selectedDate,
                  plantingDate: state.plantingDate,
                  onDateChanged: controller.updateSelectedDate,
                  onPlantingDateChanged: controller.updatePlantingDate,
                  dap: state.dap,
                ),
              ),
              _buildSection(
                title: 'Estádio Fenológico',
                child: PhenologySection(
                  selectedStage: state.selectedStage,
                  stages: ReportConstants.stages,
                  onChanged: controller.setStage,
                ),
              ),
              _buildSection(
                title: 'Categoria',
                child: CategoriesSection(
                  selectedCategories: state.selectedCategories,
                  onToggle: (cat) {
                    HapticFeedback.lightImpact();
                    controller.toggleCategory(cat);
                  },
                ),
              ),
              if (state.selectedCategories.isNotEmpty)
                _buildDynamicProblemSections(state, controller),
              _buildSection(
                title: 'Observações - Geral',
                child: ReportTextArea(controller: _observacoesController),
              ),
              _buildSection(
                title: 'Recomendações Técnicas',
                child: ReportTextArea(controller: _recomendacoesController),
              ),
              _buildSection(
                title: 'Localização & Responsável',
                child: _buildLocationForm(state, controller),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: state.isSaving
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  controller
                      .saveReport(
                        produtor: _produtorController.text,
                        propriedade: _propriedadeController.text,
                        area: _areaController.text,
                        cultivar: _cultivarController.text,
                        tecnico: _tecnicoController.text,
                        observacoes: _observacoesController.text,
                        recomendacoes: _recomendacoesController.text,
                      )
                      .then((_) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Relatório salvo com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                },
          label: state.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.surface,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Salvar Relatório'),
          icon: state.isSaving
              ? const SizedBox.shrink()
              : const Icon(Icons.save),
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicProblemSections(
    OccurrenceReportState state,
    OccurrenceReportController controller,
  ) {
    return Column(
      children: state.selectedCategories.map((catKey) {
        final cat = ReportConstants.categories[catKey]!;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cat['color'],
                      radius: 16,
                      child: Icon(cat['icon'], size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      cat['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (cat['type'] == 'multi')
                      ...(cat['levels'] as List<String>).map(
                        (level) => _buildSeveritySlider(
                          catKey,
                          level,
                          state,
                          controller,
                        ),
                      ),
                    if (cat['type'] == 'standard')
                      _buildSeveritySlider(
                        catKey,
                        'Severidade',
                        state,
                        controller,
                      ),
                    if (cat['type'] == 'water')
                      _buildWaterSlider(catKey, state, controller),
                    if (cat['type'] == 'nutrients')
                      _buildNutrientsGrid(state, controller),

                    const SizedBox(height: 15),
                    ReportTextArea(
                      controller: _categoryNoteControllers.putIfAbsent(
                        catKey,
                        () => TextEditingController(
                          text: state.categoryNotes[catKey],
                        ),
                      ),
                      hint: 'Anotações sobre ${cat['title'].toLowerCase()}...',
                      onChanged: (text) =>
                          controller.updateCategoryNote(catKey, text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- Sliders & Custom Inputs ---

  Widget _buildSeveritySlider(
    String catKey,
    String label,
    OccurrenceReportState state,
    OccurrenceReportController controller,
  ) {
    String key = '${catKey}_$label';
    double value = state.severityData[key] ?? 0.0;

    // Labels mapping
    String getLabel(double v) {
      if (v == 0) return 'Nenhum';
      if (v == 1) return 'Baixa';
      if (v == 2) return 'Média';
      if (v == 3) return 'Alta';
      return '';
    }

    Color getColor(double v) {
      if (v == 0) return Colors.grey;
      if (v == 1) return Colors.green;
      if (v == 2) return Colors.orange;
      return Colors.red;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getColor(value).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getLabel(value),
                style: TextStyle(
                  color: getColor(value),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 3,
          divisions: 3,
          activeColor: getColor(value),
          label: getLabel(value),
          onChanged: (v) => controller.updateSeverity(key, v),
        ),
      ],
    );
  }

  Widget _buildWaterSlider(
    String catKey,
    OccurrenceReportState state,
    OccurrenceReportController controller,
  ) {
    double value =
        state.severityData[catKey] ?? 0.0; // 0=Adequado, 1=Seco, 2=Excesso
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status Hídrico',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              value == 0 ? 'Adequado' : (value == 1 ? 'Seco' : 'Excesso'),
              style: TextStyle(
                color: value == 0 ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 2,
          divisions: 2,
          onChanged: (v) => controller.updateSeverity(catKey, v),
        ),
      ],
    );
  }

  Widget _buildNutrientsGrid(
    OccurrenceReportState state,
    OccurrenceReportController controller,
  ) {
    final nutrients = [
      'N',
      'P',
      'K',
      'Ca',
      'Mg',
      'S',
      'B',
      'Zn',
      'Fe',
      'Mn',
      'Cu',
      'Mo',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: nutrients.map((n) {
        final isSelected = state.selectedNutrients.contains(n);
        return GestureDetector(
          onTap: () => controller.toggleNutrient(n),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              n,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLocationForm(
    OccurrenceReportState state,
    OccurrenceReportController controller,
  ) {
    return Column(
      children: [
        ReportTextInput(
          label: 'Técnico',
          controller: _tecnicoController,
          hint: 'Nome do responsável',
        ),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text("Coordenadas", style: TextStyle(fontSize: 16)),
              ),
              Expanded(
                child: TextField(
                  controller: _coordinatesController,
                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Toque para capturar',
                    hintStyle: TextStyle(
                      color: Colors.blue.withValues(alpha: 0.8),
                    ),
                  ),
                  onTap: () {
                    // Simulating Geo Location
                    HapticFeedback.heavyImpact();
                    controller.setCoordinates(-12.9837, -38.4922);
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.location_on, color: Colors.blue, size: 18),
            ],
          ),
        ),
        const SizedBox(height: 10),
        RadioGroup<String>(
          groupValue: state.occurrenceType,
          onChanged: (v) {
            if (v != null) controller.setOccurrenceType(v);
          },
          child: Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Sazonal', style: TextStyle(fontSize: 14)),
                  value: 'sazonal',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text(
                    'Permanente',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: 'permanente',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        CheckboxListTile(
          title: const Text('Amostra de Solo Coletada'),
          value: state.soilSample,
          onChanged: (v) => controller.toggleSoilSample(v!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: AppColors.border);
}
