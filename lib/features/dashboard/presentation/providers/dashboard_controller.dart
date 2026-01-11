import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'dashboard_state.dart';

import 'package:soloforte_app/core/services/analytics_service.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  // ... (rest of the file until setMode)

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

  // =========================================================
  // SISTEMA UNIFICADO DE MODOS DO MAPA
  // Apenas um modo pode estar ativo por vez
  // =========================================================

  /// Ativa um modo específico, desativando qualquer outro modo ativo
  /// Se o modo já estiver ativo, retorna ao modo neutro (toggle)
  void setMode(MapMode mode) {
    if (state.activeMode == mode) {
      // Toggle: se já está ativo, volta para neutro
      _resetToNeutral();
    } else {
      // Analytics Tracking
      if (mode == MapMode.occurrence) {
        _analytics.startFlow('occurrence_flow');
        _analytics.logEvent('occurrence_mode_activated');
      }

      // Ativa o novo modo, desativando o anterior
      state = state.copyWith(
        activeMode: mode,
        tempPin: null, // Limpa pin temporário ao trocar de modo
        pinSelectionMode: _mapModeToString(mode),
      );
    }
  }

  /// Retorna ao modo neutro
  void _resetToNeutral() {
    state = state.copyWith(
      activeMode: MapMode.neutral,
      tempPin: null,
      pinSelectionMode: 'none',
    );
  }

  /// Converte MapMode para string (retrocompatibilidade)
  String _mapModeToString(MapMode mode) {
    switch (mode) {
      case MapMode.neutral:
        return 'none';
      case MapMode.occurrence:
        return 'occurrence';
      case MapMode.marketing:
        return 'marketing';
      case MapMode.drawing:
        return 'drawing';
    }
  }

  /// Inicia o fluxo de ocorrência
  /// Se já estiver em modo ocorrência, desativa (toggle)
  void startOccurrenceFlow() {
    setMode(MapMode.occurrence);
  }

  /// Inicia o fluxo de marketing
  /// Se já estiver em modo marketing, desativa (toggle)
  void startMarketingFlow() {
    setMode(MapMode.marketing);
  }

  /// Inicia o modo de desenho
  /// Se já estiver em modo desenho, desativa (toggle)
  void startDrawingMode() {
    setMode(MapMode.drawing);
  }

  /// Cancela qualquer seleção de pin e retorna ao modo neutro
  void cancelPinSelection() {
    _resetToNeutral();
  }

  /// Verifica se um modo específico está ativo
  bool isModeActive(MapMode mode) => state.activeMode == mode;

  /// Retorna true se qualquer modo (exceto neutro) estiver ativo
  bool get hasActiveMode => state.activeMode.isActive;

  // Mantido para retrocompatibilidade
  @Deprecated('Use setMode(MapMode.occurrence) instead')
  void setPinSelectionMode(String mode) {
    switch (mode) {
      case 'occurrence':
        setMode(MapMode.occurrence);
        break;
      case 'marketing':
        setMode(MapMode.marketing);
        break;
      default:
        setMode(MapMode.neutral);
    }
  }
}
