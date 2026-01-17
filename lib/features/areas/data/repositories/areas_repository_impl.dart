import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/area.dart';
import '../../domain/repositories/areas_repository.dart';
import '../data_sources/areas_local_data_source.dart';
import '../dtos/area_dto.dart';

part 'areas_repository_impl.g.dart';

class AreasRepositoryImpl implements AreasRepository {
  final AreasLocalDataSource _dataSource;

  AreasRepositoryImpl(this._dataSource);

  @override
  Future<void> saveArea(Area area) async {
    if (area.clientId.isEmpty) {
      throw StateError('clientId obrigatório para salvar área.');
    }
    await _dataSource.saveArea(AreaDto.fromDomain(area));
  }

  @override
  Future<List<Area>> getAreas() async {
    final dtos = await _dataSource.getAreas();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Area?> getAreaById(String id) async {
    final dto = await _dataSource.getAreaById(id);
    return dto?.toDomain();
  }
}

@Riverpod(keepAlive: true)
AreasRepository areasRepository(AreasRepositoryRef ref) {
  return AreasRepositoryImpl(AreasLocalDataSourceImpl());
}
