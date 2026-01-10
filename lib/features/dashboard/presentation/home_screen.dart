import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/presentation/widgets/drawing_toolbar.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/visits/domain/entities/visit.dart';

import 'widgets/map_side_controls.dart';
import 'widgets/online_status_badge.dart';
import 'widgets/radial_menu.dart';
import 'package:soloforte_app/features/weather/presentation/widgets/weather_radar.dart';
import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_report_modal.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_selection_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/new_case_modal.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/side_by_side_eval_modal.dart';

import 'widgets/map_layers/areas_layer.dart';
import 'widgets/map_layers/occurrences_layer.dart';
import 'widgets/map_layers/drawing_layer.dart';
import 'package:soloforte_app/core/theme/app_breakpoints.dart';
import 'widgets/dashboard_side_panel.dart';
import 'providers/dashboard_controller.dart';
import 'providers/dashboard_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // Providers
    final dashboardState = ref.watch(dashboardControllerProvider);
    final dashboardCtrl = ref.read(dashboardControllerProvider.notifier);

    final isDrawing = ref.watch(
      drawingControllerProvider.select((s) => s.isDrawing),
    );
    final drawingController = ref.read(drawingControllerProvider.notifier);
    final activeVisitAsync = ref.watch(visitControllerProvider);

    // Build the responsive layout
    return Scaffold(
      body: ResponsiveBuilder(
        // Mobile Layout (Standard Stack)
        mobile: _buildMapStack(
          context,
          isDrawing,
          drawingController,
          activeVisitAsync,
          dashboardState,
          dashboardCtrl,
        ),

        // Tablet/Desktop Layout (Side Panel + Map)
        tablet: Row(
          children: [
            const DashboardSidePanel(),
            Expanded(
              child: _buildMapStack(
                context,
                isDrawing,
                drawingController,
                activeVisitAsync,
                dashboardState,
                dashboardCtrl,
                isSidePanelVisible: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapStack(
    BuildContext context,
    bool isDrawing,
    DrawingController drawingController,
    AsyncValue<Visit?> activeVisitAsync,
    DashboardState dashboardState,
    DashboardController dashboardCtrl, {
    bool isSidePanelVisible = false,
  }) {
    return Stack(
      children: [
        // 1. Fullscreen Map
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-23.5505, -46.6333),
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                final selectionState = ref.read(marketingSelectionProvider);
                if (selectionState.isSelecting) {
                  dashboardCtrl.setTempPin(point);

                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!mounted) return;
                    // Open Modal
                    showDialog(
                      context: context,
                      barrierColor: Colors.black54,
                      builder: (_) {
                        if (selectionState.reportType == 'side_by_side') {
                          return SideBySideEvalModal(
                            latitude: point.latitude,
                            longitude: point.longitude,
                          );
                        }
                        return NewCaseSuccessModal(
                          latitude: point.latitude,
                          longitude: point.longitude,
                        );
                      },
                    ).then((result) {
                      ref.read(marketingSelectionProvider.notifier).state =
                          const MarketingSelectionState(isSelecting: false);

                      if (result != null) {
                        context.push('/map/marketing');
                      }

                      dashboardCtrl.setTempPin(null);
                    });
                  });
                  return;
                }

                if (dashboardState.isRadialMenuOpen)
                  dashboardCtrl.toggleRadialMenu();
                if (isDrawing) {
                  drawingController.addPoint(point);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _getMapTileUrl(dashboardState.mapLayer),
                userAgentPackageName: 'com.soloforte.app',
              ),
              const AreasLayer(),
              const OccurrencesLayer(),
              if (dashboardState.tempPin != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: dashboardState.tempPin!,
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
                                    color: Colors.blue.withValues(alpha: 0.3),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const DrawingLayer(),
            ],
          ),
        ),

        // Marketing Banner
        Consumer(
          builder: (context, ref, child) {
            final isSelecting = ref
                .watch(marketingSelectionProvider)
                .isSelecting;
            if (!isSelecting) return const SizedBox.shrink();
            return Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A2F), // sf-dark
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '📍 Selecione o Local',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Menu Button
        if (!isSidePanelVisible)
          Positioned(
            top: 40,
            left: 16,
            child: Material(
              color: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                color: AppColors.primary,
              ),
            ),
          ),

        // Weather Radar Overlay
        if (dashboardState.isWeatherRadarVisible)
          Positioned.fill(
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
          ),

        // Online Status Badge
        const Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(child: OnlineStatusBadge()),
        ),

        // Map Side Controls
        MapSideControls(
          onMarketingTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'O que você deseja criar?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: const Icon(
                          Icons.star_outline,
                          color: Color(0xFF4ADE80),
                          size: 30,
                        ),
                        title: const Text('Novo Case de Sucesso'),
                        subtitle: const Text('Mostre resultados incríveis'),
                        onTap: () {
                          Navigator.pop(context); // Close sheet
                          ref
                              .read(marketingSelectionProvider.notifier)
                              .state = const MarketingSelectionState(
                            isSelecting: true,
                            reportType: 'case',
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.compare_arrows,
                          color: Colors.blue,
                          size: 30,
                        ),
                        title: const Text('Avaliação Lado a Lado'),
                        subtitle: const Text('Comparativo A vs B em campo'),
                        onTap: () {
                          Navigator.pop(context); // Close sheet
                          ref
                              .read(marketingSelectionProvider.notifier)
                              .state = const MarketingSelectionState(
                            isSelecting: true,
                            reportType: 'side_by_side',
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          onWeatherTap: dashboardCtrl.toggleWeatherRadar,
          onOccurrencesTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Fechar',
              pageBuilder: (context, anim1, anim2) =>
                  const OccurrenceReportModal(),
              transitionBuilder: (context, anim1, anim2, child) {
                return SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: anim1,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: child,
                );
              },
            );
          },
          onLayerSelected: (layer) {
            if (layer == 'ndvi') {
              context.push('/map/ndvi');
            } else {
              dashboardCtrl.setMapLayer(layer);
            }
          },
          onDrawTap: () {
            if (isDrawing) {
              drawingController.stopDrawing();
            } else {
              drawingController.startDrawing();
            }
          },
          onZoomIn: () => _mapController.move(
            _mapController.camera.center,
            _mapController.camera.zoom + 1,
          ),
          onZoomOut: () => _mapController.move(
            _mapController.camera.center,
            _mapController.camera.zoom - 1,
          ),
        ),

        // Drawing Toolbar
        if (isDrawing) const DrawingToolbar(),

        // Active Visit Overlay
        if (!isSidePanelVisible &&
            activeVisitAsync.hasValue &&
            activeVisitAsync.value != null)
          _buildActiveVisitOverlay(context, activeVisitAsync.value!),

        // Radial Menu Overlay
        if (dashboardState.isRadialMenuOpen)
          RadialMenu(onClose: dashboardCtrl.toggleRadialMenu),

        // FAB
        if (!isDrawing && !isSidePanelVisible)
          Positioned(
            bottom: 32,
            right: 32,
            child: FloatingActionButton(
              onPressed: dashboardCtrl.toggleRadialMenu,
              backgroundColor: AppColors.primary,
              heroTag: 'main_fab',
              child: Icon(
                dashboardState.isRadialMenuOpen ? Icons.close : Icons.menu,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveVisitOverlay(BuildContext context, Visit visit) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Visita em Andamento',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    visit.client.name,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/visit/active'),
              child: const Text(
                'VER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMapTileUrl(String layer) {
    if (layer == 'satellite') {
      return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    } else if (layer == 'relief') {
      return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
    }
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }
}
