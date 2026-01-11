import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'dashboard_state.freezed.dart';

/// Modos de interação do mapa
/// Apenas um modo pode estar ativo por vez
enum MapMode {
  /// Navegação livre, sem interação especial
  neutral,

  /// Seleção de ponto para registro de ocorrência
  occurrence,

  /// Seleção de ponto para ação de marketing
  marketing,

  /// Modo de desenho de áreas/polígonos
  drawing,
}

/// Extensão para obter nome amigável do modo
extension MapModeExtension on MapMode {
  String get displayName {
    switch (this) {
      case MapMode.neutral:
        return '';
      case MapMode.occurrence:
        return 'Ocorrência';
      case MapMode.marketing:
        return 'Marketing';
      case MapMode.drawing:
        return 'Desenhar';
    }
  }

  bool get isActive => this != MapMode.neutral;
}

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool isRadialMenuOpen,
    @Default('standard') String mapLayer,
    @Default(false) bool isWeatherRadarVisible,
    LatLng? tempPin,

    /// Modo ativo do mapa - apenas um por vez
    @Default(MapMode.neutral) MapMode activeMode,
    // Mantido para retrocompatibilidade - será derivado do activeMode
    @Default('none') String pinSelectionMode,
  }) = _DashboardState;
}
