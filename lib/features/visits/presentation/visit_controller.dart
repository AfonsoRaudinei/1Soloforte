import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/entities/visit.dart';
import '../data/repositories/visit_repository_impl.dart';
import '../../clients/domain/client_model.dart';

part 'visit_controller.g.dart';

@Riverpod(keepAlive: true)
class VisitController extends _$VisitController {
  @override
  Future<Visit?> build() async {
    // Load active visit from local database on startup
    return ref.read(visitRepositoryProvider).getActiveVisit();
  }

  Future<void> checkIn({
    required Client client,
    String? areaName,
    String? areaId,
    String? activityType,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      // Check service enabled? (Optional: Geolocator.isLocationServiceEnabled())

      final position = await Geolocator.getCurrentPosition();

      final newVisit = Visit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        client: client,
        checkInTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        status: VisitStatus.ongoing,
        areaName: areaName,
        areaId: areaId,
        activityType: activityType,
        checkInNotes: notes,
      );

      await ref.read(visitRepositoryProvider).saveVisit(newVisit);
      state = AsyncData(newVisit);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      throw Exception('Failed to check in: $e');
    }
  }

  Future<void> addPhoto(String path) async {
    final currentVisit = state.value;
    if (currentVisit == null) return;

    // Optimistic update
    final updatedVisit = currentVisit.copyWith(
      photos: [...currentVisit.photos, path],
    );
    state = AsyncData(updatedVisit);

    try {
      await ref.read(visitRepositoryProvider).saveVisit(updatedVisit);
    } catch (e, stack) {
      // Revert on error? Or just show error
      state = AsyncError(e, stack);
    }
  }

  Future<void> checkOut({String? notes, Map<String, bool>? checklist}) async {
    final currentVisit = state.value;
    if (currentVisit == null) return;

    state = const AsyncLoading();
    try {
      final completedVisit = currentVisit.copyWith(
        checkOutTime: DateTime.now(),
        status: VisitStatus.completed,
        checkOutNotes: notes,
        checklist: checklist ?? {},
      );

      await ref.read(visitRepositoryProvider).saveVisit(completedVisit);
      state = const AsyncData(null); // Clear active visit
    } catch (e, stack) {
      state = AsyncError(e, stack);
      throw Exception('Failed to check out: $e');
    }
  }
}
