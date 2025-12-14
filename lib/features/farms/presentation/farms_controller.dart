import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/farm_model.dart';
import '../data/farms_repository.dart';

part 'farms_controller.g.dart';

@riverpod
class FarmsController extends _$FarmsController {
  @override
  Future<List<Farm>> build() {
    return ref.read(farmsRepositoryProvider).getFarms();
  }

  Future<void> addFarm(Farm farm) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(farmsRepositoryProvider).addFarm(farm);
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, farm]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateFarm(Farm farm) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(farmsRepositoryProvider).updateFarm(farm);
      final currentList = state.value ?? [];
      final updatedList = currentList
          .map((f) => f.id == farm.id ? farm : f)
          .toList();
      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteFarm(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(farmsRepositoryProvider).deleteFarm(id);
      final currentList = state.value ?? [];
      final updatedList = currentList.where((f) => f.id != id).toList();
      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<Farm> filterByClient(String clientId) {
    final farms = state.value ?? [];
    return farms.where((f) => f.clientId == clientId).toList();
  }
}

@riverpod
Future<List<Farm>> farmsByClient(FarmsByClientRef ref, String clientId) {
  return ref.read(farmsRepositoryProvider).getFarmsByClientId(clientId);
}

@riverpod
Future<Farm?> farmById(FarmByIdRef ref, String id) {
  return ref.read(farmsRepositoryProvider).getFarmById(id);
}
