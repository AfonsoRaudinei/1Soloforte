import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/constants/map_zoom_constants.dart';

import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/presentation/widgets/drawing_toolbar.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/visits/domain/entities/visit.dart';

import 'widgets/online_status_badge.dart';
import 'package:soloforte_app/features/weather/presentation/widgets/weather_radar.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_selection_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/new_case_modal.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/side_by_side_eval_modal.dart';

import 'widgets/map_layers/areas_layer.dart';
import 'widgets/map_layers/occurrences_layer.dart';
import 'widgets/map_layers/drawing_layer.dart';
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
    final dashboardState = ref.watch(dashboardControllerProvider);
    final dashboardCtrl = ref.read(dashboardControllerProvider.notifier);

    final isDrawing = ref.watch(
      drawingControllerProvider.select((s) => s.isDrawing),
    );
    final drawingController = ref.read(drawingControllerProvider.notifier);
    final activeVisitAsync = ref.watch(visitControllerProvider);

    // Novo sistema unificado de modos
    final activeMode = dashboardState.activeMode;
    final marketingState = ref.watch(marketingSelectionProvider);

    return Scaffold(
      body: Stack(
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
                onTap: (tapPosition, point) => _handleMapTap(
                  point,
                  dashboardState,
                  dashboardCtrl,
                  isDrawing,
                  drawingController,
                  marketingState,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: _getMapTileUrl(dashboardState.mapLayer),
                  userAgentPackageName: 'com.soloforte.app',
                  maxZoom: kAgriculturalMaxZoom,
                ),
                const AreasLayer(),
                const OccurrencesLayer(),
                // Temp Pin Marker
                if (dashboardState.tempPin != null)
                  _buildTempPinMarker(dashboardState.tempPin!),
                const DrawingLayer(),
              ],
            ),
          ),

          // 2. BOTTOM APPBAR with 4 icons (FINAL)
          _buildBottomAppBar(
            dashboardCtrl,
            isDrawing,
            drawingController,
            activeMode,
          ),

          // 3. Indicador de Modo Ativo (aparece quando há modo ativo)
          if (activeMode.isActive || marketingState.isSelecting)
            _buildModeIndicator(
              activeMode,
              dashboardCtrl,
              marketingState.isSelecting,
            ),

          // 4. Online Status Badge
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(child: OnlineStatusBadge()),
          ),

          // 5. Weather Radar Overlay
          if (dashboardState.isWeatherRadarVisible)
            _buildWeatherRadarOverlay(dashboardCtrl),

          // 6. Drawing Toolbar (when drawing mode active)
          if (isDrawing) const DrawingToolbar(),

          // 7. Active Visit Overlay
          if (activeVisitAsync.hasValue && activeVisitAsync.value != null)
            _buildActiveVisitOverlay(context, activeVisitAsync.value!),

          // 8. Map controls (Zoom + Layers)
          _buildMapControls(dashboardCtrl),
        ],
      ),
    );
  }

  // =====================================================
  // BOTTOM APPBAR - FINAL 4 ICONS (INFERIOR)
  // Sistema unificado de modos com toggle
  // =====================================================
  Widget _buildBottomAppBar(
    DashboardController dashboardCtrl,
    bool isDrawing,
    DrawingController drawingController,
    MapMode activeMode,
  ) {
    // Verificar modos ativos
    final isOccurrenceActive = activeMode == MapMode.occurrence;
    final isMarketingActive = activeMode == MapMode.marketing;
    final isDrawingActive = activeMode == MapMode.drawing || isDrawing;

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 🐞 Ocorrência - Toggle
            _buildBottomBarIcon(
              icon: isOccurrenceActive
                  ? Icons.bug_report
                  : Icons.bug_report_outlined,
              label: 'Ocorrência',
              onTap: () {
                // Se outro modo estiver ativo, desativa primeiro
                if (isDrawing) drawingController.stopDrawing();
                ref.read(marketingSelectionProvider.notifier).state =
                    const MarketingSelectionState(isSelecting: false);
                dashboardCtrl.startOccurrenceFlow();
              },
              color: AppColors.warning,
              isActive: isOccurrenceActive,
            ),

            // 📣 Marketing - Toggle
            _buildBottomBarIcon(
              icon: isMarketingActive
                  ? Icons.campaign
                  : Icons.campaign_outlined,
              label: 'Marketing',
              onTap: () {
                // Se outro modo estiver ativo, desativa primeiro
                if (isDrawing) drawingController.stopDrawing();
                if (isMarketingActive) {
                  // Desativar marketing
                  dashboardCtrl.cancelPinSelection();
                  ref.read(marketingSelectionProvider.notifier).state =
                      const MarketingSelectionState(isSelecting: false);
                } else {
                  // Ativar marketing
                  dashboardCtrl.setMode(MapMode.marketing);
                  _showMarketingOptions();
                }
              },
              color: AppColors.secondary,
              isActive: isMarketingActive,
            ),

            // ✏️ Desenhar - Toggle
            _buildBottomBarIcon(
              icon: isDrawingActive ? Icons.close : Icons.edit_outlined,
              label: isDrawingActive ? 'Parar' : 'Desenhar',
              onTap: () {
                // Desativar outros modos
                dashboardCtrl.setMode(MapMode.neutral);
                ref.read(marketingSelectionProvider.notifier).state =
                    const MarketingSelectionState(isSelecting: false);

                if (isDrawing) {
                  drawingController.stopDrawing();
                } else {
                  dashboardCtrl.setMode(MapMode.drawing);
                  _showDrawingOptions(drawingController);
                }
              },
              color: isDrawingActive ? Colors.red : AppColors.primary,
              isActive: isDrawingActive,
            ),

            // ☰ Menu (3 paus)
            _buildBottomBarIcon(
              icon: Icons.menu,
              label: 'Menu',
              onTap: () => Scaffold.of(context).openDrawer(),
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isActive = false,
  }) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: isActive
                ? BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
  // MARKETING OPTIONS MODAL
  // =====================================================
  void _showMarketingOptions() {
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
                'O que você deseja criar?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star_outline,
                    color: Color(0xFF4ADE80),
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Novo Case de Sucesso',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Mostre resultados incríveis'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref
                      .read(marketingSelectionProvider.notifier)
                      .state = const MarketingSelectionState(
                    isSelecting: true,
                    reportType: 'case',
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.compare_arrows,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Avaliação Lado a Lado',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Comparativo A vs B em campo'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref
                      .read(marketingSelectionProvider.notifier)
                      .state = const MarketingSelectionState(
                    isSelecting: true,
                    reportType: 'side_by_side',
                  );
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
  // INDICADOR DE MODO ATIVO
  // Exibe o modo atual quando não está em navegação livre
  // =====================================================
  Widget _buildModeIndicator(
    MapMode activeMode,
    DashboardController dashboardCtrl,
    bool isMarketingSelecting,
  ) {
    String message;
    Color bgColor;
    IconData icon;

    // Determinar visual baseado no modo ativo
    if (isMarketingSelecting || activeMode == MapMode.marketing) {
      message = '📍 Modo: Marketing - Selecione o Local';
      bgColor = const Color(0xFF1E3A2F);
      icon = Icons.campaign;
    } else if (activeMode == MapMode.occurrence) {
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
    MarketingSelectionState marketingState,
  ) {
    // Marketing flow
    if (marketingState.isSelecting) {
      dashboardCtrl.setTempPin(point);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (_) {
            if (marketingState.reportType == 'side_by_side') {
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

    // Occurrence flow
    if (dashboardState.pinSelectionMode == 'occurrence') {
      dashboardCtrl.setTempPin(point);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        // Navigate to New Occurrence Screen with coordinates
        context
            .push(
              '/occurrences/new',
              extra: {'latitude': point.latitude, 'longitude': point.longitude},
            )
            .then((_) {
              dashboardCtrl.cancelPinSelection();
            });
      });
      return;
    }

    // Drawing Mode
    if (isDrawing) {
      drawingController.addPoint(point);
      return;
    }

    // Close radial menu if open
    if (dashboardState.isRadialMenuOpen) {
      dashboardCtrl.toggleRadialMenu();
    }
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

  // =====================================================
  // MAP CONTROLS (Layers + Zoom)
  // =====================================================
  Widget _buildMapControls(DashboardController dashboardCtrl) {
    return Positioned(
      right: 16,
      bottom: 120, // Acima da Bottom AppBar
      child: Column(
        children: [
          // Layer Toggle
          _buildMapControlButton(
            icon: Icons.layers_outlined,
            onTap: () => _showLayerSelector(dashboardCtrl),
          ),
          const SizedBox(height: 12),
          // Zoom In
          _buildMapControlButton(
            icon: Icons.add,
            onTap: () {
              final newZoom = (_mapController.camera.zoom + 1).clamp(
                kAgriculturalMinZoom,
                kAgriculturalMaxZoom,
              );
              _mapController.move(_mapController.camera.center, newZoom);
            },
          ),
          const SizedBox(height: 8),
          // Zoom Out
          _buildMapControlButton(
            icon: Icons.remove,
            onTap: () {
              final newZoom = (_mapController.camera.zoom - 1).clamp(
                kAgriculturalMinZoom,
                kAgriculturalMaxZoom,
              );
              _mapController.move(_mapController.camera.center, newZoom);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
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
                context.push('/map/ndvi');
              },
            ),
          ],
        ),
      ),
    );
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
      bottom: 120, // Acima da Bottom AppBar
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
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
