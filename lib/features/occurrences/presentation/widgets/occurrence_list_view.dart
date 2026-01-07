import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';

class OccurrenceListView extends ConsumerStatefulWidget {
  const OccurrenceListView({super.key});

  @override
  ConsumerState<OccurrenceListView> createState() => _OccurrenceListViewState();
}

class _OccurrenceListViewState extends ConsumerState<OccurrenceListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch provider
    final occurrencesAsync = ref.watch(occurrenceControllerProvider);

    return Column(
      children: [
        // Filters & Actions Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        isSelected: _selectedFilter == 'Todos',
                        onSelected: (val) =>
                            setState(() => _selectedFilter = 'Todos'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Ativas',
                        isSelected: _selectedFilter == 'Ativas',
                        onSelected: (val) =>
                            setState(() => _selectedFilter = 'Ativas'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Monitorando',
                        isSelected: _selectedFilter == 'Monitorando',
                        onSelected: (val) =>
                            setState(() => _selectedFilter = 'Monitorando'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Resolvidas',
                        isSelected: _selectedFilter == 'Resolvidas',
                        onSelected: (val) =>
                            setState(() => _selectedFilter = 'Resolvidas'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextInput(
            controller: _searchController,
            label: '',
            hint: 'Buscar ocorrências...',
            prefixIcon: Icons.search,
            onChanged: (value) {
              setState(() {}); // Trigger rebuild to filter list
            },
          ),
        ),

        // List Content
        Expanded(
          child: occurrencesAsync.when(
            data: (occurrences) {
              // Apply Filters
              var filteredList = occurrences;

              // 1. Status Filter
              if (_selectedFilter == 'Ativas') {
                filteredList = filteredList
                    .where((o) => o.status == 'active')
                    .toList();
              } else if (_selectedFilter == 'Monitorando') {
                filteredList = filteredList
                    .where((o) => o.status == 'monitoring')
                    .toList();
              } else if (_selectedFilter == 'Resolvidas') {
                filteredList = filteredList
                    .where((o) => o.status == 'resolved')
                    .toList();
              }

              // 2. Search Filter
              final query = _searchController.text.toLowerCase();
              if (query.isNotEmpty) {
                filteredList = filteredList.where((o) {
                  return o.title.toLowerCase().contains(query) ||
                      o.description.toLowerCase().contains(query) ||
                      (o.areaName.toLowerCase().contains(query) ?? false);
                }).toList();
              }

              if (filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 24),
                      Text(
                        'Nenhuma ocorrência encontrada',
                        style: AppTypography.h3.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tente ajustar seus filtros ou crie uma nova ocorrência.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(occurrenceControllerProvider.notifier)
                      .refresh();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final occurrence = filteredList[index];
                    return _OccurrenceCard(occurrence: occurrence);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar ocorrências',
                    style: AppTypography.bodyLarge,
                  ),
                  TextButton(
                    onPressed: () => ref
                        .read(occurrenceControllerProvider.notifier)
                        .refresh(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      showCheckmark: false,
    );
  }
}

class _OccurrenceCard extends StatelessWidget {
  final Occurrence occurrence;

  const _OccurrenceCard({required this.occurrence});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.error;
      case 'monitoring':
        return AppColors.warning;
      case 'resolved':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'ATIVA';
      case 'monitoring':
        return 'MONITORANDO';
      case 'resolved':
        return 'RESOLVIDA';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'pest':
        return Icons.bug_report;
      case 'disease':
        return Icons.coronavirus;
      case 'deficiency':
        return Icons.spa;
      default:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        context.push('/occurrences/detail/${occurrence.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(occurrence.type),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Title & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(occurrence.title, style: AppTypography.h4),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${occurrence.areaName}',
                      style: AppTypography.bodySmall,
                    ),
                    Text(
                      '🕐 há ${_getRelativeTime(occurrence.date)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(occurrence.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(occurrence.status)),
                ),
                child: Text(
                  _getStatusLabel(occurrence.status),
                  style: AppTypography.caption.copyWith(
                    color: _getStatusColor(occurrence.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Severity Bar
          Row(
            children: [
              Text('Severidade:', style: AppTypography.caption),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: occurrence.severity,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      occurrence.severity > 0.7
                          ? AppColors.error
                          : (occurrence.severity > 0.4
                                ? AppColors.warning
                                : AppColors.success),
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(occurrence.severity * 100).toInt()}%',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} dias atrás';
    if (diff.inHours > 0) return '${diff.inHours} horas atrás';
    return '${diff.inMinutes} min atrás';
  }
}
