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
import 'package:soloforte_app/features/map/presentation/widgets/save_area_bottom_sheet.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/features/occurrences/presentation/new_occurrence_screen.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/new_case_modal.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/side_by_side_eval_modal.dart';
import 'package:soloforte_app/core/services/analytics_service.dart';
import 'widgets/drawing_toolbar.dart';
import 'widgets/area_details_sheet.dart';
import 'widgets/map_bottom_bar.dart';
import 'widgets/drawing_measurement_overlay.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/features/agenda/presentation/agenda_controller.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/check_in_modal.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/check_out_modal.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/visits/domain/entities/visit.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/map_layers/drawing_layer.dart';
import 'package:soloforte_app/features/map/presentation/widgets/export_areas_bottom_sheet.dart';
import 'package:soloforte_app/core/services/location/location_service.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/ndvi_side_panel.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? initialLocation;

  const MapScreen({super.key, this.initialLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  bool _hasCheckedNearbyAreas = false;
  bool _showNdviPanel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNearbyAreas();
    });
  }

  Future<void> _checkNearbyAreas() async {
    if (_hasCheckedNearbyAreas) return;
    _hasCheckedNearbyAreas = true;

    try {
      final locationService = ref.read(locationServiceProvider);
      final userPos = await locationService.getCurrentPosition();

      if (!mounted) return;

      final drawingState = ref.read(drawingControllerProvider);
      final savedAreas = drawingState.savedAreas;

      const distance = Distance();
      GeoArea? nearest;
      double minDst = double.infinity;

      for (var area in savedAreas) {
        if (area.center == null) continue;
        final d = distance(userPos, area.center!); // Distance in meters
        if (d < 500 && d < minDst) {
          // 500m threshold
          minDst = d;
          nearest = area;
        }
      }

      if (nearest != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você está próximo da área "${nearest.name}".'),
            action: SnackBarAction(
              label: 'Usar Área',
              onPressed: () {
                // Select area
                ref
                    .read(drawingControllerProvider.notifier)
                    .selectArea(nearest!.id);
                // Open details
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => AreaDetailsSheet(
                    area: nearest!,
                    onDelete: () {
                      Navigator.pop(ctx);
                      ref
                          .read(drawingControllerProvider.notifier)
                          .deleteArea(nearest!.id);
                    },
                    onEdit: () {
                      Navigator.pop(ctx);
                      ref
                          .read(drawingControllerProvider.notifier)
                          .startEditingArea(nearest!);
                    },
                    onAnalyze: () {
                      Navigator.pop(ctx);

                      ref
                          .read(ndviControllerProvider.notifier)
                          .initializeForArea(nearest!);

                      setState(() {
                        _showNdviPanel = true;
                      });
                    },
                    onStartVisit: (area) {
                      Navigator.pop(ctx);
                      // Trigger visit logic (Check-in) matches _handleMapTap logic
                      // We can duplicate the logic or extract it?
                      // For now just open simple check-in
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          builder: (_, controller) =>
                              CheckInModal(initialArea: area),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            duration: const Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Ignore location errors silently
    }
  }

  @override
  Widget build(BuildContext context) {
    // Controllers & State
    final dashboardController = ref.watch(dashboardControllerProvider.notifier);
    final dashboardState = ref.watch(dashboardControllerProvider);

    final drawingController = ref.read(drawingControllerProvider.notifier);
    final drawingState = ref.watch(drawingControllerProvider);

    final occurrencesState = ref.watch(occurrenceControllerProvider);
    final agendaEvents = ref.watch(
      filteredAgendaProvider,
    ); // Fetched from Agenda Module

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

    // Sync Visit Controller -> Drawing Controller (Update Area Status)
    ref.listen<AsyncValue<Visit?>>(visitControllerProvider, (prev, next) {
      next.whenData((visit) {
        if (visit != null && visit.areaId != null) {
          if (visit.status == VisitStatus.ongoing) {
            ref
                .read(drawingControllerProvider.notifier)
                .updateAreaVisitStatus(visit.areaId!, activeVisitId: visit.id);
          } else if (visit.status == VisitStatus.completed) {
            ref
                .read(drawingControllerProvider.notifier)
                .updateAreaVisitStatus(
                  visit.areaId!,
                  activeVisitId: null, // Clear active visit
                  lastVisitDate: visit.checkOutTime ?? DateTime.now(),
                );
          }
        }
      });
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

              // NDVI Overlay (If loaded by controller from SidePanel)
              Consumer(
                builder: (context, ref, _) {
                  final ndviState = ref.watch(ndviControllerProvider);
                  if (ndviState.currentImageBytes != null && _showNdviPanel) {
                    final area = ndviState.currentArea;
                    if (area == null || area.points.isEmpty) {
                      return const SizedBox();
                    }

                    final bbox = GeometryUtils.calculateBBox(area.points);
                    final bounds = LatLngBounds(
                      LatLng(bbox[1], bbox[0]),
                      LatLng(bbox[3], bbox[2]),
                    );

                    return OverlayImageLayer(
                      overlayImages: [
                        OverlayImage(
                          bounds: bounds,
                          imageProvider: MemoryImage(
                            ndviState.currentImageBytes!,
                          ),
                          opacity: 0.7,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),

              // 1. Saved Areas (Drawings)
              PolygonLayer(
                polygons: drawingState.savedAreas.map((area) {
                  final isSelected = area.id == drawingState.selectedAreaId;
                  final hasActiveVisit = area.activeVisitId != null;

                  final fillColor = hasActiveVisit
                      ? Colors.green.withValues(alpha: 0.4)
                      : (area.colorValue != null
                            ? Color(
                                area.colorValue!,
                              ).withValues(alpha: isSelected ? 0.5 : 0.3)
                            : AppColors.primary.withValues(
                                alpha: isSelected ? 0.5 : 0.3,
                              ));

                  final borderColor = hasActiveVisit
                      ? Colors.greenAccent
                      : (isSelected
                            ? Colors.white
                            : (area.colorValue != null
                                  ? Color(area.colorValue!)
                                  : AppColors.primary));

                  return Polygon(
                    points: area.points,
                    color: fillColor,
                    borderColor: borderColor,
                    borderStrokeWidth: hasActiveVisit
                        ? 3
                        : (isSelected ? 3 : 2),
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
                        onTap: () async {
                          // FIX: Open details/edit modal
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
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: NewOccurrenceScreen(
                                    initialOccurrence: occ,
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (result == true) {
                            // Optional: Refresh or show feedback manually if needed,
                            // but provider updates automatically.
                          }
                        },
                        child: _buildPin(occ.type, false),
                      ),
                    );
                  }).toList(),
                ),

              // 5. Agenda Events Pins (Read-Only)
              if (agendaEvents.hasValue)
                MarkerLayer(
                  markers: agendaEvents.value!.where((e) => e.locationCoordinates != null).map((
                    event,
                  ) {
                    final lat = event.locationCoordinates!['lat']!;
                    final lng = event.locationCoordinates!['lng']!;
                    return Marker(
                      point: LatLng(lat, lng),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          // Show View-Only Event Details
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (ctx) => DraggableScrollableSheet(
                              initialChildSize: 0.5,
                              minChildSize: 0.4,
                              maxChildSize: 0.9,
                              builder: (_, scrollParams) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Evento da Agenda',
                                            style: AppTypography.caption,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () => Navigator.pop(ctx),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        event.title,
                                        style: AppTypography.h3,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${DateFormat('dd/MM/yyyy HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                                        style: AppTypography.bodyMedium
                                            .copyWith(color: Colors.grey[700]),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Chip(
                                            label: Text(
                                              event.status.name.toUpperCase(),
                                            ),
                                            backgroundColor: Colors.grey[200],
                                          ),
                                          const SizedBox(width: 8),
                                          if (event.type ==
                                              EventType.technicalVisit)
                                            const Chip(
                                              label: Text('Visita Técnica'),
                                              backgroundColor:
                                                  AppColors.primaryLight,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // Navigate to Agenda for editing (Not implemented in this scope as requested)
                                            // Navigator.pushNamed(context, '/agenda');
                                            Navigator.pop(ctx);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Edição disponível apenas na Agenda',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Ver na Agenda'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: const Icon(
                            Icons.event,
                            color: Colors.blueGrey,
                            size: 24,
                          ),
                        ),
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

              // 4. Drawing Preview Layers (Using dedicated widget)
              const DrawingLayer(),
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
                  onPressed: () {
                    // Open Export Options
                    final selectedId = drawingState.selectedAreaId;
                    GeoArea? selectedArea;
                    if (selectedId != null) {
                      try {
                        selectedArea = drawingState.savedAreas.firstWhere(
                          (a) => a.id == selectedId,
                        );
                      } catch (_) {}
                    }

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => ExportAreasBottomSheet(
                        allAreas: drawingState.savedAreas,
                        selectedArea: selectedArea,
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.download,
                    color: Colors.black,
                  ), // Changed icon to download/export for clarity
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

          // Real-time Area Measurement Overlay (Drawing Mode)
          const DrawingMeasurementOverlay(),

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

          // Top Right Save Button while drawing (if enough points) => REMOVED (Moved to DrawingToolbar)

          // NDVI Side Panel
          if (_showNdviPanel)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Material(
                elevation: 16,
                child: NdviSidePanel(
                  onClose: () {
                    setState(() => _showNdviPanel = false);
                  },
                ),
              ),
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
            // Requirement: No route change, open side panel.
            ref
                .read(ndviControllerProvider.notifier)
                .initializeForArea(tapped!);
            setState(() {
              _showNdviPanel = true;
            });
          },
          onStartVisit: (area) {
            Navigator.pop(ctx);
            if (area.activeVisitId != null) {
              // Manage existing visit (Check Out)
              final currentVisit = ref.read(visitControllerProvider).value;
              if (currentVisit != null &&
                  currentVisit.id == area.activeVisitId) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    builder: (_, controller) =>
                        CheckOutModal(visit: currentVisit),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao carregar dados da visita ativa.'),
                  ),
                );
              }
            } else {
              // Start new visit (Check In)
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (_, controller) => CheckInModal(initialArea: area),
                ),
              );
            }
          },
        ),
      );
    }
  }

  void _showSaveDialog(BuildContext context, DrawingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SaveAreaBottomSheet(
        onSave:
            ({
              required name,
              required clientId,
              required clientName,
              fieldId,
              fieldName,
              notes,
              colorValue,
              required isDashed,
            }) {
              controller.saveArea(
                name: name,
                clientId: clientId,
                clientName: clientName,
                fieldId: fieldId,
                fieldName: fieldName,
                notes: notes,
                colorValue: colorValue,
                isDashed: isDashed,
              );
            },
      ),
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
