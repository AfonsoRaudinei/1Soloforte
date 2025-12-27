// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/analysis/data/analysis_repository.dart';
import '../domain/analysis_model.dart';
import '../../clients/domain/client_model.dart';
import '../../map/domain/geo_area.dart';

class AnalysisWizardScreen extends ConsumerStatefulWidget {
  const AnalysisWizardScreen({super.key});

  @override
  ConsumerState<AnalysisWizardScreen> createState() =>
      _AnalysisWizardScreenState();
}

class _AnalysisWizardScreenState extends ConsumerState<AnalysisWizardScreen> {
  int _currentStep = 0;
  Client? _selectedClient;
  GeoArea? _selectedArea;
  AnalysisType _selectedType = AnalysisType.chemical;
  bool _isSaving = false;

  // Mock Role - In real app, get from AuthProvider
  final bool _isConsultant = true;

  @override
  void initState() {
    super.initState();
    if (!_isConsultant) {
      // Auto-select current user client profile
      // _selectedClient = currentUser.clientProfile;
    }
  }

  void _nextStep() {
    // Role Check: If producer, step 0 is skipped or auto-filled
    if (_currentStep == 0 && _selectedClient == null && _isConsultant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente para continuar')),
      );
      return;
    }

    // ... existing validation ...
    if (_currentStep == 1 && _selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma área para continuar')),
      );
      return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _saveAnalysis();
    }
  }

  Future<void> _saveAnalysis() async {
    setState(() => _isSaving = true);

    final newAnalysis = Analysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code:
          'AN-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      client: _selectedClient!,
      area: _selectedArea!,
      type: _selectedType,
      status: AnalysisStatus.pending,
      date: DateTime.now(),
    );

    try {
      await ref.read(analysisRepositoryProvider).saveAnalysis(newAnalysis);
      if (mounted) {
        context.pop(); // Close wizard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Análise solicitada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Análise')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: _currentStep == 2
                        ? 'FINALIZAR SOLICITAÇÃO'
                        : 'CONTINUAR',
                    isLoading: _isSaving,
                    onPressed: details.onStepContinue,
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('VOLTAR'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 0: Client (Only visible/active for Consultants)
          if (_isConsultant)
            Step(
              title: const Text('Cliente'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _ClientSelectionStep(
                selectedClient: _selectedClient,
                onSelect: (client) => setState(() => _selectedClient = client),
              ),
            ),

          Step(
            title: const Text('Área'),
            isActive: _currentStep >= (_isConsultant ? 1 : 0),
            state: _currentStep > (_isConsultant ? 1 : 0)
                ? StepState.complete
                : StepState.indexed,
            content: _AreaSelectionStep(
              selectedArea: _selectedArea,
              onSelect: (area) => setState(() => _selectedArea = area),
            ),
          ),

          // ... remaining steps
          Step(
            title: const Text('Detalhes'),
            isActive: _currentStep >= 2,
            content: _AnalysisDetailsStep(
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              client: _selectedClient,
              area: _selectedArea,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientSelectionStep extends ConsumerWidget {
  final Client? selectedClient;
  final ValueChanged<Client> onSelect;

  const _ClientSelectionStep({
    required this.selectedClient,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsState = ref.watch(clientsControllerProvider);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: clientsState.when(
        data: (clients) {
          if (clients.isEmpty) {
            return const Center(child: Text('Nenhum cliente cadastrado.'));
          }

          return ListView.separated(
            itemCount: clients.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final client = clients[index];
              final isSelected = client.id == selectedClient?.id;

              return ListTile(
                selected: isSelected,
                selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                leading: CircleAvatar(child: Text(client.name[0])),
                title: Text(client.name),
                subtitle: Text(client.city),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => onSelect(client),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _AreaSelectionStep extends ConsumerWidget {
  final GeoArea? selectedArea;
  final ValueChanged<GeoArea> onSelect;

  const _AreaSelectionStep({
    required this.selectedArea,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accessing drawing controller directly for saved areas
    final drawingState = ref.watch(drawingControllerProvider);
    final areas = drawingState.savedAreas;

    if (areas.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Nenhuma área desenhada.\nVá ao mapa e salve uma área primeiro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        itemCount: areas.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final area = areas[index];
          final isSelected = area.id == selectedArea?.id;

          return ListTile(
            selected: isSelected,
            selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
            leading: const Icon(Icons.map_outlined),
            title: Text(area.name),
            subtitle: Text('${area.points.length} pontos'),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: AppColors.primary)
                : null,
            onTap: () => onSelect(area),
          );
        },
      ),
    );
  }
}

class _AnalysisDetailsStep extends StatelessWidget {
  final AnalysisType selectedType;
  final ValueChanged<AnalysisType> onTypeChanged;
  final Client? client;
  final GeoArea? area;

  const _AnalysisDetailsStep({
    required this.selectedType,
    required this.onTypeChanged,
    this.client,
    this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (client != null && area != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Cliente', value: client!.name),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Área', value: area!.name),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Text('Tipo de Análise', style: AppTypography.h3.copyWith(fontSize: 16)),
        const SizedBox(height: 12),
        RadioListTile<AnalysisType>(
          title: const Text('Análise Química de Solo'),
          subtitle: const Text('Macro e micronutrientes'),
          value: AnalysisType.chemical,
          groupValue: selectedType,
          onChanged: (v) => onTypeChanged(v!),
          activeColor: AppColors.primary,
        ),
        RadioListTile<AnalysisType>(
          title: const Text('Análise Física'),
          subtitle: const Text('Texture e granulometria'),
          value: AnalysisType.physical,
          groupValue: selectedType,
          onChanged: (v) => onTypeChanged(v!),
          activeColor: AppColors.primary,
        ),
        RadioListTile<AnalysisType>(
          title: const Text('Análise Biológica'),
          subtitle: const Text('Bioas e enzimas'),
          value: AnalysisType.biological,
          groupValue: selectedType,
          onChanged: (v) => onTypeChanged(v!),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
