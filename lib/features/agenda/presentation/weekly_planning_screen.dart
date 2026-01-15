import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/agenda/presentation/agenda_controller.dart';
import 'package:soloforte_app/features/agenda/presentation/event_form_screen.dart';

const bool kEnablePlanningEdit = true; // Feature Flag

class WeeklyPlanningScreen extends ConsumerWidget {
  const WeeklyPlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(filteredAgendaProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7), // slightly more neutral
      appBar: AppBar(
        title: const Text('Planejamento Semanal'),
        centerTitle: true,
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        scrolledUnderElevation: 0,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        titleTextStyle: AppTypography.h4.copyWith(
          color: const Color(0xFF1D1D1F),
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1F)),
        actions: [
          if (kEnablePlanningEdit)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EventFormScreen(),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) => _buildContent(context, events),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Event> events) {
    // 1. Filter/Group Data
    final now = DateTime.now();
    // Start of week (Sunday)
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    // Week range: next 7 days
    final weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    // Group events by date (ignoring time)
    final eventsByDate = <DateTime, List<Event>>{};
    for (var date in weekDates) {
      final dailyEvents = events
          .where((e) => isSameDay(e.startTime, date))
          .toList();
      dailyEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
      eventsByDate[date] = dailyEvents;
    }

    // Stats
    final totalEvents = eventsByDate.values.fold(
      0,
      (sum, list) => sum + list.length,
    );
    final weekInternalLabel =
        '${DateFormat('dd/MMM', 'pt_BR').format(startOfWeek)} a ${DateFormat('dd/MMM', 'pt_BR').format(startOfWeek.add(const Duration(days: 6)))}';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 2. Header
          _WeeklyHeader(eventsCount: totalEvents, weekLabel: weekInternalLabel),
          const SizedBox(height: 24),

          // 3. Days List
          ...weekDates.map((date) {
            final dailyEvents = eventsByDate[date] ?? [];
            return _DayCard(date: date, events: dailyEvents);
          }),

          // Bottom padding
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _WeeklyHeader extends StatelessWidget {
  final int eventsCount;
  final String weekLabel;

  const _WeeklyHeader({required this.eventsCount, required this.weekLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildRow('CONSULTOR', 'Consultor SoloForte'),
                const Divider(height: 24, thickness: 0.5),
                _buildRow('SEMANA', weekLabel.toUpperCase()),
                const SizedBox(height: 12),
                _buildRow('TOTAL VISITAS', '$eventsCount planejadas'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatefulWidget {
  final DateTime date;
  final List<Event> events;

  const _DayCard({required this.date, required this.events});

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isSunday = widget.date.weekday == DateTime.sunday;
    final dayName = DateFormat('EEEE', 'pt_BR').format(widget.date);
    final dateStr = DateFormat('dd/MM').format(widget.date);
    final formattedDayName = dayName[0].toUpperCase() + dayName.substring(1);

    // Style variables
    final backgroundColor = isSunday
        ? const Color(0xFF0F172A) // Dark slate for Sunday
        : Colors.white;
    final textColor = isSunday ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isSunday
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF64748B);
    final borderColor = isSunday ? Colors.transparent : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSunday
                          ? Colors.white.withValues(alpha: 0.15)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dateStr.split('/')[0],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        if (widget.events.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${widget.events.length} atividades',
                              style: TextStyle(
                                fontSize: 13,
                                color: subTextColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: subTextColor,
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      children: [
                        if (widget.events.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Nenhuma visita agendada',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          ...widget.events.map(
                            (e) => _EventCard(event: e, isSunday: isSunday),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  final Event event;
  final bool isSunday;

  const _EventCard({required this.event, required this.isSunday});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final curContext = context;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Excluir Evento'),
          content: const Text('Tem certeza que deseja excluir este evento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && curContext.mounted) {
      ref.read(agendaControllerProvider.notifier).deleteEvent(event.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = DateFormat('HH:mm').format(event.startTime);
    final endTime = DateFormat('HH:mm').format(event.endTime);

    // Status color
    final statusColor = _getStatusColor(event.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSunday ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSunday ? Colors.white10 : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              Column(
                children: [
                  Text(
                    startTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSunday ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    endTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSunday
                          ? Colors.white54
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Status Line
              Container(
                width: 3,
                height: 38,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Title & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isSunday
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (event.clientName != null || event.location.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: isSunday
                                ? Colors.white54
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.clientName ?? event.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSunday
                                    ? Colors.white54
                                    : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStatusLabel(event.status).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          if (kEnablePlanningEdit) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, thickness: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  label: 'Excluir',
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFEF4444),
                  onTap: () => _confirmDelete(context, ref),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  label: 'Editar',
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF64748B),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventFormScreen(event: event),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.scheduled:
        return const Color(0xFF10B981); // Emerald Green
      case EventStatus.inProgress:
        return const Color(0xFF3B82F6); // Blue
      case EventStatus.completed:
        return const Color(0xFF0F766E); // Teal
      case EventStatus.cancelled:
        return const Color(0xFFEF4444); // Red
      case EventStatus.rescheduled:
        return const Color(0xFFF59E0B); // Amber
    }
  }

  String _getStatusLabel(EventStatus status) {
    switch (status) {
      case EventStatus.scheduled:
        return 'Planejado';
      case EventStatus.inProgress:
        return 'Em Andamento';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
      case EventStatus.rescheduled:
        return 'Reagendado';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
