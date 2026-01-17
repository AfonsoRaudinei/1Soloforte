import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/occurrence.dart';
import '../../domain/repositories/occurrence_repository.dart';
import '../data_sources/occurrence_local_data_source.dart';
import '../dtos/occurrence_dto.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

part 'occurrence_repository_impl.g.dart';

class OccurrenceRepositoryImpl implements OccurrenceRepository {
  final OccurrenceLocalDataSource _dataSource;

  OccurrenceRepositoryImpl(this._dataSource);

  @override
  Future<List<Occurrence>> getOccurrences() async {
    try {
      final dtos = await _dataSource.getOccurrences();
      return dtos.map((e) => e.toDomain()).toList();
    } catch (e, s) {
      LoggerService.e('Failed to get occurrences', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<Occurrence?> getOccurrenceById(String id) async {
    try {
      final dto = await _dataSource.getOccurrenceById(id);
      return dto?.toDomain();
    } catch (e, s) {
      LoggerService.e('Failed to get occurrence $id', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> createOccurrence(Occurrence occurrence) async {
    try {
      if (occurrence.clientId.isEmpty) {
        throw StateError('clientId obrigatório para criar ocorrência.');
      }
      LoggerService.i('Creating occurrence: ${occurrence.id}');
      await _dataSource.saveOccurrence(OccurrenceDto.fromDomain(occurrence));
    } catch (e, s) {
      LoggerService.e('Failed to create occurrence', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> updateOccurrence(Occurrence occurrence) async {
    try {
      if (occurrence.clientId.isEmpty) {
        throw StateError('clientId obrigatório para atualizar ocorrência.');
      }
      LoggerService.i('Updating occurrence: ${occurrence.id}');
      await _dataSource.saveOccurrence(OccurrenceDto.fromDomain(occurrence));
    } catch (e, s) {
      LoggerService.e('Failed to update occurrence', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> deleteOccurrence(String id) async {
    try {
      LoggerService.w('Deleting occurrence: $id');
      await _dataSource.deleteOccurrence(id);
    } catch (e, s) {
      LoggerService.e('Failed to delete occurrence', error: e, stackTrace: s);
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
OccurrenceRepository occurrenceRepository(OccurrenceRepositoryRef ref) {
  return OccurrenceRepositoryImpl(OccurrenceLocalDataSourceImpl());
}
