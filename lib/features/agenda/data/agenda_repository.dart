import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'agenda_local_data_source.dart';

part 'agenda_repository.g.dart';

abstract class AgendaRepository {
  Future<List<Event>> getEvents();
  Future<void> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}

class AgendaRepositoryImpl implements AgendaRepository {
  final AgendaLocalDataSource _localDataSource;

  AgendaRepositoryImpl(this._localDataSource);

  @override
  Future<List<Event>> getEvents() => _localDataSource.getEvents();

  @override
  Future<void> addEvent(Event event) => _localDataSource.upsertEvent(event);

  @override
  Future<void> updateEvent(Event event) => _localDataSource.upsertEvent(event);

  @override
  Future<void> deleteEvent(String id) => _localDataSource.deleteEvent(id);
}

@Riverpod(keepAlive: true)
AgendaRepository agendaRepository(AgendaRepositoryRef ref) {
  return AgendaRepositoryImpl(AgendaLocalDataSourceImpl());
}
