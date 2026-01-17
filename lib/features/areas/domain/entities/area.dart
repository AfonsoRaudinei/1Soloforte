import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'area.freezed.dart';

@freezed
class Area with _$Area {
  const factory Area({
    required String id,
    required String name,
    required double hectares,
    required String clientId,
    required String clienteNome,
    required String fazendaNome,
    @Default('active') String status,
    required List<LatLng> coordinates,
    String? culture,
    String? safra,
    @Default(0.0) double ndviAverage,
    DateTime? lastUpdate,
  }) = _Area;
}
