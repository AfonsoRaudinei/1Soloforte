import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/area.dart';

part 'area_dto.freezed.dart';
part 'area_dto.g.dart';

List<LatLng> _latLngListFromJson(List<dynamic> list) {
  return list.map((e) {
    if (e is Map<String, dynamic>) {
      return LatLng(
        (e['latitude'] as num).toDouble(),
        (e['longitude'] as num).toDouble(),
      );
    }
    return const LatLng(0, 0);
  }).toList();
}

List<Map<String, dynamic>> _latLngListToJson(List<LatLng> list) {
  return list
      .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
      .toList();
}

@freezed
class AreaDto with _$AreaDto {
  const AreaDto._();

  const factory AreaDto({
    required String id,
    required String name,
    required double hectares,
    String? clientId,
    required String clienteNome,
    required String fazendaNome,
    @Default('active') String status,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
    required List<LatLng> coordinates,
    String? culture,
    String? safra,
    @Default(0.0) double ndviAverage,
    DateTime? lastUpdate,
  }) = _AreaDto;

  factory AreaDto.fromJson(Map<String, dynamic> json) =>
      _$AreaDtoFromJson(json);

  factory AreaDto.fromDomain(Area area) {
    return AreaDto(
      id: area.id,
      name: area.name,
      hectares: area.hectares,
      clientId: area.clientId,
      clienteNome: area.clienteNome,
      fazendaNome: area.fazendaNome,
      status: area.status,
      coordinates: area.coordinates,
      culture: area.culture,
      safra: area.safra,
      ndviAverage: area.ndviAverage,
      lastUpdate: area.lastUpdate,
    );
  }

  Area toDomain() {
    return Area(
      id: id,
      name: name,
      hectares: hectares,
      clientId: clientId,
      clienteNome: clienteNome,
      fazendaNome: fazendaNome,
      status: status,
      coordinates: coordinates,
      culture: culture,
      safra: safra,
      ndviAverage: ndviAverage,
      lastUpdate: lastUpdate,
    );
  }
}
