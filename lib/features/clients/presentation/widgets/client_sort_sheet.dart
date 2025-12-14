import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

enum SortField { name, lastActivity, totalArea, createdDate, city }

enum SortDirection { ascending, descending }

class ClientSortOptions {
  final SortField field;
  final SortDirection direction;

  const ClientSortOptions({required this.field, required this.direction});

  ClientSortOptions copyWith({SortField? field, SortDirection? direction}) {
    return ClientSortOptions(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }

  String get displayName {
    switch (field) {
      case SortField.name:
        return 'Nome';
      case SortField.lastActivity:
        return 'Última atividade';
      case SortField.totalArea:
        return 'Área total';
      case SortField.createdDate:
        return 'Data de cadastro';
      case SortField.city:
        return 'Cidade';
    }
  }

  String get directionLabel {
    if (field == SortField.name || field == SortField.city) {
      return direction == SortDirection.ascending ? 'A-Z' : 'Z-A';
    }
    return direction == SortDirection.ascending ? 'Crescente' : 'Decrescente';
  }
}

class ClientSortSheet extends StatefulWidget {
  final ClientSortOptions initialSort;
  final Function(ClientSortOptions) onApply;

  const ClientSortSheet({
    super.key,
    required this.initialSort,
    required this.onApply,
  });

  @override
  State<ClientSortSheet> createState() => _ClientSortSheetState();
}

class _ClientSortSheetState extends State<ClientSortSheet> {
  late ClientSortOptions _sortOptions;

  @override
  void initState() {
    super.initState();
    _sortOptions = widget.initialSort;
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
                  Text('Ordenar por', style: AppTypography.h3),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Sort Options
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildSortOption(
                    title: 'Nome',
                    subtitle: 'Ordenar alfabeticamente',
                    icon: Icons.sort_by_alpha,
                    field: SortField.name,
                  ),
                  _buildSortOption(
                    title: 'Última atividade',
                    subtitle: 'Mais recente primeiro',
                    icon: Icons.access_time,
                    field: SortField.lastActivity,
                  ),
                  _buildSortOption(
                    title: 'Área total',
                    subtitle: 'Maior área primeiro',
                    icon: Icons.landscape,
                    field: SortField.totalArea,
                  ),
                  _buildSortOption(
                    title: 'Data de cadastro',
                    subtitle: 'Mais recente primeiro',
                    icon: Icons.calendar_today,
                    field: SortField.createdDate,
                  ),
                  _buildSortOption(
                    title: 'Cidade',
                    subtitle: 'Ordenar alfabeticamente',
                    icon: Icons.location_city,
                    field: SortField.city,
                  ),
                ],
              ),
            ),

            // Direction Toggle
            if (_sortOptions.field != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Direção',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SegmentedButton<SortDirection>(
                      segments: [
                        ButtonSegment(
                          value: SortDirection.ascending,
                          icon: const Icon(Icons.arrow_upward, size: 16),
                          label: Text(
                            _getDirectionLabel(SortDirection.ascending),
                          ),
                        ),
                        ButtonSegment(
                          value: SortDirection.descending,
                          icon: const Icon(Icons.arrow_downward, size: 16),
                          label: Text(
                            _getDirectionLabel(SortDirection.descending),
                          ),
                        ),
                      ],
                      selected: {_sortOptions.direction},
                      onSelectionChanged: (Set<SortDirection> newSelection) {
                        setState(() {
                          _sortOptions = _sortOptions.copyWith(
                            direction: newSelection.first,
                          );
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primary;
                          }
                          return Colors.grey[200];
                        }),
                        foregroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey[700];
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Apply Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_sortOptions);
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
                  child: const Text('Aplicar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required SortField field,
  }) {
    final isSelected = _sortOptions.field == field;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey[600],
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : Colors.grey[900],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.caption.copyWith(color: Colors.grey[600]),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.05),
      onTap: () {
        setState(() {
          _sortOptions = _sortOptions.copyWith(field: field);
        });
      },
    );
  }

  String _getDirectionLabel(SortDirection direction) {
    if (_sortOptions.field == SortField.name ||
        _sortOptions.field == SortField.city) {
      return direction == SortDirection.ascending ? 'A-Z' : 'Z-A';
    }
    return direction == SortDirection.ascending ? 'Menor' : 'Maior';
  }
}
