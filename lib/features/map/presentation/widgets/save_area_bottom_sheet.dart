import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/providers/clients_provider.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';

class SaveAreaBottomSheet extends ConsumerStatefulWidget {
  final Function({
    required String name,
    required String clientId,
    required String clientName,
    String? fieldId,
    String? fieldName,
    String? notes,
    int? colorValue,
    required bool isDashed,
  })
  onSave;
  final VoidCallback? onCancel;
  final GeoArea? initialData;

  const SaveAreaBottomSheet({
    super.key,
    required this.onSave,
    this.onCancel,
    this.initialData,
  });

  @override
  ConsumerState<SaveAreaBottomSheet> createState() =>
      _SaveAreaBottomSheetState();
}

class _SaveAreaBottomSheetState extends ConsumerState<SaveAreaBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  Client? _selectedClient;
  String? _selectedFieldId;
  final _fieldNameController = TextEditingController();
  final _notesController = TextEditingController();

  // State
  bool _isNewField = true;
  bool _initialized = false;
  int _selectedColorValue = 0xFF4CAF50; // Default Green
  bool _isDashed = false;

  final List<Color> _availableColors = const [
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFFC107), // Amber/Yellow
    Color(0xFFF44336), // Red
    Color(0xFF9E9E9E), // Grey
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.initialData != null) {
        _initializeFromData(widget.initialData!);
      } else {
        _initializeFromVisit();
      }
    }
  }

  void _initializeFromData(GeoArea area) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Ensure colors options include the saved color if custom?
          // For now assume it's one of the available or just use raw value
          if (area.colorValue != null) {
            _selectedColorValue = area.colorValue!;
          }
          _isDashed = area.isDashed;

          _fieldNameController.text = area.fieldName ?? area.name;
          _notesController.text = area.notes ?? '';

          // We need to fetch clients locally or wait for provider
          // We can't synchronously get clients here easily if not loaded.
          // However, clientsProvider is likely cached.

          // We will try to match client by ID when provider creates list
          // See build method for how we handle this?
          // Better: Set a flag or ID and match in build.
        });
      }
    });
  }

  void _initializeFromVisit() {
    // Check if there's an active visit to auto-fill client
    final activeVisit = ref.read(visitControllerProvider).valueOrNull;
    if (activeVisit != null) {
      // We can't set state directly here if called during build (though didChange usually safe but deferred is better)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedClient = activeVisit.client;
            // Try to match area name if possible
            if (activeVisit.areaName != null) {
              // Check if areaName exists in mock fields
              final fields = _getMockFieldsForClient(activeVisit.client.id);
              final match = fields.firstWhere(
                (f) => f['name'] == activeVisit.areaName,
                orElse: () => {},
              );

              if (match.isNotEmpty) {
                _selectedFieldId = match['id'];
                _isNewField = false;
              } else {
                // Pre-fill "Create New" with visit area name?
                // No, keep it clean.
              }
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Mock fields provider (since we don't have a real one yet)
  // In a real app, this would come from a provider filtered by client
  List<Map<String, String>> _getMockFieldsForClient(String clientId) {
    if (clientId.isEmpty) return [];
    // Just simple mock logic based on client ID
    return [
      {'id': '1', 'name': 'Talhão Norte'},
      {'id': '2', 'name': 'Talhão Sul'},
      {'id': '3', 'name': 'Área Experimental'},
    ];
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedClient == null) return;

      final fieldName = _isNewField
          ? _fieldNameController.text
          : _getMockFieldsForClient(
              _selectedClient!.id,
            ).firstWhere((f) => f['id'] == _selectedFieldId)['name']!;

      widget.onSave(
        name: fieldName, // Use field name as area name
        clientId: _selectedClient!.id,
        clientName: _selectedClient!.name,
        fieldId: _isNewField ? null : _selectedFieldId,
        fieldName: fieldName,
        notes: _notesController.text,
        colorValue: _selectedColorValue,
        isDashed: _isDashed,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                const Icon(Icons.save_as, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Salvar Área Desenhada',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 1. Client / Producer
            clientsAsync.when(
              data: (clients) => DropdownButtonFormField<Client>(
                initialValue: _selectedClient,
                decoration: InputDecoration(
                  labelText: 'Cliente / Produtor *',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: clients.map((client) {
                  return DropdownMenuItem(
                    value: client,
                    child: Text(client.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClient = value;
                    _selectedFieldId = null; // Reset field selection
                    _isNewField = true; // Default to create new
                  });
                },

                // Pre-selection Logic
                // We do this by finding the client object that matches ID
                // value: _selectedClient ?? (widget.initialData != null ? clients.firstWhere((c) => c.id == widget.initialData!.clientId, orElse: () => clients.first) : null),
                // Since Dropdown needs exact object reference often, we might need to fix _selectedClient in build or init.
                // Simplified:
                validator: (value) =>
                    value == null ? 'Selecione um cliente' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('Erro ao carregar clientes: $err'),
            ),
            const SizedBox(height: 16),

            // 2. Field / Area Name
            if (_selectedClient != null) ...[
              DropdownButtonFormField<String>(
                initialValue: _isNewField ? 'new' : _selectedFieldId,
                decoration: InputDecoration(
                  labelText: 'Talhão / Área *',
                  prefixIcon: const Icon(Icons.grass_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: [
                  const DropdownMenuItem(
                    value: 'new',
                    child: Text('➕ Criar Novo Talhão'),
                  ),
                  ..._getMockFieldsForClient(_selectedClient!.id).map((field) {
                    return DropdownMenuItem(
                      value: field['id'],
                      child: Text(field['name']!),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == 'new') {
                      _isNewField = true;
                      _selectedFieldId = null;
                    } else {
                      _isNewField = false;
                      _selectedFieldId = value;
                    }
                  });
                },
              ),
              if (_isNewField) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fieldNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Nova Área *',
                    hintText: 'Ex: Talhão 5 - Pivô Central',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (_isNewField && (value == null || value.isEmpty)) {
                      return 'Informe o nome da área';
                    }
                    return null;
                  },
                ),
              ],
            ] else ...[
              // Placeholder disabled
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Talhão / Área',
                  hintText: 'Selecione um cliente primeiro',
                  prefixIcon: const Icon(Icons.grass_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // 3. Notes (Optional)
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Observações (Opcional)',
                prefixIcon: const Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Buttons
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Linha Tracejada'),
              subtitle: const Text('Estilo do contorno da área'),
              value: _isDashed,
              onChanged: (val) => setState(() => _isDashed = val),
              secondary: const Icon(Icons.line_style),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      widget.onCancel?.call();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Descartar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _handleSave,
                    icon: const Icon(Icons.check),
                    label: const Text('Salvar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
