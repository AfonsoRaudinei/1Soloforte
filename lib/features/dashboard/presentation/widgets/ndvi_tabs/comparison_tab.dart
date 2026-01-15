import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';
import 'package:intl/intl.dart';

class ComparisonTab extends ConsumerStatefulWidget {
  const ComparisonTab({super.key});

  @override
  ConsumerState<ComparisonTab> createState() => _ComparisonTabState();
}

class _ComparisonTabState extends ConsumerState<ComparisonTab> {
  DateTime? _dateA;
  DateTime? _dateB;
  bool _showA = true;

  @override
  void initState() {
    super.initState();
    // Initialize defaults from available dates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ndviState = ref.read(ndviControllerProvider);
      if (ndviState.availableDates.isNotEmpty) {
        setState(() {
          _dateA = ndviState.availableDates.first;
          _dateB = ndviState.availableDates.length > 1
              ? ndviState.availableDates[1]
              : ndviState.availableDates.first;
        });
      }
    });
  }

  void _handleToggle() {
    setState(() => _showA = !_showA);
    final target = _showA ? _dateA : _dateB;
    if (target != null) {
      ref.read(ndviControllerProvider.notifier).loadNdviImage(target);
    }
  }

  void _updateDateA(DateTime? newDate) {
    if (newDate == null) return;
    setState(() => _dateA = newDate);
    if (_showA) {
      ref.read(ndviControllerProvider.notifier).loadNdviImage(newDate);
    }
  }

  void _updateDateB(DateTime? newDate) {
    if (newDate == null) return;
    setState(() => _dateB = newDate);
    if (!_showA) {
      ref.read(ndviControllerProvider.notifier).loadNdviImage(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ndviState = ref.watch(ndviControllerProvider);
    final dates = ndviState.availableDates;

    if (dates.isEmpty) {
      return const Center(child: Text('Dados insuficientes para comparação.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Comparação Temporal', style: AppTypography.h4),
        const SizedBox(height: 16),

        // Date A Selector
        _buildDateSelector(
          label: 'Data A (Inicial)',
          value: _dateA,
          items: dates,
          onChanged: _updateDateA,
          isActive: _showA,
          color: Colors.blue,
        ),

        const SizedBox(height: 16),

        // Toggle Button
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleOption('Visualizar A', _showA, () {
                  if (!_showA) _handleToggle();
                }),
                _buildToggleOption('Visualizar B', !_showA, () {
                  if (_showA) _handleToggle();
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Date B Selector
        _buildDateSelector(
          label: 'Data B (Final)',
          value: _dateB,
          items: dates,
          onChanged: _updateDateB,
          isActive: !_showA,
          color: Colors.orange,
        ),

        const SizedBox(height: 24),

        const Divider(),

        if (_dateA != null && _dateB != null) ...[
          Text('Resumo', style: AppTypography.h4),
          const SizedBox(height: 8),
          Text(
            'Comparando ${DateFormat('dd/MM/yyyy').format(_dateA!)} com ${DateFormat('dd/MM/yyyy').format(_dateB!)}.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.grey),
          ),
          // We could add diff stats here if available
        ],
      ],
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? value,
    required List<DateTime> items,
    required ValueChanged<DateTime?> onChanged,
    required bool isActive,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: isActive ? color : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          DropdownButton<DateTime>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(DateFormat('dd/MM/yyyy').format(d)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}
