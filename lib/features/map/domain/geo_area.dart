import 'package:latlong2/latlong.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_area.freezed.dart';
part 'geo_area.g.dart';

// Trigger rebuild

@freezed
abstract class GeoArea with _$GeoArea {
  const factory GeoArea({
    required String id,
    required String name,
    // ignore: invalid_annotation_target
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<LatLng> points,
    @Default([]) List<List<LatLng>> holes,
    @Default(0.0) double areaHectares,
    @Default(0.0) double perimeterKm,
    @Default(0.0) double radius,
    LatLng? center,
    @Default('polygon') String type, // polygon, circle, rectangle
    DateTime? createdAt,
    String? clientId,
    String? clientName,
    String? fieldId,
    String? fieldName,
    String? notes,
    int? colorValue,
    String? activeVisitId,
    DateTime? lastVisitDate,
    @Default(false) bool isDashed,
  }) = _GeoArea;

  factory GeoArea.fromJson(Map<String, dynamic> json) =>
      _$GeoAreaFromJson(json);
}
