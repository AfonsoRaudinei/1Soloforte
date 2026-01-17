import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_model.freezed.dart';
part 'area_model.g.dart';

@freezed
class Area with _$Area {
  const factory Area({
    required String id,
    required String name,
    required double hectares,
    @JsonKey(defaultValue: '') required String clientId,
    required String clienteNome,
    required String fazendaNome,
    @Default('active') String status, // active, monitoring, inactive
    required List<LatLng> coordinates,
    String? culture,
    String? safra,
    @Default(0.0) double ndviAverage,
    DateTime? lastUpdate,
  }) = _Area;

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  factory LatLng.fromJson(Map<String, dynamic> json) =>
      LatLng(json['latitude'] as double, json['longitude'] as double);
}
