import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/agenda/presentation/agenda_controller.dart';
import 'package:soloforte_app/features/agenda/presentation/weekly_planning_screen.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(filteredAgendaProvider);
    final filterState = ref.watch(agendaFilterProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Agenda'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: filterState.statuses.length < EventStatus.values.length
                  ? AppColors.primary
                  : null,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
          TextButton.icon(
            onPressed: () =>
                context.push('/dashboard/calendar/new', extra: _selectedDay),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Nova'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: eventsState.when(
        data: (allEvents) {
          final dailyEvents = allEvents
              .where((e) => isSameDay(e.startTime, _selectedDay))
              .toList();
          dailyEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

          return Column(
            children: [
              // Custom Month Navigation
              _buildMonthNavigator(),

              // Calendar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TableCalendar<Event>(
                    firstDay: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    currentDay: DateTime.now(),
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    headerVisible: false, // Using custom navigator
                    daysOfWeekHeight: 40,
                    rowHeight: 40,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape
                            .rectangle, // ASCII suggests boxy look? Or standard. Let's stick to circle/shape matching app theme but maybe cleaner.
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      defaultTextStyle: AppTypography.bodyMedium,
                      weekendTextStyle: AppTypography.bodyMedium.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        // Custom markers based on legend
                        // • = Visita (technicalVisit)
                        // ○ = Lembrete (reminder)
                        // ◆ = Aplicação (application)
                        if (events.isEmpty) return null;

                        // We show only the highest priority marker or a mix?
                        // The ASCII shows specific symbols. TableCalendar usually puts dots.
                        // Let's simplified: show up to 3 markers.
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: events.take(3).map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1.0,
                              ),
                              child: _buildMarkerIcon(e.type),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    eventLoader: (day) => allEvents
                        .where((e) => isSameDay(e.startTime, day))
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Legend (Interactive Type Filter)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegendItem(
                      '•',
                      'Visita agendada',
                      EventType.technicalVisit,
                      filterState.isTypeSelected(EventType.technicalVisit),
                    ),
                    _buildLegendItem(
                      '○',
                      'Lembrete',
                      EventType.reminder,
                      filterState.isTypeSelected(EventType.reminder),
                    ),
                    _buildLegendItem(
                      '◆',
                      'Aplicação',
                      EventType.application,
                      filterState.isTypeSelected(EventType.application),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Daily List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDayHeader(_selectedDay),
                    const SizedBox(height: 8),
                    if (dailyEvents.isEmpty) _buildEmptyState(),
                    ...dailyEvents.map(
                      (event) => _buildEventCard(context, event),
                    ),

                    const SizedBox(height: 24),
                    // Tomorrow preview if wanted, or just buttons
                    if (isSameDay(DateTime.now(), _selectedDay)) ...[
                      _buildDayHeader(
                        DateTime.now().add(const Duration(days: 1)),
                        labelPrefix: 'Amanhã',
                      ),
                      const SizedBox(height: 8),
                      // Future improvements: Show tomorrow's events here too
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDay = DateTime.now().add(
                                const Duration(days: 1),
                              );
                              _focusedDay = _selectedDay;
                            });
                          },
                          child: const Text('Ver eventos de amanhã'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _calendarFormat =
                                _calendarFormat == CalendarFormat.week
                                ? CalendarFormat.month
                                : CalendarFormat.week;
                          });
                        },
                        child: Text(
                          _calendarFormat == CalendarFormat.week
                              ? 'Ver Mês'
                              : 'Ver Semana',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WeeklyPlanningScreen(),
                            ),
                          );
                        },
                        child: const Text('Planejamento Semanal'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final filterState = ref.watch(agendaFilterProvider);
            return AlertDialog(
              title: const Text('Filtrar Status'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: EventStatus.values.map((status) {
                    return CheckboxListTile(
                      title: Text(_getStatusLabel(status)),
                      value: filterState.isStatusSelected(status),
                      onChanged: (_) {
                        ref
                            .read(agendaFilterProvider.notifier)
                            .toggleStatus(status);
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
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

  Widget _buildMonthNavigator() {
    final title = DateFormat('MMMM yyyy', 'pt_BR').format(_focusedDay);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            title.toUpperCase(),
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerIcon(EventType type) {
    // • = Visita agendada, ○ = Lembrete, ◆ = Aplicação
    // Mapping EventType to symbols roughly
    // Assuming EventType values.
    // technicalVisit -> •, application -> ◆, reminder -> ○
    if (type == EventType.technicalVisit) {
      return const Text(
        '•',
        style: TextStyle(color: Colors.blue, fontSize: 10),
      );
    }
    if (type == EventType.application) {
      return const Text('◆', style: TextStyle(color: Colors.red, fontSize: 8));
    }
    if (type == EventType.reminder) {
      return const Text('○', style: TextStyle(color: Colors.grey, fontSize: 8));
    }
    return const Text(
      '•',
      style: TextStyle(color: Colors.black, fontSize: 10),
    ); // Default
  }

  Widget _buildLegendItem(
    String symbol,
    String label,
    EventType type,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        ref.read(agendaFilterProvider.notifier).toggleType(type);
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(DateTime date, {String? labelPrefix}) {
    String label = DateFormat("dd/MMM/yyyy", 'pt_BR').format(date);
    String prefix =
        labelPrefix ??
        (isSameDay(date, DateTime.now())
            ? 'Hoje'
            : DateFormat('EEEE', 'pt_BR').format(date));
    // E.g. "Hoje - 28/Out/2025"
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$prefix - $label',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 2),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    //  │  ┌───────────────────────────┐  │
    //  │  │ 09:00 • Visita Técnica    │  │
    //  │  │ ─────────────────────     │  │
    //  │  │ 📍 João Silva             │  │
    //  │  │    Talhão Norte           │  │
    //  │  │ 🕐 09:00 - 11:00          │  │
    //  │  │                           │  │
    //  │  │ [Iniciar] [Ver Detalhes]  │  │
    //  │  └───────────────────────────┘  │

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Time + Title
          Row(
            children: [
              Text(
                DateFormat('HH:mm').format(event.startTime),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              _buildMarkerIcon(event.type),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.h4,
                ),
              ),
            ],
          ),
          const Divider(),
          // Content
          if (event.location.isNotEmpty)
            _buildIconText(
              Icons.location_on,
              event.location,
            ), // Producer name could be part of location or desc in this model
          const SizedBox(height: 4),
          _buildIconText(
            Icons.access_time,
            '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
          ),

          // Should add specific fields if we had them (Weather, etc per ASCII)
          const SizedBox(height: 12),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (event.type ==
                  EventType.technicalVisit) // Only show Iniciar for visits
                if (event.status == EventStatus.scheduled)
                  TextButton(
                    onPressed: () {
                      final updatedEvent = event.copyWith(
                        status: EventStatus.inProgress,
                        updatedAt: DateTime.now(),
                      );
                      ref
                          .read(agendaControllerProvider.notifier)
                          .updateEvent(updatedEvent);
                    },
                    child: const Text('Iniciar'),
                  )
                else if (event.status == EventStatus.inProgress)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Em andamento',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              TextButton(
                onPressed: () {
                  context.push('/dashboard/calendar/detail', extra: event);
                },
                child: const Text('Ver Detalhes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'Nenhum evento para este dia.',
          style: AppTypography.bodyMedium.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}

// Helper Widget for specific Card style
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  const CustomCard({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
