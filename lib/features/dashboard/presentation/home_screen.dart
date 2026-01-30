import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/constants/map_zoom_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
// Conditional import for dart:io (not available on Web)
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_pin_marker_io.dart'
    if (dart.library.html) 'package:soloforte_app/features/marketing/presentation/widgets/marketing_pin_marker_web.dart'
    as platform_image;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/areas/presentation/providers/areas_controller.dart';
import 'package:soloforte_app/features/areas/domain/entities/area.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/map/presentation/widgets/drawing_toolbar.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/visits/domain/entities/visit.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/check_in_modal.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/check_out_modal.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/active_visit_overlay.dart';

import 'widgets/online_status_badge.dart';
import 'package:soloforte_app/features/weather/presentation/widgets/weather_radar.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_selection_provider.dart';
// DEPRECATED: Modal antigo removido, usar rota /map/marketing/edit
// import 'package:soloforte_app/features/marketing/presentation/widgets/new_case_modal.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_pin_marker.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_cluster_marker.dart';
import 'package:soloforte_app/features/marketing/services/pin_visibility_service.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_publication_sheet_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_publication_sheet_listener.dart';
import 'package:soloforte_app/features/marketing/presentation/services/marketing_interaction_tracker.dart';

import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_sheet_listener.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_sheet_provider.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';

import 'widgets/map_layers/areas_layer.dart';
import 'widgets/map_layers/occurrences_layer.dart';
import 'widgets/map_layers/drawing_layer.dart';
import 'providers/dashboard_controller.dart';
import 'providers/dashboard_state.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';
import 'package:soloforte_app/features/ndvi/data/services/ndvi_cache_service.dart';
import 'package:soloforte_app/features/clients/presentation/client_detail_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final LatLng? initialLocation;
  final String? clientId;
  final bool isPublicPreview;

  const HomeScreen({
    super.key,
    this.initialLocation,
    this.clientId,
    this.isPublicPreview = false,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _BiomassaDistribution {
  final double low;
  final double medium;
  final double high;

  const _BiomassaDistribution({
    required this.low,
    required this.medium,
    required this.high,
  });
}

class _NdviPoint {
  final DateTime date;
  final double value;

  const _NdviPoint(this.date, this.value);
}

class _NdviEvolutionChart extends StatelessWidget {
  final List<_NdviPoint> points;

  const _NdviEvolutionChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const Center(
        child: Text(
          'Dados insuficientes para a evolução.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      );
    }

    return CustomPaint(
      painter: _NdviEvolutionPainter(points),
      child: const SizedBox.expand(),
    );
  }
}

// Note: _MarketingMarkerSize removed - now using MarkerSizeConfig from MarketingPinMarker widget

class _NdviEvolutionPainter extends CustomPainter {
  final List<_NdviPoint> points;

  _NdviEvolutionPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 24.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    final minY = points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final rangeY = (maxY - minY).abs() < 0.01 ? 0.01 : (maxY - minY);

    final paintLine = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintPoint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = ui.Path();
    for (var i = 0; i < points.length; i++) {
      final dx = padding + (i / (points.length - 1)) * chartWidth;
      final normalized = (points[i].value - minY) / rangeY;
      final dy = padding + chartHeight - (normalized * chartHeight);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    canvas.drawPath(path, paintLine);

    for (var i = 0; i < points.length; i++) {
      final dx = padding + (i / (points.length - 1)) * chartWidth;
      final normalized = (points[i].value - minY) / rangeY;
      final dy = padding + chartHeight - (normalized * chartHeight);
      canvas.drawCircle(Offset(dx, dy), 3, paintPoint);
    }

    final axisPaint = Paint()
      ..color = AppColors.gray300
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, padding + chartHeight),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padding, padding + chartHeight),
      Offset(padding + chartWidth, padding + chartHeight),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NdviEvolutionPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Widget _buildMarketingImage(String path, {BoxFit fit = BoxFit.cover}) {
  if (path.isEmpty) {
    return _buildMarketingImageFallback();
  }
  // Network URLs (http/https)
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(
      path,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildMarketingImageFallback(),
    );
  }
  // Blob or data URLs (common on Web from file picker)
  if (path.startsWith('data:') || path.startsWith('blob:')) {
    return Image.network(
      path,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildMarketingImageFallback(),
    );
  }
  // Local file path - use platform-specific implementation
  // On Web, this will show fallback; on Mobile, uses Image.file
  return platform_image.buildLocalImage(
    path: path,
    width: double.infinity,
    height: double.infinity,
    fit: fit,
    errorBuilder: () => _buildMarketingImageFallback(),
  );
}

Widget _buildMarketingImageFallback() {
  return Container(
    color: AppColors.gray200,
    alignment: Alignment.center,
    child: const Icon(Icons.photo, color: AppColors.textSecondary),
  );
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _markerRefreshDebounce;
  bool _isFollowingUser = false;
  LatLng? _currentLocation; // Track user location for marker
  late final TabController _ndviTabController;
  bool _isNdviPanelOpen = false;
  String? _ndviAreaKey;
  DateTime? _comparisonDateA;
  DateTime? _comparisonDateB;
  bool _isShowingComparisonA = true;
  final NdviCacheService _ndviCacheService = NdviCacheService();
  Future<List<_NdviPoint>>? _evolutionFuture;
  String? _evolutionKey;
  final MarketingRepository _marketingRepository = MarketingRepository();
  List<MarketingMapPost> _marketingPosts = [];
  bool _hasAppliedClientFocus = false;
  static const Duration _markerRefreshDelay = Duration(milliseconds: 220);

  @override
  void initState() {
    super.initState();
    _ndviTabController = TabController(length: 4, vsync: this);
    _loadMarketingPosts();

    // Focus on initial location if provided (e.g., from "Ver no Mapa")
    if (widget.initialLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mapController.move(widget.initialLocation!, kAgriculturalLocationZoom);
      });
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _markerRefreshDebounce?.cancel();
    _ndviTabController.dispose();
    super.dispose();
  }

  void _applyClientFocusIfNeeded({
    required DrawingState drawingState,
    required List<Area> dbAreas,
    required String? clientId,
    required String? clientName,
  }) {
    if (_hasAppliedClientFocus || clientId == null) return;

    LatLng? focusPoint;
    final sessionAreas = drawingState.savedAreas
        .where((area) => area.clientId == clientId)
        .toList();
    for (final area in sessionAreas) {
      if (area.center != null) {
        focusPoint = area.center;
        break;
      }
    }

    if (focusPoint == null) {
      for (final area in dbAreas) {
        if (area.clientId == clientId && area.coordinates.isNotEmpty) {
          focusPoint = GeometryUtils.calculateCentroid(area.coordinates);
          break;
        }
      }
    }

    if (focusPoint != null) {
      _hasAppliedClientFocus = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(focusPoint!, _mapController.camera.zoom);
      });
      return;
    }

    if (clientName != null) {
      _hasAppliedClientFocus = true;
    }
  }

  Future<void> _toggleUserTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviço de localização desativado.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão de localização permanentemente negada.'),
          ),
        );
      }
      return;
    }

    try {
      // Get initial position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best, // High precision
        ),
      );

      setState(() {
        _isFollowingUser = true;
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentLocation!, kAgriculturalLocationZoom);

      // Start stream
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 2, // Update every 2 meters
            ),
          ).listen(
            (pos) {
              if (mounted) {
                setState(() {
                  _currentLocation = LatLng(pos.latitude, pos.longitude);
                });

                if (_isFollowingUser) {
                  _mapController.move(
                    _currentLocation!,
                    _mapController.camera.zoom,
                  );
                }
              }
            },
            onError: (e) {
              LoggerService.e(
                'Erro no stream de localização',
                error: e,
                tag: 'GPS',
              );
            },
          );
    } catch (e) {
      LoggerService.e('Erro ao obter localização', error: e, tag: 'GPS');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPublicPreview) {
      return _buildPublicPreview(context);
    }

    final dashboardState = ref.watch(dashboardControllerProvider);
    final dashboardCtrl = ref.read(dashboardControllerProvider.notifier);
    final drawingState = ref.watch(drawingControllerProvider);
    final ndviState = ref.watch(ndviControllerProvider);
    final areasAsync = ref.watch(areasControllerProvider);
    final clientAsync = widget.clientId == null
        ? null
        : ref.watch(clientByIdProvider(widget.clientId!));
    final clientName = clientAsync?.valueOrNull?.name;

    _applyClientFocusIfNeeded(
      drawingState: drawingState,
      dbAreas: areasAsync.valueOrNull ?? [],
      clientId: widget.clientId,
      clientName: clientName,
    );

    // HARDENING: Fallbacks visuais obrigatórios para estados críticos
    if (areasAsync.isLoading && !areasAsync.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (areasAsync.hasError && !areasAsync.hasValue) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'Falha ao carregar áreas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.refresh(areasControllerProvider),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final isDrawing = ref.watch(
      drawingControllerProvider.select((s) => s.isDrawing),
    );
    final selectedPublicationId = ref.watch(
      marketingPublicationSheetProvider.select(
        (state) => state.selectedPublication?.id,
      ),
    );
    final drawingController = ref.read(drawingControllerProvider.notifier);
    final activeVisitAsync = ref.watch(visitControllerProvider);

    // Novo sistema unificado de modos
    final activeMode = dashboardState.activeMode;

    return Stack(
      children: [
        // 1. Fullscreen Map (ALWAYS visible)
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-23.5505, -46.6333),
              initialZoom: kAgriculturalLocationZoom,
              minZoom: kAgriculturalMinZoom,
              maxZoom: kAgriculturalMaxZoom,
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture && _isFollowingUser) {
                  setState(() => _isFollowingUser = false);
                }
                _scheduleMarketingVisibilityRefresh();
              },
              onTap: (tapPosition, point) => _handleMapTap(
                point,
                dashboardState,
                dashboardCtrl,
                isDrawing,
                drawingController,
              ),
              onLongPress: (tapPosition, point) =>
                  _handleMapLongPress(point, isDrawing, drawingController),
            ),
            children: [
              TileLayer(
                urlTemplate: _getMapTileUrl(dashboardState.mapLayer),
                userAgentPackageName: 'com.soloforte.app',
                maxZoom: kAgriculturalMaxZoom,
              ),
              if (_shouldShowNdviOverlay(drawingState, ndviState))
                OverlayImageLayer(
                  overlayImages: [
                    OverlayImage(
                      bounds: _getBounds(
                        _resolveNdviArea(drawingState)!.points,
                      ),
                      imageProvider: MemoryImage(ndviState.currentImageBytes!),
                      opacity: 0.8,
                    ),
                  ],
                ),
              AreasLayer(clientId: widget.clientId, clientName: clientName),
              OccurrencesLayer(
                clientId: widget.clientId,
                clientName: clientName,
              ),
              if (_marketingPosts.isNotEmpty)
                MarkerLayer(
                  markers: _buildMarketingMarkers(
                    selectedPublicationId: selectedPublicationId,
                  ),
                ),
              // User Location Marker
              if (_currentLocation != null)
                _buildUserLocationMarker(_currentLocation!),

              // Temp Pin Marker
              if (dashboardState.tempPin != null)
                _buildTempPinMarker(dashboardState.tempPin!),
              const DrawingLayer(),
            ],
          ),
        ),
        const MarketingPublicationSheetListener(),
        const OccurrenceSheetListener(),

        // 2. Indicador de Modo Ativo (aparece quando há modo ativo)
        if (activeMode.isActive) _buildModeIndicator(activeMode, dashboardCtrl),

        // 3. Online Status Badge
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: OnlineStatusBadge(),
        ),

        // 4. Weather Radar Overlay
        if (dashboardState.isWeatherRadarVisible)
          _buildWeatherRadarOverlay(dashboardCtrl),

        // 5. Drawing Toolbar (when drawing mode active)
        if (isDrawing) const DrawingToolbar(),

        // 6. Active Visit Overlay
        if (activeVisitAsync.hasValue && activeVisitAsync.value != null)
          _buildActiveVisitOverlay(context, activeVisitAsync.value!),

        // 7. Map controls (Right side: Check-in, Drawing, Layers, Weather, GPS)
        _buildFloatingControls(
          context,
          dashboardCtrl,
          isDrawing,
          drawingController,
          activeVisitAsync,
          dashboardState.isWeatherRadarVisible,
        ),

        // 8. Ações rápidas do mapa (Left side: Ocorrência e Publicação - ÍCONES PUROS)
        if (!isDrawing)
          _buildQuickMapActions(
            context,
            dashboardCtrl,
            activeMode,
            drawingController,
          ),

        if (_shouldShowNdviOverlay(drawingState, ndviState)) _buildNdviLegend(),
        if (_isNdviPanelOpen) _buildNdviPanel(),
      ],
    );
  }

  Widget _buildPublicPreview(BuildContext context) {
    final selectedPublicationId = ref.watch(
      marketingPublicationSheetProvider.select(
        (state) => state.selectedPublication?.id,
      ),
    );
    final publicPosts = _publicPreviewPosts();

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  widget.initialLocation ?? const LatLng(-14.2350, -51.9253),
              initialZoom: widget.initialLocation != null
                  ? kAgriculturalLocationZoom
                  : kAgriculturalMinZoom,
              minZoom: kAgriculturalMinZoom,
              maxZoom: kAgriculturalMaxZoom,
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture && _isFollowingUser) {
                  setState(() => _isFollowingUser = false);
                }
                _scheduleMarketingVisibilityRefresh();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _getMapTileUrl('standard'),
                userAgentPackageName: 'com.soloforte.app',
                maxZoom: kAgriculturalMaxZoom,
              ),
              if (publicPosts.isNotEmpty)
                MarkerLayer(
                  markers: _buildMarketingMarkers(
                    selectedPublicationId: selectedPublicationId,
                    posts: publicPosts,
                  ),
                ),
              if (_currentLocation != null)
                _buildUserLocationMarker(_currentLocation!),
            ],
          ),
        ),
        const MarketingPublicationSheetListener(isPublicPreview: true),
        Positioned(
          right: 16,
          bottom: 100,
          child: _buildMapControlButton(
            icon: _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
            onTap: _toggleUserTracking,
            iconColor: _isFollowingUser
                ? AppColors.primary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  List<MarketingMapPost> _publicPreviewPosts() {
    // UI-only guard; backend must enforce public visibility and fields.
    return _marketingPosts.where(_isPublicPreviewLevel).toList();
  }

  bool _isPublicPreviewLevel(MarketingMapPost post) {
    final level = (post.investmentLevel ?? '').toLowerCase();
    return level == 'ouro' ||
        level == 'premium' ||
        level == 'ampliado' ||
        level == 'prata' ||
        level == 'medio' ||
        level == 'regional';
  }

  // =====================================================
  // AÇÕES RÁPIDAS DO MAPA (ÍCONES PUROS - SEM TEXTO)
  // =====================================================
  Widget _buildQuickMapActions(
    BuildContext context,
    DashboardController dashboardCtrl,
    MapMode activeMode,
    DrawingController drawingController,
  ) {
    final isOccurrenceActive = activeMode == MapMode.occurrence;
    final isMarketingActive = activeMode == MapMode.marketing;

    return Positioned(
      left: 16,
      bottom: MediaQuery.of(context).padding.bottom + 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🐞 Ocorrência (ícone puro)
          _buildQuickActionButton(
            icon: isOccurrenceActive
                ? Icons.bug_report
                : Icons.bug_report_outlined,
            isActive: isOccurrenceActive,
            activeColor: AppColors.warning,
            onTap: () {
              if (isOccurrenceActive) {
                dashboardCtrl.cancelPinSelection();
              } else {
                dashboardCtrl.startOccurrenceFlow();
              }
            },
          ),
          const SizedBox(height: 12),

          // 📣 Publicação (ícone puro)
          _buildQuickActionButton(
            icon: isMarketingActive ? Icons.campaign : Icons.campaign_outlined,
            isActive: isMarketingActive,
            activeColor: AppColors.secondary,
            onTap: () {
              if (isMarketingActive) {
                dashboardCtrl.cancelPinSelection();
                ref.read(marketingSelectionProvider.notifier).state =
                    const MarketingSelectionState(isSelecting: false);
              } else {
                dashboardCtrl.setMode(MapMode.marketing);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: onTap,
        backgroundColor: isActive ? activeColor : Colors.white,
        foregroundColor: isActive ? Colors.white : AppColors.textSecondary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, size: 26),
      ),
    );
  }

  // =====================================================
  // FLOATING CONTROLS
  // =====================================================
  Widget _buildFloatingControls(
    BuildContext context,
    DashboardController dashboardCtrl,
    bool isDrawing,
    DrawingController drawingController,
    AsyncValue<Visit?> activeVisitAsync,
    bool isWeatherRadarVisible,
  ) {
    return Stack(
      children: [
        // Removed Floating Menu Button (Moved to BottomAppBar)

        // Map Tools (Right Side)
        Positioned(
          right: 16,
          bottom: 100, // Adjusted to be above BottomAppBar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Check-In Button
              _buildMapControlButton(
                icon: Icons.check,
                onTap: () {
                  final hasVisit =
                      ref.read(visitControllerProvider).value != null;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => hasVisit
                        ? CheckOutModal(
                            visit: ref.read(visitControllerProvider).value!,
                          )
                        : const CheckInModal(),
                  );
                },
                iconColor:
                    activeVisitAsync.hasValue && activeVisitAsync.value != null
                    ? AppColors.success
                    : AppColors.textPrimary,
              ),
              const SizedBox(height: 12),

              // Drawing Toggle
              _buildMapControlButton(
                icon: isDrawing ? Icons.edit_off : Icons.edit,
                onTap: () {
                  if (isDrawing) {
                    drawingController.stopDrawing();
                    dashboardCtrl.setMode(MapMode.neutral);
                  } else {
                    dashboardCtrl.setMode(MapMode.drawing);
                    _showDrawingOptions(drawingController);
                  }
                },
                iconColor: isDrawing ? Colors.white : AppColors.textPrimary,
                backgroundColor: isDrawing ? AppColors.primary : Colors.white,
              ),
              const SizedBox(height: 12),

              // Layer Toggle
              _buildMapControlButton(
                icon: Icons.layers_outlined,
                onTap: () => _showLayerSelector(dashboardCtrl),
              ),
              const SizedBox(height: 12),

              // Weather Toggle
              _buildMapControlButton(
                icon: Icons.cloud_outlined,
                onTap: dashboardCtrl.toggleWeatherRadar,
                iconColor: isWeatherRadarVisible
                    ? Colors.white
                    : AppColors.textPrimary,
                backgroundColor: isWeatherRadarVisible
                    ? AppColors.primary
                    : Colors.white,
              ),
              const SizedBox(height: 12),

              // GPS Button
              _buildMapControlButton(
                icon: _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
                onTap: _toggleUserTracking,
                iconColor: _isFollowingUser
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.textPrimary,
    Color backgroundColor = Colors.white,
  }) {
    return SizedBox(
      width: 44,
      height: 44,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: onTap,
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 24),
      ),
    );
  }

  // Deprecated/Removed: _buildBottomAppBar & helpers

  // =====================================================
  // MARKETING - NAVEGAÇÃO PARA ROTA (FONTE DA VERDADE)
  // =====================================================
  /// Navega para a tela de edição de publicação (ROTA FONTE DA VERDADE)
  /// A rota /map/marketing/edit é usada para criar e editar publicações
  void _showMarketingOptions(LatLng point) {
    // Navega para a rota de edição (nova publicação)
    context
        .push(
          '/map/marketing/edit',
          extra: {'latitude': point.latitude, 'longitude': point.longitude},
        )
        .then((_) {
          ref.read(dashboardControllerProvider.notifier).cancelPinSelection();
          _loadMarketingPosts(); // Recarrega pins após retornar
        });
  }

  Future<void> _loadMarketingPosts() async {
    try {
      final posts = await _marketingRepository.getMapPosts();
      if (!mounted) return;
      setState(() {
        _marketingPosts = posts;
      });
    } catch (e, s) {
      LoggerService.e(
        'Falha ao carregar posts de marketing',
        error: e,
        stackTrace: s,
        tag: 'Dashboard',
      );
      // Fail silently for user, but log it. Markers just won't appear.
    }
  }

  void _scheduleMarketingVisibilityRefresh() {
    if (_marketingPosts.isEmpty) return;
    _markerRefreshDebounce?.cancel();
    _markerRefreshDebounce = Timer(_markerRefreshDelay, () {
      if (!mounted) return;
      setState(() {});
    });
  }

  // =====================================================
  // SISTEMA DE VISIBILIDADE INTELIGENTE DE PINS
  // =====================================================
  // Regras profissionais (padrão top 0.1%):
  // 1️⃣ Zoom thresholds (obrigatório)
  // 2️⃣ Raio máximo de visualização (anti-espionagem agrícola)
  // 3️⃣ Contexto de fazenda/cliente
  // 4️⃣ Clustering inteligente

  static const PinVisibilityService _pinVisibilityService =
      PinVisibilityService();

  List<Marker> _buildMarketingMarkers({
    String? selectedPublicationId,
    List<MarketingMapPost>? posts,
  }) {
    final marketingPosts = posts ?? _marketingPosts;
    if (marketingPosts.isEmpty) {
      return [];
    }
    // Obter zoom atual e centro do mapa
    final currentZoom = _mapController.camera.zoom;
    final mapCenter = _mapController.camera.center;
    final mapBounds = _mapController.camera.visibleBounds;

    // 1️⃣ REGRA DE ZOOM MÍNIMO - Não mostrar nada em zoom regional
    if (currentZoom < PinVisibilityConfig.zoomMinCluster) {
      return []; // Zoom < 10: visão regional → nenhum pin
    }

    // Obter contexto de cliente/fazenda ativa (se houver)
    final clientId = widget.clientId;

    // Filtrar e agrupar pins com sistema de visibilidade
    final result = _pinVisibilityService.filterAndClusterPins(
      allPins: marketingPosts,
      currentZoom: currentZoom,
      mapCenter: mapCenter,
      mapBounds: mapBounds,
      activeClientId: clientId,
      activeFarmCenter: null, // TODO: pegar do talhão selecionado se houver
    );

    final markers = <Marker>[];
    final selectedMarkers = <Marker>[];

    // 2️⃣ ADICIONAR PINS INDIVIDUAIS (zoom alto)
    final sortedPins = [...result.visiblePins]
      ..sort((a, b) => _marketingLevelPriority(a) - _marketingLevelPriority(b));
    for (final post in sortedPins) {
      final sizeConfig = MarkerSizeConfig.forLevel(
        post.investmentLevel ?? 'prata',
      );

      // Determinar configuração de zoom para o marker
      final zoomLevel = _pinVisibilityService.getMarkerZoomLevel(currentZoom);
      final zoomConfig = _getMarkerZoomConfig(zoomLevel);

      final isSelected = post.id == selectedPublicationId;
      final targetList = isSelected ? selectedMarkers : markers;
      targetList.add(
        Marker(
          point: LatLng(post.latitude, post.longitude),
          width: sizeConfig.totalWidth,
          height: sizeConfig.totalHeight,
          child: MarketingPinMarker.fromLegacy(
            post: post,
            zoomConfig: zoomConfig,
            onTap: () => _showMarketingDetails(post),
            isSelected: isSelected,
          ),
        ),
      );
    }

    // 3️⃣ ADICIONAR CLUSTERS (zoom médio)
    for (final cluster in result.clusters) {
      markers.add(
        Marker(
          point: cluster.center,
          width: 80,
          height: 60,
          child: MarketingClusterMarker(
            cluster: cluster,
            zoom: currentZoom,
            onTap: () => _handleClusterTap(cluster),
          ),
        ),
      );
    }

    markers.addAll(selectedMarkers);
    return markers;
  }

  /// Retorna a configuração de zoom para o marker
  MarkerZoomConfig _getMarkerZoomConfig(MarkerZoomLevel level) {
    switch (level) {
      case MarkerZoomLevel.full:
        return MarkerZoomConfig.normal;
      case MarkerZoomLevel.simplified:
        return MarkerZoomConfig.zoomedOut;
      case MarkerZoomLevel.extreme:
        return MarkerZoomConfig.extremeZoomOut;
      case MarkerZoomLevel.hidden:
        return MarkerZoomConfig.extremeZoomOut;
    }
  }

  int _marketingLevelPriority(MarketingMapPost post) {
    switch (post.investmentLevel) {
      case 'ouro':
      case 'premium':
        return 2;
      case 'prata':
      case 'medio':
        return 1;
      default:
        return 0;
    }
  }

  /// Manipula clique em um cluster - dá zoom para explodir
  void _handleClusterTap(PinCluster cluster) {
    // Dar zoom no cluster para explodir
    _mapController.move(
      cluster.center,
      PinVisibilityConfig.zoomMinIndividual + 0.5,
    );
  }

  // NOTE: _marketingMarkerSize and _buildMarketingMarker methods removed.
  // Their logic is now encapsulated in MarketingPinMarker widget
  // which provides proper z-index hierarchy and zoom support.

  void _showMarketingDetails(MarketingMapPost post) {
    _emitMarketingPublicationSelected(post);
  }

  void _emitMarketingPublicationSelected(MarketingMapPost post) {
    MarketingInteractionTracker.pinOpened(publicationId: post.id);
    ref.read(marketingPublicationSheetProvider.notifier).selectById(post.id);
  }

  // DEPRECATED: Métodos obsoletos mantidos temporariamente para retrocompatibilidade
  // Serão removidos na próxima versão

  // =====================================================
  // DRAWING OPTIONS MODAL
  // =====================================================
  void _showDrawingOptions(DrawingController drawingController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ferramentas de Desenho',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.polyline,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Talhão (Polígono)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Desenhe áreas personalizadas'),
                onTap: () {
                  Navigator.pop(ctx);
                  drawingController.startDrawing();
                  drawingController.setTool('polygon');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Pivô (Círculo)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Desenhe áreas circulares'),
                onTap: () {
                  Navigator.pop(ctx);
                  drawingController.startDrawing();
                  drawingController.setTool('circle');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Importar KML/KMZ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Carregue arquivos de mapa'),
                onTap: () {
                  Navigator.pop(ctx);
                  drawingController.importFromFile();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // =====================================================
  // INDICADOR DE MODO ATIVO
  // Exibe o modo atual quando não está em navegação livre
  // =====================================================
  Widget _buildModeIndicator(
    MapMode activeMode,
    DashboardController dashboardCtrl,
  ) {
    // 1️⃣ VISUAL ESPECÍFICO PARA MODO PUBLICAÇÃO (MARKETING)
    // Badge discreto no canto superior esquerdo
    if (activeMode == MapMode.marketing) {
      return Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A2F), // Cor identidade
            borderRadius: BorderRadius.circular(
              8,
            ), // Bordas arredondadas suaves
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Publicação',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    // 2️⃣ VISUAL PARA OUTROS MODOS (Banners centralizados)
    String message;
    Color bgColor;
    IconData icon;

    if (activeMode == MapMode.occurrence) {
      message = '📍 Modo: Ocorrência - Toque no mapa';
      bgColor = AppColors.warning;
      icon = Icons.bug_report;
    } else if (activeMode == MapMode.drawing) {
      message = '✏️ Modo: Desenhar';
      bgColor = AppColors.primary;
      icon = Icons.edit;
    } else {
      // Modo neutro - não deve aparecer, mas fallback
      message = '📍 Selecione o Local';
      bgColor = const Color(0xFF1E3A2F);
      icon = Icons.location_on;
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 24,
      right: 24,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // Cancelar qualquer modo ativo
                  dashboardCtrl.cancelPinSelection();
                  ref.read(marketingSelectionProvider.notifier).state =
                      const MarketingSelectionState(isSelecting: false);
                  ref.read(drawingControllerProvider.notifier).stopDrawing();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // MAP TAP HANDLER
  // =====================================================
  void _handleMapTap(
    LatLng point,
    DashboardState dashboardState,
    DashboardController dashboardCtrl,
    bool isDrawing,
    DrawingController drawingController,
  ) {
    // Marketing flow (Pin -> Modal -> Form)
    if (dashboardState.activeMode == MapMode.marketing) {
      dashboardCtrl.setTempPin(point);

      // Delay visual para ver o pin antes do modal abrir
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _showMarketingOptions(point);
      });
      return;
    }

    // Occurrence flow
    if (dashboardState.activeMode == MapMode.occurrence) {
      dashboardCtrl.setTempPin(point);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        // VINCULAR VISITA ATIVA (Se houver)
        final activeVisit = ref.read(visitControllerProvider).value;
        final Map<String, dynamic> extraData = {
          'latitude': point.latitude,
          'longitude': point.longitude,
        };

        if (activeVisit != null && activeVisit.status == VisitStatus.ongoing) {
          extraData['visitId'] = activeVisit.id;
          extraData['clientId'] =
              activeVisit.client.id; // Override context clientId if any
        } else if (widget.clientId != null) {
          extraData['clientId'] = widget.clientId;
        }

        // Navigate to New Occurrence Screen with coordinates
        context.push('/occurrences/new', extra: extraData).then((result) {
          dashboardCtrl.cancelPinSelection();
          if (result is Occurrence) {
            ref.read(occurrenceSheetProvider.notifier).select(result);
          }
        });
      });
      return;
    }

    // Drawing Mode
    if (isDrawing) {
      drawingController.addPoint(point);
      return;
    }

    // Check if tapped on existing area (Edit Mode trigger)
    final savedAreas = ref.read(drawingControllerProvider).savedAreas;
    for (final area in savedAreas.reversed) {
      bool isHit = false;
      if (area.type == 'circle' && area.center != null) {
        final dist = GeometryUtils.calculateDistance(area.center!, point);
        if (dist <= area.radius) isHit = true;
      } else {
        if (GeometryUtils.isPointInPolygon(point, area.points)) isHit = true;
      }

      if (isHit) {
        drawingController.startEditingArea(area);
        dashboardCtrl.setMode(MapMode.drawing);

        // Show snackbar? Or just visual feedback (vertices appear)
        return;
      }
    }

    // 2. Database Areas
    final dbAreas = ref.read(areasControllerProvider).valueOrNull ?? [];
    for (final area in dbAreas) {
      if (GeometryUtils.isPointInPolygon(point, area.coordinates)) {
        // Convert DB Area to GeoArea for editing
        final geoArea = GeoArea(
          id: area.id,
          name: area.name,
          points: area.coordinates,
          type: 'polygon', // Assume polygon for DB areas
          holes: [],
          areaHectares: area.hectares,
          perimeterKm: GeometryUtils.calculatePerimeterKm(area.coordinates),
          center: GeometryUtils.calculateCentroid(area.coordinates),
          createdAt: DateTime.now(),
          clientId: area.clientId,
        );

        drawingController.startEditingArea(geoArea);
        dashboardCtrl.setMode(MapMode.drawing);
        return;
      }
    }

    // Close radial menu if open
    if (dashboardState.isRadialMenuOpen) {
      dashboardCtrl.toggleRadialMenu();
    }
  }

  void _handleMapLongPress(
    LatLng point,
    bool isDrawing,
    DrawingController drawingController,
  ) {
    if (!isDrawing) return;

    final drawingState = ref.read(drawingControllerProvider);
    if (drawingState.activeTool != 'polygon' ||
        drawingState.currentPoints.length < 3) {
      return;
    }

    // Check if point is near any edge to insert a vertex
    const double thresholdMeters = 30.0;

    // We check perimeter segments
    final points = drawingState.currentPoints;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

      final d1 = GeometryUtils.calculateDistance(p1, point);
      final d2 = GeometryUtils.calculateDistance(p2, point);
      final dBase = GeometryUtils.calculateDistance(p1, p2);

      // Simple triangle inequality check for "on segment"
      // If d1 + d2 is close to dBase, point is near the line segment
      if ((d1 + d2 - dBase).abs() < (thresholdMeters / 1000.0) * 0.1) {
        // Need a practical tolerance.
        // Let's rely on meters directly. Note calculateDistance returns meters.
        // Wait, GeometryUtils says: calculateDistance -> distance.as(LengthUnit.Meter, p1, p2).
        // So d1, d2, dBase are in METERS.
        // So tolerance should be e.g. 5 meters.
        if ((d1 + d2 - dBase).abs() < 5.0) {
          drawingController.insertVertex(i, point);
          return;
        }
      }
    }
  }

  // =====================================================
  // USER LOCATION MARKER
  // =====================================================
  Widget _buildUserLocationMarker(LatLng point) {
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          width: 24,
          height: 24,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        // Pulsing effect (optional, simple larger circle behind)
        Marker(
          point: point,
          width: 60,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // TEMP PIN MARKER
  // =====================================================
  Widget _buildTempPinMarker(LatLng point) {
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          width: 50,
          height: 50,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    Icon(Icons.location_on, color: AppColors.primary, size: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLayerSelector(DashboardController dashboardCtrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Camadas do Mapa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLayerOption(
              'Padrão',
              'standard',
              Icons.map_outlined,
              dashboardCtrl,
            ),
            _buildLayerOption(
              'Satélite',
              'satellite',
              Icons.satellite_outlined,
              dashboardCtrl,
            ),
            _buildLayerOption(
              'Relevo',
              'relief',
              Icons.terrain_outlined,
              dashboardCtrl,
            ),
            ListTile(
              leading: const Icon(Icons.grass_outlined),
              title: const Text('NDVI Viewer'),
              onTap: () {
                Navigator.pop(ctx);
                _openNdviPanel();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openNdviPanel() {
    setState(() {
      _isNdviPanelOpen = true;
    });
  }

  void _closeNdviPanel() {
    setState(() {
      _isNdviPanelOpen = false;
    });
  }

  Widget _buildNdviPanel() {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth < 600 ? screenWidth * 0.9 : 360.0;

    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Material(
          color: Colors.white,
          elevation: 12,
          child: SizedBox(
            width: panelWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'NDVI Viewer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: AppColors.textSecondary,
                        onPressed: _closeNdviPanel,
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _ndviTabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'NDVI'),
                    Tab(text: 'Biomassa'),
                    Tab(text: 'Comparação'),
                    Tab(text: 'Evolução'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _ndviTabController,
                    children: [
                      _buildNdviTabContent(),
                      _buildBiomassaTabContent(),
                      _buildComparacaoTabContent(),
                      _buildEvolucaoTabContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNdviPlaceholder(String tabLabel) {
    return Center(
      child: Text(
        '$tabLabel em breve',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }

  Widget _buildNdviTabContent() {
    final drawingState = ref.watch(drawingControllerProvider);
    final ndviState = ref.watch(ndviControllerProvider);

    final area = _resolveNdviArea(drawingState);
    final hasValidArea = area != null;
    if (hasValidArea) {
      _syncNdviArea(area);
    } else {
      _ndviAreaKey = null;
    }

    if (!hasValidArea) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Selecione um talhão ou desenhe um polígono para ativar o NDVI.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (ndviState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final dates = ndviState.availableDates;
    if (dates.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma imagem NDVI disponível para a safra ativa.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    return Column(
      children: [
        if (ndviState.isImageLoading)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: dates.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final date = dates[index];
              final label = DateFormat('dd/MM/yyyy').format(date);
              return RadioListTile<DateTime>(
                value: date,
                groupValue: ndviState.selectedDate,
                onChanged: (value) {
                  if (value == null) return;
                  ref
                      .read(ndviControllerProvider.notifier)
                      .loadNdviImage(value);
                },
                title: Text(label),
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBiomassaTabContent() {
    final ndviState = ref.watch(ndviControllerProvider);

    if (ndviState.currentImageBytes == null || ndviState.selectedDate == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ative uma data NDVI para ver a biomassa.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final stats = ndviState.currentStats;
    if (stats == null) {
      return const Center(
        child: Text(
          'Estatísticas NDVI indisponíveis para esta data.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    final distribution = _computeBiomassaDistribution(stats);
    if (distribution == null) {
      return const Center(
        child: Text(
          'Estatísticas NDVI indisponíveis para esta data.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    final selectedDateLabel = DateFormat(
      'dd/MM/yyyy',
    ).format(ndviState.selectedDate!);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biomassa • $selectedDateLabel',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildBiomassaRow(
            label: 'Alta biomassa',
            percentage: distribution.high,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildBiomassaRow(
            label: 'Média biomassa',
            percentage: distribution.medium,
            color: Colors.yellow,
          ),
          const SizedBox(height: 12),
          _buildBiomassaRow(
            label: 'Baixa biomassa',
            percentage: distribution.low,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildComparacaoTabContent() {
    final ndviState = ref.watch(ndviControllerProvider);
    final dates = ndviState.availableDates;

    if (dates.isEmpty) {
      return const Center(
        child: Text(
          'Sem datas NDVI disponíveis para comparação.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    _syncComparisonDates(dates);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione duas datas da mesma safra',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildComparisonDatePicker(
            label: 'Data A',
            value: _comparisonDateA,
            dates: dates,
            onChanged: (value) => _setComparisonDate(value, isA: true),
          ),
          const SizedBox(height: 12),
          _buildComparisonDatePicker(
            label: 'Data B',
            value: _comparisonDateB,
            dates: dates,
            onChanged: (value) => _setComparisonDate(value, isA: false),
          ),
          const SizedBox(height: 16),
          if (_comparisonDateA != null && _comparisonDateB != null)
            _buildComparisonToggle(),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (_comparisonDateA == null || _comparisonDateB == null) {
                  return;
                }
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! > 0) {
                  _setComparisonView(isA: true);
                } else if (details.primaryVelocity! < 0) {
                  _setComparisonView(isA: false);
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Center(
                  child: Text(
                    _comparisonStatusLabel(ndviState),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolucaoTabContent() {
    final ndviState = ref.watch(ndviControllerProvider);
    final dates = ndviState.availableDates;
    final area = _resolveNdviArea(ref.watch(drawingControllerProvider));

    if (area == null || area.id.isEmpty) {
      return const Center(
        child: Text(
          'Selecione um talhão com NDVI ativo para ver a evolução.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    if (dates.isEmpty) {
      return const Center(
        child: Text(
          'Sem datas NDVI disponíveis para evolução.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    final evolutionKey = '${area.id}_${dates.length}';
    if (_evolutionKey != evolutionKey) {
      _evolutionKey = evolutionKey;
      _evolutionFuture = _loadEvolutionPoints(area, dates, ndviState);
    }

    return FutureBuilder<List<_NdviPoint>>(
      future: _evolutionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final points = snapshot.data ?? [];
        if (points.isEmpty) {
          return const Center(
            child: Text(
              'Sem dados NDVI disponíveis para evolução.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NDVI médio por data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: _NdviEvolutionChart(points: points)),
            ],
          ),
        );
      },
    );
  }

  Future<List<_NdviPoint>> _loadEvolutionPoints(
    GeoArea area,
    List<DateTime> dates,
    NdviState ndviState,
  ) async {
    final points = <_NdviPoint>[];
    for (final date in dates) {
      Map<String, dynamic>? stats;
      if (ndviState.selectedDate != null &&
          _isSameDay(date, ndviState.selectedDate!) &&
          ndviState.currentStats != null) {
        stats = ndviState.currentStats;
      } else {
        final cached = await _ndviCacheService.getNdviData(
          areaId: area.id,
          date: date,
        );
        stats = cached?.stats;
      }
      final mean = _extractNdviMean(stats);
      if (mean != null) {
        points.add(_NdviPoint(date, mean));
      }
    }
    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  double? _extractNdviMean(Map<String, dynamic>? stats) {
    if (stats == null) return null;
    try {
      final value =
          stats['data'][0]['outputs']['ndvi']['bands']['B0']['stats']['mean'];
      if (value is num) return value.toDouble();
    } catch (_) {
      return null;
    }
    return null;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _syncComparisonDates(List<DateTime> dates) {
    if (_comparisonDateA != null && !dates.contains(_comparisonDateA)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _comparisonDateA = null;
        });
      });
    }
    if (_comparisonDateB != null && !dates.contains(_comparisonDateB)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _comparisonDateB = null;
        });
      });
    }
  }

  Widget _buildComparisonDatePicker({
    required String label,
    required DateTime? value,
    required List<DateTime> dates,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<DateTime>(
            initialValue: value,
            items: dates
                .map(
                  (date) => DropdownMenuItem(
                    value: date,
                    child: Text(DateFormat('dd/MM/yyyy').format(date)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonToggle() {
    final activeLabel = _isShowingComparisonA ? 'Data A' : 'Data B';
    return Row(
      children: [
        const Text(
          'Visualizando:',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        Text(
          activeLabel,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isShowingComparisonA,
          onChanged: (value) => _setComparisonView(isA: value),
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  void _setComparisonDate(DateTime? value, {required bool isA}) {
    if (value == null) return;
    if (!mounted) return;
    setState(() {
      if (isA) {
        _comparisonDateA = value;
        _isShowingComparisonA = true;
      } else {
        _comparisonDateB = value;
        _isShowingComparisonA = false;
      }
    });
    _activateComparisonDate();
  }

  void _setComparisonView({required bool isA}) {
    if (_comparisonDateA == null || _comparisonDateB == null) {
      return;
    }
    setState(() {
      _isShowingComparisonA = isA;
    });
    _activateComparisonDate();
  }

  void _activateComparisonDate() {
    final targetDate = _isShowingComparisonA
        ? _comparisonDateA
        : _comparisonDateB;
    if (targetDate == null) return;
    ref.read(ndviControllerProvider.notifier).loadNdviImage(targetDate);
  }

  String _comparisonStatusLabel(NdviState ndviState) {
    if (_comparisonDateA == null || _comparisonDateB == null) {
      return 'Selecione Data A e Data B para iniciar a comparação.';
    }

    final activeDate = _isShowingComparisonA
        ? _comparisonDateA
        : _comparisonDateB;
    final dateLabel = activeDate != null
        ? DateFormat('dd/MM/yyyy').format(activeDate)
        : '-';

    if (ndviState.isImageLoading) {
      return 'Carregando NDVI de $dateLabel...';
    }

    return 'Mostrando NDVI de $dateLabel.\n'
        'Use o toggle ou faça swipe para alternar.';
  }

  _BiomassaDistribution? _computeBiomassaDistribution(
    Map<String, dynamic> stats,
  ) {
    try {
      final histogram =
          stats['data'][0]['outputs']['ndvi']['bands']['B0']['histogram'];
      final bins = List<double>.from(
        histogram['bins'].map((e) => (e as num).toDouble()),
      );
      final counts = List<int>.from(
        histogram['counts'].map((e) => (e as num).toInt()),
      );

      if (bins.isEmpty || counts.isEmpty) {
        return null;
      }

      double low = 0;
      double medium = 0;
      double high = 0;
      double total = 0;

      final length = counts.length < bins.length ? counts.length : bins.length;
      for (var i = 0; i < length; i++) {
        final ndviValue = bins[i];
        final count = counts[i].toDouble();
        total += count;

        if (ndviValue < 0.3) {
          low += count;
        } else if (ndviValue < 0.6) {
          medium += count;
        } else {
          high += count;
        }
      }

      if (total <= 0) {
        return null;
      }

      return _BiomassaDistribution(
        low: (low / total) * 100,
        medium: (medium / total) * 100,
        high: (high / total) * 100,
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildBiomassaRow({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _syncNdviArea(GeoArea area) {
    final areaKey = _buildNdviAreaKey(area);
    if (areaKey == null || areaKey == _ndviAreaKey) {
      return;
    }
    _ndviAreaKey = areaKey;
    ref.read(ndviControllerProvider.notifier).initializeForArea(area);
  }

  GeoArea? _resolveNdviArea(DrawingState drawingState) {
    if (drawingState.isDrawing) {
      List<LatLng> points = [];
      if (drawingState.activeTool == 'circle') {
        if (drawingState.circleCenter == null ||
            drawingState.circleRadius <= 0) {
          points = [];
        } else {
          points = GeometryUtils.createCirclePolygon(
            drawingState.circleCenter!,
            drawingState.circleRadius,
          );
        }
      } else if (drawingState.activeTool == 'polygon' ||
          drawingState.activeTool == 'rectangle') {
        if (drawingState.currentPoints.length >= 3) {
          points = drawingState.currentPoints;
        }
      }

      if (points.isNotEmpty) {
        return GeoArea(
          id: _buildNdviAreaKeyFromPoints(points) ?? 'ndvi_temp_area',
          name: 'Área temporária',
          points: points,
          holes: const [],
          createdAt: DateTime.now(),
          areaHectares: GeometryUtils.calculateAreaHectares(points),
          perimeterKm: GeometryUtils.calculatePerimeterKm(points),
          center: GeometryUtils.calculateCentroid(points),
          type: 'polygon',
        );
      }
    }

    if (drawingState.selectedAreaId != null) {
      if (drawingState.savedAreas.isEmpty) {
        return null;
      }
      return drawingState.savedAreas.firstWhere(
        (area) => area.id == drawingState.selectedAreaId,
        orElse: () => drawingState.savedAreas.first,
      );
    }

    if (drawingState.editingAreaId != null) {
      if (drawingState.savedAreas.isEmpty) {
        return null;
      }
      return drawingState.savedAreas.firstWhere(
        (area) => area.id == drawingState.editingAreaId,
        orElse: () => drawingState.savedAreas.first,
      );
    }

    return null;
  }

  bool _shouldShowNdviOverlay(DrawingState drawingState, NdviState ndviState) {
    if (_resolveNdviArea(drawingState) == null) return false;
    return ndviState.currentImageBytes != null;
  }

  String? _buildNdviAreaKey(GeoArea area) {
    if (area.id.isNotEmpty) {
      return area.id;
    }
    return _buildNdviAreaKeyFromPoints(area.points);
  }

  String? _buildNdviAreaKeyFromPoints(List<LatLng> points) {
    if (points.isEmpty) return null;
    final buffer = StringBuffer();
    for (final point in points) {
      buffer
        ..write(point.latitude.toStringAsFixed(6))
        ..write(',')
        ..write(point.longitude.toStringAsFixed(6))
        ..write(';');
    }
    return buffer.toString();
  }

  Widget _buildNdviLegend() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      right: 16,
      bottom: bottomPadding + 120,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendRow(Colors.green, 'Saudável'),
            _buildLegendRow(Colors.yellow, 'Médio'),
            _buildLegendRow(Colors.red, 'Estresse'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(const LatLng(0, 0), const LatLng(0, 0));
    }
    final bbox = GeometryUtils.calculateBBox(points);
    return LatLngBounds(LatLng(bbox[1], bbox[0]), LatLng(bbox[3], bbox[2]));
  }

  Widget _buildLayerOption(
    String label,
    String value,
    IconData icon,
    DashboardController ctrl,
  ) {
    final isSelected = ref.watch(
      dashboardControllerProvider.select((s) => s.mapLayer == value),
    );
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        ctrl.setMapLayer(value);
        Navigator.pop(context);
      },
    );
  }

  // =====================================================
  // WEATHER RADAR OVERLAY
  // =====================================================
  Widget _buildWeatherRadarOverlay(DashboardController dashboardCtrl) {
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                const WeatherRadarWidget(),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: dashboardCtrl.toggleWeatherRadar,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // ACTIVE VISIT OVERLAY
  // =====================================================
  Widget _buildActiveVisitOverlay(BuildContext context, Visit visit) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ActiveVisitOverlay(
        visit: visit,
        onCheckOutTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CheckOutModal(visit: visit),
          );
        },
        onAddNoteTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota rápida implementada em breve')),
          );
        },
        onAddOccurenceTap: () {
          ref.read(dashboardControllerProvider.notifier).startOccurrenceFlow();
        },
      ),
    );
  }

  // =====================================================
  // HELPERS
  // =====================================================
  String _getMapTileUrl(String layer) {
    if (layer == 'satellite') {
      return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    } else if (layer == 'relief') {
      return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
    }
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }
}

class _MarketingPostDetailSheet extends StatelessWidget {
  final MarketingMapPost post;
  final VoidCallback? onViewPhotos;
  final VoidCallback onEdit;

  const _MarketingPostDetailSheet({
    required this.post,
    required this.onViewPhotos,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = post.type == 'resultado' ? 'Resultado' : 'Antes e Depois';
    final cover = post.coverPhoto;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (cover != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildMarketingImage(cover.path, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.campaign, color: AppColors.textSecondary),
                ),
              ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Tipo', value: typeLabel),
            _DetailRow(label: 'Cliente', value: post.client ?? '—'),
            _DetailRow(label: 'Área / Talhão', value: post.area ?? '—'),
            _DetailRow(label: 'Observações', value: post.notes ?? '—'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewPhotos,
                    child: const Text('Ver Fotos'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEdit,
                    child: const Text('Editar Publicação'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketingGalleryScreen extends StatefulWidget {
  final MarketingMapPost post;

  const _MarketingGalleryScreen({required this.post});

  @override
  State<_MarketingGalleryScreen> createState() =>
      _MarketingGalleryScreenState();
}

class _MarketingGalleryScreenState extends State<_MarketingGalleryScreen> {
  late List<MarketingPhoto> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List<MarketingPhoto>.from(widget.post.photos);
  }

  void _setCover(int index) {
    setState(() {
      _photos = _photos
          .asMap()
          .entries
          .map(
            (entry) => entry.key == index
                ? entry.value.copyWith(isCover: true)
                : entry.value.copyWith(isCover: false),
          )
          .toList();
    });
  }

  void _deletePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
      if (_photos.isNotEmpty && !_photos.any((p) => p.isCover)) {
        _photos = _photos
            .asMap()
            .entries
            .map(
              (entry) => entry.key == 0
                  ? entry.value.copyWith(isCover: true)
                  : entry.value,
            )
            .toList();
      }
    });
  }

  Future<void> _editCaption(int index) async {
    final controller = TextEditingController(text: _photos[index].caption);
    final updated = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar legenda'),
        content: TextField(
          controller: controller,
          maxLines: 2,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (updated != null) {
      setState(() {
        _photos[index] = _photos[index].copyWith(caption: updated);
      });
    }
  }

  Future<void> _openViewer(int index) async {
    final updated = await showDialog<List<MarketingPhoto>>(
      context: context,
      barrierColor: Colors.black,
      builder: (ctx) =>
          _MarketingPhotoViewer(photos: _photos, initialIndex: index),
    );

    if (updated != null) {
      setState(() {
        _photos = updated;
      });
    }
  }

  void _close() {
    final updated = widget.post.copyWith(photos: _photos).ensureCover();
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 800 ? 4 : 3;

    return Scaffold(
      // ci: allow-appbar
      // ci: allow-appbar
      backgroundColor: Colors.black,
      appBar: AppBar(
        // ci: allow-appbar
        backgroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: _close),
        title: const Text('Fotos'),
      ),
      body: _photos.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma foto adicionada.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return GestureDetector(
                  onTap: () => _openViewer(index),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildMarketingImage(
                            photo.path,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (photo.isCover)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: _photos.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _close,
                      child: const Text('Concluir'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _MarketingPhotoViewer extends StatefulWidget {
  final List<MarketingPhoto> photos;
  final int initialIndex;

  const _MarketingPhotoViewer({
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<_MarketingPhotoViewer> createState() => _MarketingPhotoViewerState();
}

class _MarketingPhotoViewerState extends State<_MarketingPhotoViewer> {
  late List<MarketingPhoto> _photos;
  late PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _photos = List<MarketingPhoto>.from(widget.photos);
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setCover() {
    setState(() {
      _photos = _photos
          .asMap()
          .entries
          .map(
            (entry) => entry.key == _index
                ? entry.value.copyWith(isCover: true)
                : entry.value.copyWith(isCover: false),
          )
          .toList();
    });
  }

  void _delete() {
    setState(() {
      _photos.removeAt(_index);
      if (_photos.isEmpty) {
        Navigator.pop(context, _photos);
        return;
      }
      if (_index >= _photos.length) {
        _index = _photos.length - 1;
      }
      if (!_photos.any((p) => p.isCover)) {
        _photos[0] = _photos[0].copyWith(isCover: true);
      }
      _controller.jumpToPage(_index);
    });
  }

  Future<void> _editCaption() async {
    final controller = TextEditingController(text: _photos[_index].caption);
    final updated = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar legenda'),
        content: TextField(
          controller: controller,
          maxLines: 2,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (updated != null) {
      setState(() {
        _photos[_index] = _photos[_index].copyWith(caption: updated);
      });
    }
  }

  void _close() {
    Navigator.pop(context, _photos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ci: allow-appbar
      // ci: allow-appbar
      backgroundColor: Colors.black,
      appBar: AppBar(
        // ci: allow-appbar
        backgroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: _close),
        actions: [
          IconButton(onPressed: _setCover, icon: const Icon(Icons.star_border)),
          IconButton(onPressed: _editCaption, icon: const Icon(Icons.edit)),
          IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: _photos.length,
        onPageChanged: (value) => setState(() => _index = value),
        itemBuilder: (context, index) {
          final photo = _photos[index];
          return Center(
            child: _buildMarketingImage(photo.path, fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}

class _MarketingEditScreen extends StatefulWidget {
  final MarketingMapPost post;

  const _MarketingEditScreen({required this.post});

  @override
  State<_MarketingEditScreen> createState() => _MarketingEditScreenState();
}

class _MarketingEditScreenState extends State<_MarketingEditScreen> {
  late List<MarketingPhoto> _photos;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _photos = List<MarketingPhoto>.from(widget.post.photos);
    _notesController = TextEditingController(text: widget.post.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _setCover(int index) {
    setState(() {
      _photos = _photos
          .asMap()
          .entries
          .map(
            (entry) => entry.key == index
                ? entry.value.copyWith(isCover: true)
                : entry.value.copyWith(isCover: false),
          )
          .toList();
    });
  }

  void _deletePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
      if (_photos.isNotEmpty && !_photos.any((p) => p.isCover)) {
        _photos[0] = _photos[0].copyWith(isCover: true);
      }
    });
  }

  void _save() {
    final updated = widget.post
        .copyWith(photos: _photos, notes: _notesController.text.trim())
        .ensureCover();
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ci: allow-appbar
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ci: allow-appbar
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Editar Publicação'),
        actions: [TextButton(onPressed: _save, child: const Text('Salvar'))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _photos.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _photos.removeAt(oldIndex);
                  _photos.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return ListTile(
                  key: ValueKey('${photo.path}-$index'),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: _buildMarketingImage(photo.path),
                    ),
                  ),
                  title: TextFormField(
                    initialValue: photo.caption,
                    decoration: const InputDecoration(
                      labelText: 'Legenda',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _photos[index] = _photos[index].copyWith(caption: value);
                    },
                  ),
                  subtitle: Row(
                    children: [
                      IconButton(
                        onPressed: () => _setCover(index),
                        icon: Icon(
                          photo.isCover ? Icons.star : Icons.star_border,
                          color: photo.isCover ? Colors.orange : Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deletePhoto(index),
                        icon: const Icon(Icons.delete_outline),
                      ),
                      const Spacer(),
                      ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
