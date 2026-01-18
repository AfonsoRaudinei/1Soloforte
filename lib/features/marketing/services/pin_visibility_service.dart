import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';

/// Configuração de visibilidade de pins de Marketing no mapa.
///
/// Regras profissionais para evitar poluição visual:
/// - Zoom thresholds (obrigatório)
/// - Raio máximo de visualização (anti-espionagem agrícola)
/// - Contexto de fazenda/cliente
/// - Clustering inteligente
class PinVisibilityConfig {
  /// Zoom mínimo para começar a mostrar pins (modo cluster)
  static const double zoomMinCluster = 10.0;

  /// Zoom mínimo para mostrar pins individuais
  static const double zoomMinIndividual = 14.0;

  /// Zoom para modo extremamente simplificado
  static const double zoomExtreme = 8.0;

  /// Raio máximo de visualização em km (proteção regional)
  static const double maxRadiusKm = 50.0;

  /// Raio de prioridade quando há fazenda ativa (km)
  static const double farmContextRadiusKm = 15.0;

  /// Distância mínima entre pins para agrupar em cluster (em metros)
  static const double clusterDistanceMeters = 500.0;

  /// Número máximo de pins visíveis antes de forçar cluster
  static const int maxVisiblePins = 20;
}

/// Resultado da análise de visibilidade de um pin
class PinVisibilityResult {
  /// Se o pin deve ser visível
  final bool isVisible;

  /// Motivo da visibilidade/invisibilidade (para debug)
  final String reason;

  /// Nível de detalhe do pin (0 = escondido, 1 = cluster, 2 = simplificado, 3 = completo)
  final int detailLevel;

  /// Se o pin deve fazer parte de um cluster
  final bool shouldCluster;

  const PinVisibilityResult({
    required this.isVisible,
    required this.reason,
    this.detailLevel = 0,
    this.shouldCluster = false,
  });

  static const hidden = PinVisibilityResult(
    isVisible: false,
    reason: 'Zoom muito baixo',
    detailLevel: 0,
  );

  static const clusterMode = PinVisibilityResult(
    isVisible: true,
    reason: 'Modo cluster',
    detailLevel: 1,
    shouldCluster: true,
  );

  static const simplified = PinVisibilityResult(
    isVisible: true,
    reason: 'Zoom médio',
    detailLevel: 2,
  );

  static const full = PinVisibilityResult(
    isVisible: true,
    reason: 'Zoom alto',
    detailLevel: 3,
  );
}

/// Representa um cluster de pins agrupados
class PinCluster {
  /// Centro geográfico do cluster
  final LatLng center;

  /// Lista de pins no cluster
  final List<MarketingMapPost> pins;

  /// Label para exibição
  String get label => '${pins.length} cases';

  /// ID único do cluster baseado na posição
  String get id =>
      '${center.latitude.toStringAsFixed(4)}_${center.longitude.toStringAsFixed(4)}';

  const PinCluster({required this.center, required this.pins});
}

/// Serviço responsável pela visibilidade inteligente de pins de Marketing
class PinVisibilityService {
  const PinVisibilityService();

  /// Calcula a distância em km entre dois pontos usando fórmula de Haversine
  double calculateDistanceKm(LatLng from, LatLng to) {
    const radiusEarth = 6371.0; // km

    final dLat = _toRadians(to.latitude - from.latitude);
    final dLon = _toRadians(to.longitude - from.longitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(from.latitude)) *
            math.cos(_toRadians(to.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radiusEarth * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  /// Analisa a visibilidade de um único pin
  PinVisibilityResult analyzePin({
    required MarketingMapPost pin,
    required double currentZoom,
    required LatLng mapCenter,
    String? activeClientId,
    LatLng? activeFarmCenter,
  }) {
    // 1️⃣ REGRA DE ZOOM (obrigatório)
    if (currentZoom < PinVisibilityConfig.zoomMinCluster) {
      return const PinVisibilityResult(
        isVisible: false,
        reason: 'Zoom < ${PinVisibilityConfig.zoomMinCluster} (visão regional)',
        detailLevel: 0,
      );
    }

    // 2️⃣ REGRA DE RAIO MÁXIMO (anti-espionagem agrícola)
    final pinLocation = LatLng(pin.latitude, pin.longitude);
    final distanceFromCenter = calculateDistanceKm(mapCenter, pinLocation);

    if (distanceFromCenter > PinVisibilityConfig.maxRadiusKm) {
      return PinVisibilityResult(
        isVisible: false,
        reason:
            'Fora do raio máximo (${distanceFromCenter.toStringAsFixed(1)} km > ${PinVisibilityConfig.maxRadiusKm} km)',
        detailLevel: 0,
      );
    }

    // 3️⃣ REGRA DE CONTEXTO DE FAZENDA
    if (activeClientId != null && pin.client != null) {
      // Prioridade absoluta: pins do mesmo cliente
      if (pin.client == activeClientId) {
        return _getDetailLevelForZoom(currentZoom, 'Mesmo cliente');
      }
    }

    if (activeFarmCenter != null) {
      final distanceFromFarm = calculateDistanceKm(
        activeFarmCenter,
        pinLocation,
      );

      // Dentro do buffer da fazenda
      if (distanceFromFarm <= PinVisibilityConfig.farmContextRadiusKm) {
        return _getDetailLevelForZoom(currentZoom, 'Próximo da fazenda ativa');
      }

      // Fora do contexto da fazenda - esconder se zoom médio
      if (currentZoom < PinVisibilityConfig.zoomMinIndividual) {
        return PinVisibilityResult(
          isVisible: false,
          reason: 'Fora do contexto da fazenda e zoom insuficiente',
          detailLevel: 0,
        );
      }
    }

    // 4️⃣ NÍVEL DE DETALHE BASEADO NO ZOOM
    return _getDetailLevelForZoom(currentZoom, 'Visível por zoom');
  }

  /// Retorna o nível de detalhe apropriado para o zoom
  PinVisibilityResult _getDetailLevelForZoom(double zoom, String baseReason) {
    if (zoom >= PinVisibilityConfig.zoomMinIndividual) {
      return PinVisibilityResult(
        isVisible: true,
        reason: '$baseReason - zoom alto (completo)',
        detailLevel: 3,
      );
    }

    if (zoom >= PinVisibilityConfig.zoomMinCluster) {
      return PinVisibilityResult(
        isVisible: true,
        reason: '$baseReason - zoom médio (cluster)',
        detailLevel: 1,
        shouldCluster: true,
      );
    }

    return PinVisibilityResult.hidden;
  }

  /// Filtra e agrupa pins visíveis com base nas regras
  FilteredPinsResult filterAndClusterPins({
    required List<MarketingMapPost> allPins,
    required double currentZoom,
    required LatLng mapCenter,
    String? activeClientId,
    LatLng? activeFarmCenter,
  }) {
    final visiblePins = <MarketingMapPost>[];
    final clusters = <PinCluster>[];
    final hiddenCount = <String, int>{};

    // Primeiro, analisar cada pin
    final analyzed = <MarketingMapPost, PinVisibilityResult>{};

    for (final pin in allPins) {
      final result = analyzePin(
        pin: pin,
        currentZoom: currentZoom,
        mapCenter: mapCenter,
        activeClientId: activeClientId,
        activeFarmCenter: activeFarmCenter,
      );

      analyzed[pin] = result;

      if (!result.isVisible) {
        hiddenCount[result.reason] = (hiddenCount[result.reason] ?? 0) + 1;
      }
    }

    // Separar pins que precisam de cluster
    final needsClustering = <MarketingMapPost>[];
    final showIndividually = <MarketingMapPost>[];

    for (final entry in analyzed.entries) {
      if (entry.value.isVisible) {
        if (entry.value.shouldCluster) {
          needsClustering.add(entry.key);
        } else {
          showIndividually.add(entry.key);
        }
      }
    }

    // Agrupar pins que precisam de cluster
    if (needsClustering.isNotEmpty) {
      final clustered = _clusterPins(needsClustering);
      clusters.addAll(clustered);
    }

    // Limitar quantidade de pins individuais
    if (showIndividually.length > PinVisibilityConfig.maxVisiblePins) {
      // Priorizar pins do cliente ativo ou mais recentes
      showIndividually.sort((a, b) {
        // Cliente ativo primeiro
        if (activeClientId != null) {
          if (a.client == activeClientId && b.client != activeClientId)
            return -1;
          if (b.client == activeClientId && a.client != activeClientId)
            return 1;
        }
        // Depois por data de criação (mais recentes primeiro)
        return b.createdAt.compareTo(a.createdAt);
      });

      visiblePins.addAll(
        showIndividually.take(PinVisibilityConfig.maxVisiblePins),
      );

      // Os que não couberam viram cluster
      final overflow = showIndividually
          .skip(PinVisibilityConfig.maxVisiblePins)
          .toList();
      if (overflow.isNotEmpty) {
        clusters.addAll(_clusterPins(overflow));
      }
    } else {
      visiblePins.addAll(showIndividually);
    }

    return FilteredPinsResult(
      visiblePins: visiblePins,
      clusters: clusters,
      totalFiltered:
          allPins.length -
          visiblePins.length -
          clusters.fold(0, (sum, c) => sum + c.pins.length),
      hiddenReasons: hiddenCount,
    );
  }

  /// Agrupa pins próximos em clusters
  List<PinCluster> _clusterPins(List<MarketingMapPost> pins) {
    if (pins.isEmpty) return [];
    if (pins.length == 1) {
      return [
        PinCluster(
          center: LatLng(pins.first.latitude, pins.first.longitude),
          pins: pins,
        ),
      ];
    }

    final clusters = <PinCluster>[];
    final processed = <MarketingMapPost>{};

    for (final pin in pins) {
      if (processed.contains(pin)) continue;

      final pinLocation = LatLng(pin.latitude, pin.longitude);
      final nearby = <MarketingMapPost>[pin];
      processed.add(pin);

      // Encontrar pins próximos
      for (final other in pins) {
        if (processed.contains(other)) continue;

        final otherLocation = LatLng(other.latitude, other.longitude);
        final distance =
            calculateDistanceKm(pinLocation, otherLocation) * 1000; // metros

        if (distance <= PinVisibilityConfig.clusterDistanceMeters) {
          nearby.add(other);
          processed.add(other);
        }
      }

      // Calcular centro do cluster
      double sumLat = 0;
      double sumLng = 0;
      for (final p in nearby) {
        sumLat += p.latitude;
        sumLng += p.longitude;
      }

      clusters.add(
        PinCluster(
          center: LatLng(sumLat / nearby.length, sumLng / nearby.length),
          pins: nearby,
        ),
      );
    }

    return clusters;
  }

  /// Obtém a configuração de MarkerZoomConfig baseada no zoom
  MarkerZoomLevel getMarkerZoomLevel(double zoom) {
    if (zoom >= PinVisibilityConfig.zoomMinIndividual) {
      return MarkerZoomLevel.full;
    }
    if (zoom >= PinVisibilityConfig.zoomMinCluster) {
      return MarkerZoomLevel.simplified;
    }
    if (zoom >= PinVisibilityConfig.zoomExtreme) {
      return MarkerZoomLevel.extreme;
    }
    return MarkerZoomLevel.hidden;
  }
}

/// Resultado do filtro e clustering de pins
class FilteredPinsResult {
  /// Pins que devem ser mostrados individualmente
  final List<MarketingMapPost> visiblePins;

  /// Clusters de pins agrupados
  final List<PinCluster> clusters;

  /// Total de pins filtrados (não visíveis)
  final int totalFiltered;

  /// Motivos dos pins escondidos (para debug)
  final Map<String, int> hiddenReasons;

  const FilteredPinsResult({
    required this.visiblePins,
    required this.clusters,
    required this.totalFiltered,
    required this.hiddenReasons,
  });

  /// Total de pins visíveis (individuais + em clusters)
  int get totalVisible =>
      visiblePins.length + clusters.fold(0, (sum, c) => sum + c.pins.length);

  /// Tem clusters para mostrar?
  bool get hasClusters => clusters.isNotEmpty;
}

/// Níveis de zoom do marker
enum MarkerZoomLevel {
  /// Não mostrar
  hidden,

  /// Modo extremamente reduzido (só ponto)
  extreme,

  /// Modo simplificado (ícone pequeno)
  simplified,

  /// Modo completo (card com detalhes)
  full,
}
