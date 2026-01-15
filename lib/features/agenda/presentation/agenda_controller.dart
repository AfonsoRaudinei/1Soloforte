import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';

part 'agenda_controller.g.dart';

@riverpod
class AgendaController extends _$AgendaController {
  @override
  FutureOr<List<Event>> build() async {
    // Simulate initial API fetch
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockEvents();
  }

  Future<void> addEvent(Event event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network
      final currentEvents = state.value ?? [];
      return [...currentEvents, event];
    });
  }

  Future<void> updateEvent(Event updatedEvent) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      final currentEvents = state.value ?? [];

      // Business Rule: specific validation for in-progress events
      final existingIndex = currentEvents.indexWhere(
        (e) => e.id == updatedEvent.id,
      );
      if (existingIndex != -1) {
        final existing = currentEvents[existingIndex];
        if (existing.status == EventStatus.inProgress) {
          // check critical fields
          if (existing.type != updatedEvent.type ||
              existing.startTime != updatedEvent.startTime ||
              existing.endTime != updatedEvent.endTime ||
              existing.location != updatedEvent.location) {
            throw Exception(
              'Não é permitido alterar campos críticos de um evento em andamento.',
            );
          }
        }
      }

      return currentEvents
          .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
          .toList();
    });
  }

  Future<void> deleteEvent(String eventId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      final currentEvents = state.value ?? [];
      return currentEvents.where((e) => e.id != eventId).toList();
    });
  }

  List<Event> _getMockEvents() {
    return [
      Event(
        id: '1',
        title: 'Visita Técnica - Fazenda Santa Rita',
        description: 'Análise de solo e recomendação de adubação.',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        type: EventType.technicalVisit,
        location: 'Fazenda Santa Rita',
        status: EventStatus.scheduled,
        participants: ['João Silva', 'Maria Souza'],
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Event(
        id: '2',
        title: 'Aplicação de Defensivos',
        description: 'Supervisão de aplicação no Talhão 05.',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 12)),
        type: EventType.application,
        location: 'Talhão 05',
        status: EventStatus.scheduled,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Event(
        id: '3',
        title: 'Reunião Semanal',
        description: 'Alinhamento da equipe.',
        startTime: DateTime.now().subtract(const Duration(hours: 3)),
        endTime: DateTime.now().subtract(const Duration(hours: 1)),
        type: EventType.meeting,
        location: 'Escritório Central',
        status: EventStatus.completed,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    ];
  }
}

// -----------------------------------------------------------------------------
// FILTER LOGIC
// -----------------------------------------------------------------------------

class AgendaFilterState {
  final Set<EventType> types;
  final Set<EventStatus> statuses;

  AgendaFilterState({required this.types, required this.statuses});

  factory AgendaFilterState.initial() {
    return AgendaFilterState(
      types: EventType.values.toSet(),
      statuses: EventStatus.values.toSet(),
    );
  }

  AgendaFilterState copyWith({
    Set<EventType>? types,
    Set<EventStatus>? statuses,
  }) {
    return AgendaFilterState(
      types: types ?? this.types,
      statuses: statuses ?? this.statuses,
    );
  }

  bool isTypeSelected(EventType type) => types.contains(type);
  bool isStatusSelected(EventStatus status) => statuses.contains(status);
}

@riverpod
class AgendaFilter extends _$AgendaFilter {
  @override
  AgendaFilterState build() => AgendaFilterState.initial();

  void toggleType(EventType type) {
    final current = state.types;
    final newSet = Set<EventType>.from(current);
    if (newSet.contains(type)) {
      if (newSet.length > 1) newSet.remove(type); // Prevent empty? Or allow?
      // Convention: Filters often allow empty (showing nothing)
      // or if last one is unchecked, maybe recheck all?
      // Let's allow simple toggle.
    } else {
      newSet.add(type);
    }
    state = state.copyWith(types: newSet);
  }

  void toggleStatus(EventStatus status) {
    final current = state.statuses;
    final newSet = Set<EventStatus>.from(current);
    if (newSet.contains(status)) {
      newSet.remove(status);
    } else {
      newSet.add(status);
    }
    state = state.copyWith(statuses: newSet);
  }

  void reset() {
    state = AgendaFilterState.initial();
  }
}

@riverpod
AsyncValue<List<Event>> filteredAgenda(Ref ref) {
  final eventsAsync = ref.watch(agendaControllerProvider);
  final filter = ref.watch(agendaFilterProvider);

  return eventsAsync.whenData((events) {
    return events.where((e) {
      final matchesType = filter.types.contains(e.type);
      final matchesStatus = filter.statuses.contains(e.status);
      return matchesType && matchesStatus;
    }).toList();
  });
}
