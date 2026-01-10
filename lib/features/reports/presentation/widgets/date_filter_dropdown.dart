import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/reports/application/date_filter_provider.dart';
import 'package:intl/intl.dart';

class DateFilterDropdown extends ConsumerWidget {
  final VoidCallback? onFilterChanged;

  const DateFilterDropdown({super.key, this.onFilterChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(dateFilterProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateRangeFilter>(
          value: filterState.filter,
          icon: const Icon(Icons.calendar_today, size: 16),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: DateRangeFilter.values.map((filter) {
            return DropdownMenuItem(value: filter, child: Text(filter.label));
          }).toList(),
          onChanged: (DateRangeFilter? newFilter) async {
            if (newFilter == null) return;

            if (newFilter == DateRangeFilter.custom) {
              // Show date range picker
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(
                  start: filterState.dateRange.start,
                  end: filterState.dateRange.end,
                ),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                ref
                    .read(dateFilterProvider.notifier)
                    .setCustomRange(picked.start, picked.end);
                onFilterChanged?.call();
              }
            } else {
              ref.read(dateFilterProvider.notifier).setFilter(newFilter);
              onFilterChanged?.call();
            }
          },
        ),
      ),
    );
  }
}

class DateFilterChip extends ConsumerWidget {
  const DateFilterChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(dateFilterProvider);
    final dateRange = filterState.dateRange;

    String displayText;
    if (filterState.filter == DateRangeFilter.custom) {
      displayText =
          '${DateFormat('dd/MM').format(dateRange.start)} - ${DateFormat('dd/MM').format(dateRange.end)}';
    } else {
      displayText = filterState.filter.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.date_range,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
