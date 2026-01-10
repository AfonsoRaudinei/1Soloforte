import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool isRadialMenuOpen,
    @Default('standard') String mapLayer,
    @Default(false) bool isWeatherRadarVisible,
    LatLng? tempPin,
  }) = _DashboardState;
}
