import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/core/constants/map_zoom_constants.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_state.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/core/presentation/widgets/premium_dialog.dart';
import 'package:soloforte_app/features/map/presentation/widgets/save_area_dialog.dart';
import 'package:soloforte_app/features/ndvi/presentation/ndvi_detail_screen.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/features/occurrences/presentation/new_occurrence_screen.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/new_case_modal.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/side_by_side_eval_modal.dart';
import 'package:soloforte_app/core/services/analytics_service.dart';
import 'widgets/drawing_toolbar.dart';
import 'widgets/area_details_sheet.dart';
import 'widgets/map_bottom_bar.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? initialLocation;

  const MapScreen({super.key, this.initialLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // Controllers & State
    final dashboardController = ref.watch(dashboardControllerProvider.notifier);
    final dashboardState = ref.watch(dashboardControllerProvider);

    final drawingController = ref.read(drawingControllerProvider.notifier);
    final drawingState = ref.watch(drawingControllerProvider);

    final occurrencesState = ref.watch(occurrenceControllerProvider);

    // Sync Dashboard Mode -> Drawing Controller
    ref.listen<DashboardState>(dashboardControllerProvider, (prev, next) {
      if (next.activeMode == MapMode.drawing &&
          (prev?.activeMode != MapMode.drawing)) {
        ref.read(drawingControllerProvider.notifier).startDrawing();
      }
      if (prev?.activeMode == MapMode.drawing &&
          next.activeMode != MapMode.drawing) {
        if (ref.read(drawingControllerProvider).isDrawing) {
          ref.read(drawingControllerProvider.notifier).stopDrawing();
        }
      }
    });

    // Sync Drawing Controller -> Dashboard Mode (e.g. Cancel button)
    ref.listen<DrawingState>(drawingControllerProvider, (prev, next) {
      if (prev?.isDrawing == true && !next.isDrawing) {
        if (ref.read(dashboardControllerProvider).activeMode ==
            MapMode.drawing) {
          ref
              .read(dashboardControllerProvider.notifier)
              .setMode(MapMode.neutral);
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // MAP FULLSCREEN
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  widget.initialLocation ?? const LatLng(-14.2350, -51.9253),
              initialZoom: widget.initialLocation != null
                  ? kAgriculturalLocationZoom
                  : kAgriculturalMinZoom,
              minZoom: kAgriculturalMinZoom,
              maxZoom: kAgriculturalMaxZoom,
              onTap: (tapPosition, point) => _handleMapTap(
                point,
                dashboardController,
                dashboardState,
                drawingController,
                drawingState,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.soloforte.app',
                maxZoom: kAgriculturalMaxZoom,
              ),

              // 1. Saved Areas (Drawings)
              PolygonLayer(
                polygons: drawingState.savedAreas.map((area) {
                  final isSelected = area.id == drawingState.selectedAreaId;
                  return Polygon(
                    points: area.points,
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : AppColors.primary.withValues(alpha: 0.3),
                    borderColor: isSelected ? Colors.white : AppColors.primary,
                    borderStrokeWidth: isSelected ? 3 : 2,
                  );
                }).toList(),
              ),

              // 2. Definitive Occurrences Pins
              if (occurrencesState.hasValue)
                MarkerLayer(
                  markers: occurrencesState.value!.map((occ) {
                    return Marker(
                      point: LatLng(occ.latitude, occ.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Show details
                        },
                        child: _buildPin(occ.type, false),
                      ),
                    );
                  }).toList(),
                ),

              // 3. Temporary Pin (Active Mode)
              if (dashboardState.tempPin != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: dashboardState.tempPin!,
                      width: 48,
                      height: 48,
                      child: _buildPin(
                        dashboardState.activeMode == MapMode.marketing
                            ? 'marketing_temp'
                            : 'temp',
                        true,
                      ),
                    ),
                  ],
                ),

              // 4. Drawing Preview Layers
              if (drawingState.isDrawing &&
                  drawingState.currentPoints.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: drawingState.currentPoints,
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderColor: AppColors.secondary,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (drawingState.isDrawing &&
                  drawingState.activeTool == 'circle' &&
                  drawingState.circleCenter != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: drawingState.circleCenter!,
                      radius: drawingState.circleRadius,
                      useRadiusInMeter: true,
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderColor: AppColors.secondary,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (drawingState.isDrawing &&
                  drawingState.activeTool == 'polygon')
                MarkerLayer(
                  markers: drawingState.currentPoints
                      .map(
                        (p) => Marker(
                          point: p,
                          width: 14,
                          height: 14,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.secondary),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),

          // TOP BAR: [←] Mapa [⚙️]
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.small(
                  heroTag: 'back',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black12),
                    ],
                  ),
                  child: Text(
                    _getTitle(dashboardState, drawingState),
                    style: AppTypography.h4,
                  ),
                ),
                FloatingActionButton.small(
                  heroTag: 'settings',
                  onPressed: () {}, // Settings action
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.settings, color: Colors.black),
                ),
              ],
            ),
          ),

          // Feedback TOAST for Modes (Waiting for pin)
          if ((dashboardState.activeMode == MapMode.occurrence ||
                  dashboardState.activeMode == MapMode.marketing) &&
              dashboardState.tempPin == null)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (dashboardState.activeMode == MapMode.marketing
                                ? Colors.teal
                                : AppColors.primary)
                            .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dashboardState.activeMode == MapMode.marketing
                            ? 'Toque no mapa para marcar o ponto do case'
                            : 'Toque no mapa para marcar a ocorrência',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Marketing CTA (When pin is set)
          if (dashboardState.activeMode == MapMode.marketing &&
              dashboardState.tempPin != null)
            Positioned(
              bottom: 150,
              left: 16,
              right: 16,
              child: Center(
                child: FloatingActionButton.extended(
                  heroTag: 'marketing_cta',
                  onPressed: () =>
                      _openMarketingOptions(context, dashboardController),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add_task),
                  label: const Text('+ Novo Case'),
                ),
              ),
            ),

          // VERTICAL CONTROLS
          if (!drawingState.isDrawing)
            Positioned(
              right: 16,
              bottom: 180,
              child: Column(
                children: [
                  _buildMapBtn(
                    Icons.my_location,
                    () => _mapController.move(
                      const LatLng(-14.235, -51.925),
                      kAgriculturalLocationZoom,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMapBtn(Icons.add, () {
                    final newZoom = (_mapController.camera.zoom + 1).clamp(
                      kAgriculturalMinZoom,
                      kAgriculturalMaxZoom,
                    );
                    _mapController.move(_mapController.camera.center, newZoom);
                  }),
                  const SizedBox(height: 8),
                  _buildMapBtn(Icons.remove, () {
                    final newZoom = (_mapController.camera.zoom - 1).clamp(
                      kAgriculturalMinZoom,
                      kAgriculturalMaxZoom,
                    );
                    _mapController.move(_mapController.camera.center, newZoom);
                  }),
                ],
              ),
            ),

          // BOTTOM BAR (Mode Switcher) - Always visible unless drawing
          if (!drawingState.isDrawing) const MapBottomBar(),

          // DRAWING TOOLBAR (Takes over bottom when drawing)
          if (drawingState.isDrawing)
            const Align(
              alignment: Alignment.bottomCenter,
              child: DrawingToolbar(),
            ),

          // Top Right Save Button while drawing (if enough points)
          if (drawingState.isDrawing)
            Positioned(
              top: 40,
              right: 70,
              child: drawingState.currentPoints.length >= 3
                  ? ElevatedButton.icon(
                      onPressed: () =>
                          _showSaveDialog(context, drawingController),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  String _getTitle(DashboardState dash, DrawingState draw) {
    if (draw.isDrawing) return 'Desenhando...';
    if (dash.activeMode == MapMode.occurrence) return 'Nova Ocorrência';
    if (dash.activeMode == MapMode.marketing) return 'Marketing';
    return 'Mapa';
  }

  Widget _buildPin(String type, bool isTemp) {
    Color color;
    IconData icon;

    switch (type) {
      case 'pest':
        color = AppColors.error;
        icon = Icons.bug_report;
        break;
      case 'disease':
        color = AppColors.warning;
        icon = Icons.coronavirus;
        break;
      case 'deficiency':
        color = Colors.purple;
        icon = Icons.spa;
        break;
      case 'weed':
        color = Colors.green;
        icon = Icons.grass;
        break;
      case 'marketing_temp':
        color = Colors.teal;
        icon = Icons.campaign;
        break;
      case 'temp':
      default:
        color = AppColors.primary;
        icon = Icons.location_on;
    }

    if (isTemp) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
        ),
        child: Icon(icon, color: color, size: 30),
      );
    }

    return Icon(Icons.location_on, color: color, size: 40);
  }

  Widget _buildMapBtn(IconData icon, VoidCallback onTap) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onTap,
      ),
    );
  }

  void _handleMapTap(
    LatLng point,
    DashboardController dashController,
    DashboardState dashState,
    DrawingController drawController,
    DrawingState drawState,
  ) async {
    // 1. Occurrence Mode
    if (dashState.activeMode == MapMode.occurrence) {
      final analytics = ref.read(analyticsServiceProvider);
      analytics.logEvent('occurrence_pin_marked');

      dashController.setTempPin(point);
      _mapController.move(point, _mapController.camera.zoom);

      analytics.logEvent('occurrence_form_opened');

      // Open Form Immediately
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: NewOccurrenceScreen(
                initialLatitude: point.latitude,
                initialLongitude: point.longitude,
              ),
            ),
          ),
        ),
      );

      // Track Completion
      if (result == true) {
        analytics.endFlow('occurrence_flow', result: 'saved');
      } else {
        analytics.logEvent('occurrence_cancelled');
        analytics.endFlow('occurrence_flow', result: 'cancelled');
      }

      dashController.setMode(MapMode.neutral);
      return;
    }

    // 2. Marketing Mode
    if (dashState.activeMode == MapMode.marketing) {
      dashController.setTempPin(point);
      _mapController.move(point, _mapController.camera.zoom);
      // Do NOT open form immediately. User must click CTA.
      return;
    }

    // 3. Drawing Mode
    if (drawState.isDrawing) {
      if (drawState.activeTool == 'circle' && drawState.circleCenter == null) {
        drawController.addPoint(point);
        const distance = Distance();
        drawController.updateCircleRadius(distance.offset(point, 100, 90));
      } else if (drawState.activeTool == 'polygon') {
        if (drawState.currentPoints.isNotEmpty &&
            drawState.currentPoints.length >= 3 &&
            GeometryUtils.isClosingPoint(
              drawState.currentPoints.first,
              point,
            )) {
          _showSaveDialog(context, drawController);
        } else {
          drawController.addPoint(point);
        }
      }
      return;
    }

    // 4. Neutral Mode
    GeoArea? tapped;
    for (final area in drawState.savedAreas.reversed) {
      if (GeometryUtils.isPointInPolygon(point, area.points)) {
        tapped = area;
        break;
      }
    }
    if (tapped != null) {
      drawController.selectArea(tapped.id);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => AreaDetailsSheet(
          area: tapped!,
          onDelete: () {
            Navigator.pop(ctx);
            drawController.deleteArea(tapped!.id);
          },
          onEdit: () {
            Navigator.pop(ctx);
            drawController.startEditingArea(tapped!);
          },
          onAnalyze: () {
            Navigator.pop(ctx);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NDVIDetailScreen(area: tapped!),
              ),
            );
          },
        ),
      );
    }
  }

  void _showSaveDialog(BuildContext context, DrawingController controller) {
    PremiumDialog.show(
      context: context,
      builder: (context) =>
          SaveAreaDialog(onSave: (name) => controller.saveArea(name)),
    );
  }

  void _openMarketingOptions(
    BuildContext context,
    DashboardController controller,
  ) {
    final pin = ref.read(dashboardControllerProvider).tempPin; // Safety check
    if (pin == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('O que você deseja criar?', style: AppTypography.h3),
            const SizedBox(height: 24),
            _buildOptionTile(
              icon: Icons.star,
              color: Colors.amber,
              title: 'Novo Case de Sucesso',
              subtitle: 'Registre resultados de alta performance',
              onTap: () async {
                Navigator.pop(ctx);
                final result = await showDialog(
                  context: context,
                  builder: (_) => NewCaseSuccessModal(
                    latitude: pin.latitude,
                    longitude: pin.longitude,
                  ),
                );
                if (result != null) _finalizeMarketingFlow(controller);
              },
            ),
            const Divider(height: 32),
            _buildOptionTile(
              icon: Icons.compare_arrows,
              color: Colors.teal,
              title: 'Avaliação Lado a Lado',
              subtitle: 'Compare tratamento padrão vs. premium',
              onTap: () async {
                Navigator.pop(ctx);
                final result = await showDialog(
                  context: context,
                  builder: (_) => SideBySideEvalModal(
                    latitude: pin.latitude,
                    longitude: pin.longitude,
                  ),
                );
                if (result != null) _finalizeMarketingFlow(controller);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  void _finalizeMarketingFlow(DashboardController controller) {
    // Show discrete confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Case salvo no mapa!'),
          ],
        ),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: 280,
      ),
    );

    // Return to neutral
    controller.setMode(MapMode.neutral);
  }
}
