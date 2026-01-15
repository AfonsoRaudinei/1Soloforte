import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';

part 'visit.freezed.dart';

enum VisitStatus { ongoing, completed, synced }

@freezed
class Visit with _$Visit {
  const factory Visit({
    required String id,
    required Client client,
    required DateTime checkInTime,
    DateTime? checkOutTime,
    required double latitude,
    required double longitude,
    String? checkOutNotes,
    String? areaName,
    String? areaId,
    String? activityType,
    String? checkInNotes,
    @Default([]) List<String> photos,
    @Default([]) List<String> occurrenceIds,
    @Default({}) Map<String, bool> checklist,
    @Default([]) List<LatLng> routePoints,
    @Default(0.0) double distanceTraveled,
    String? eventId,
    @Default(VisitStatus.ongoing) VisitStatus status,
  }) = _Visit;
}
