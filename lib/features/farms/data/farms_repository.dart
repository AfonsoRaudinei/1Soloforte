import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/farm_model.dart';

part 'farms_repository.g.dart';

abstract class FarmsRepository {
  Future<List<Farm>> getFarms();
  Future<List<Farm>> getFarmsByClientId(String clientId);
  Future<Farm?> getFarmById(String id);
  Future<void> addFarm(Farm farm);
  Future<void> updateFarm(Farm farm);
  Future<void> deleteFarm(String id);
}

class MockFarmsRepository implements FarmsRepository {
  final List<Farm> _farms = [
    Farm(
      id: '1',
      clientId: '1',
      name: 'Fazenda Santa Rita - Sede',
      city: 'Ribeirão Preto',
      state: 'SP',
      address: 'Rod. SP-330, km 300',
      totalAreaHa: 1500.0,
      totalAreas: 8,
      description: 'Fazenda principal com cultivo de soja e milho',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Farm(
      id: '2',
      clientId: '1',
      name: 'Fazenda Santa Rita - Anexo',
      city: 'Sertãozinho',
      state: 'SP',
      address: 'Zona Rural',
      totalAreaHa: 1000.0,
      totalAreas: 4,
      description: 'Área de expansão com cana-de-açúcar',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Farm(
      id: '3',
      clientId: '2',
      name: 'Fazenda Boa Vista',
      city: 'Rio Verde',
      state: 'GO',
      address: 'Zona Rural, Rio Verde - GO',
      totalAreaHa: 800.5,
      totalAreas: 5,
      description: 'Produção de grãos',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<Farm>> getFarms() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [..._farms];
  }

  @override
  Future<List<Farm>> getFarmsByClientId(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _farms.where((f) => f.clientId == clientId).toList();
  }

  @override
  Future<Farm?> getFarmById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _farms.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addFarm(Farm farm) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _farms.add(farm);
  }

  @override
  Future<void> updateFarm(Farm farm) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _farms.indexWhere((f) => f.id == farm.id);
    if (index != -1) {
      _farms[index] = farm;
    }
  }

  @override
  Future<void> deleteFarm(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _farms.removeWhere((f) => f.id == id);
  }
}

@Riverpod(keepAlive: true)
FarmsRepository farmsRepository(FarmsRepositoryRef ref) {
  return MockFarmsRepository();
}
