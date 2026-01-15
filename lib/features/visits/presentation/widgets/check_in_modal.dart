import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/providers/clients_provider.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:go_router/go_router.dart';

class CheckInModal extends ConsumerStatefulWidget {
  final GeoArea? initialArea;

  const CheckInModal({super.key, this.initialArea});

  @override
  ConsumerState<CheckInModal> createState() => _CheckInModalState();
}

class _CheckInModalState extends ConsumerState<CheckInModal> {
  Client? _selectedClient;
  String? _selectedArea;
  String? _selectedActivity;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _activities = [
    'Visita técnica',
    'Aplicação',
    'Colheita',
    'Manutenção',
    'Outro',
  ];

  // TODO: Obter áreas reais do cliente
  final List<String> _mockAreas = [
    'Talhão Norte',
    'Talhão Sul',
    'Sede',
    'Pivô 01',
    'Pivô 02',
    'Área de Teste',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialArea != null) {
      _selectedArea = widget.initialArea!.name;
      // Note: Client needs to be matched by ID or name after clientsProvider loads.
      // We will handle this in build via side-effect or just rely on manual selection if mismatch.
      // However, if we have clientId in GeoArea, we can try to find it.
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleCheckIn() {
    if (_selectedClient == null ||
        _selectedArea == null ||
        _selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha os campos obrigatórios (Cliente, Área, Atividade)',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref
        .read(visitControllerProvider.notifier)
        .checkIn(
          client: _selectedClient!,
          areaName: _selectedArea,
          areaId: widget.initialArea?.id, // Pass areaId if started from map
          activityType: _selectedActivity,
          notes: _notesController.text,
        );

    context.pop(); // Close modal
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Check-in de Visita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // GPS Info (Simulado visualmente)
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'Localização atual detectada',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cliente
          DropdownButtonFormField<Client>(
            decoration: InputDecoration(
              labelText: 'Cliente *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            initialValue: _selectedClient,
            items: clientsAsync.when(
              data: (clients) => clients
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              loading: () => [],
              error: (_, __) => [],
            ),
            onChanged: (val) {
              setState(() {
                _selectedClient = val;
                _selectedArea = null; // Reset area on client change
              });
            },
          ),
          const SizedBox(height: 16),

          // Area & Activity Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Área / Talhão *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  initialValue: _selectedArea,
                  items: _mockAreas
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedArea = val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Atividade *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  initialValue: _selectedActivity,
                  items: _activities
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedActivity = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Observações (Opcional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Actions
          ElevatedButton(
            onPressed: _handleCheckIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Confirmar Check-in',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
