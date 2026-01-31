import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/visit.dart';
import '../../domain/repositories/visit_repository.dart';
import '../data_sources/visit_local_data_source.dart';
import '../dtos/visit_dto.dart';

part 'visit_repository_impl.g.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitLocalDataSource _localDataSource;

  VisitRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveVisit(Visit visit) async {
    final dto = VisitDto.fromDomain(visit);
    await _localDataSource.saveVisit(dto);
  }

  @override
  Future<List<Visit>> getVisits() async {
    final dtos = await _localDataSource.getVisits();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Visit?> getActiveVisit() async {
    final dto = await _localDataSource.getActiveVisit();
    return dto?.toDomain();
  }

  @override
  Future<Visit?> getVisitById(String id) async {
    final dto = await _localDataSource.getVisitById(id);
    return dto?.toDomain();
  }
}

@Riverpod(keepAlive: true)
VisitRepository visitRepository(Ref ref) {
  // We can also provide the DataSource via a provider if we want more granularity
  return VisitRepositoryImpl(VisitLocalDataSourceImpl());
}
