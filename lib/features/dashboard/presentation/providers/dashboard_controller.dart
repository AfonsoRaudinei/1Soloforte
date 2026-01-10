import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'dashboard_state.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  void toggleRadialMenu() {
    state = state.copyWith(isRadialMenuOpen: !state.isRadialMenuOpen);
  }

  void closeRadialMenu() {
    state = state.copyWith(isRadialMenuOpen: false);
  }

  void setMapLayer(String layer) {
    state = state.copyWith(mapLayer: layer);
  }

  void toggleWeatherRadar() {
    state = state.copyWith(isWeatherRadarVisible: !state.isWeatherRadarVisible);
  }

  void setTempPin(LatLng? pin) {
    state = state.copyWith(tempPin: pin);
  }
}
