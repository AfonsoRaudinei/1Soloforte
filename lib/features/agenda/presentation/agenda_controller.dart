import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/agenda/data/agenda_repository.dart';

part 'agenda_controller.g.dart';

@riverpod
class AgendaController extends _$AgendaController {
  @override
  FutureOr<List<Event>> build() async {
    final repository = ref.watch(agendaRepositoryProvider);
    return repository.getEvents();
  }

  Future<void> addEvent(Event event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(agendaRepositoryProvider);
      await repository.addEvent(event);
      return repository.getEvents();
    });
  }

  Future<void> updateEvent(Event updatedEvent) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(agendaRepositoryProvider);
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

      await repository.updateEvent(updatedEvent);
      return repository.getEvents();
    });
  }

  Future<void> deleteEvent(String eventId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(agendaRepositoryProvider);
      await repository.deleteEvent(eventId);
      return repository.getEvents();
    });
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
