import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class ClientFilters {
  String? status; // 'active', 'inactive', null (todos)
  String? type; // 'producer', 'consultant', null (todos)
  String? state;
  String? city;
  AreaSize? areaSize;

  ClientFilters({this.status, this.type, this.state, this.city, this.areaSize});

  bool get hasActiveFilters =>
      status != null ||
      type != null ||
      state != null ||
      city != null ||
      areaSize != null;

  int get activeFilterCount {
    int count = 0;
    if (status != null) count++;
    if (type != null) count++;
    if (state != null) count++;
    if (city != null) count++;
    if (areaSize != null) count++;
    return count;
  }

  void clear() {
    status = null;
    type = null;
    state = null;
    city = null;
    areaSize = null;
  }

  ClientFilters copyWith({
    String? Function()? status,
    String? Function()? type,
    String? Function()? state,
    String? Function()? city,
    AreaSize? Function()? areaSize,
  }) {
    return ClientFilters(
      status: status != null ? status() : this.status,
      type: type != null ? type() : this.type,
      state: state != null ? state() : this.state,
      city: city != null ? city() : this.city,
      areaSize: areaSize != null ? areaSize() : this.areaSize,
    );
  }
}

enum AreaSize {
  small, // < 500 ha
  medium, // 500 - 2000 ha
  large, // > 2000 ha
}

class ClientFilterSheet extends StatefulWidget {
  final ClientFilters initialFilters;
  final Function(ClientFilters) onApply;
  final List<String> availableStates;
  final List<String> availableCities;

  const ClientFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    this.availableStates = const [],
    this.availableCities = const [],
  });

  @override
  State<ClientFilterSheet> createState() => _ClientFilterSheetState();
}

class _ClientFilterSheetState extends State<ClientFilterSheet> {
  late ClientFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = ClientFilters(
      status: widget.initialFilters.status,
      type: widget.initialFilters.type,
      state: widget.initialFilters.state,
      city: widget.initialFilters.city,
      areaSize: widget.initialFilters.areaSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtros', style: AppTypography.h3),
                  if (_filters.hasActiveFilters)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filters.clear();
                        });
                      },
                      child: const Text('Limpar tudo'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Filters Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Filter
                    _buildSectionTitle('Status'),
                    const SizedBox(height: 8),
                    _buildChipGroup(
                      options: const ['Todos', 'Ativo', 'Inativo'],
                      selectedValue: _filters.status == null
                          ? 'Todos'
                          : _filters.status == 'active'
                          ? 'Ativo'
                          : 'Inativo',
                      onSelected: (value) {
                        setState(() {
                          if (value == 'Todos') {
                            _filters.status = null;
                          } else if (value == 'Ativo') {
                            _filters.status = 'active';
                          } else {
                            _filters.status = 'inactive';
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Type Filter
                    _buildSectionTitle('Tipo'),
                    const SizedBox(height: 8),
                    _buildChipGroup(
                      options: const ['Todos', 'Produtor', 'Consultor'],
                      selectedValue: _filters.type == null
                          ? 'Todos'
                          : _filters.type == 'producer'
                          ? 'Produtor'
                          : 'Consultor',
                      onSelected: (value) {
                        setState(() {
                          if (value == 'Todos') {
                            _filters.type = null;
                          } else if (value == 'Produtor') {
                            _filters.type = 'producer';
                          } else {
                            _filters.type = 'consultant';
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Area Size Filter
                    _buildSectionTitle('Tamanho da Área'),
                    const SizedBox(height: 8),
                    _buildChipGroup(
                      options: const ['Todos', 'Pequeno', 'Médio', 'Grande'],
                      selectedValue: _filters.areaSize == null
                          ? 'Todos'
                          : _filters.areaSize == AreaSize.small
                          ? 'Pequeno'
                          : _filters.areaSize == AreaSize.medium
                          ? 'Médio'
                          : 'Grande',
                      onSelected: (value) {
                        setState(() {
                          if (value == 'Todos') {
                            _filters.areaSize = null;
                          } else if (value == 'Pequeno') {
                            _filters.areaSize = AreaSize.small;
                          } else if (value == 'Médio') {
                            _filters.areaSize = AreaSize.medium;
                          } else {
                            _filters.areaSize = AreaSize.large;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // State Filter (if available)
                    if (widget.availableStates.isNotEmpty) ...[
                      _buildSectionTitle('Estado'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _filters.state,
                        decoration: InputDecoration(
                          hintText: 'Selecione um estado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Todos os estados'),
                          ),
                          ...widget.availableStates.map((state) {
                            return DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filters.state = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(_filters);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Aplicar${_filters.hasActiveFilters ? ' (${_filters.activeFilterCount})' : ''}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSelected(option);
            }
          },
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        );
      }).toList(),
    );
  }
}
