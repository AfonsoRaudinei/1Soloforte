import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/core/presentation/widgets/premium_dialog.dart';
import 'package:soloforte_app/features/map/presentation/widgets/save_area_dialog.dart';
import 'package:soloforte_app/features/ndvi/presentation/ndvi_detail_screen.dart';
import 'widgets/drawing_toolbar.dart';
import 'widgets/area_details_sheet.dart';

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
    final drawingController = ref.read(drawingControllerProvider.notifier);
    final drawingState = ref.watch(drawingControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // MAP FULLSCREEN
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  widget.initialLocation ?? const LatLng(-14.2350, -51.9253),
              initialZoom: widget.initialLocation != null ? 16.0 : 4.0,
              onTap: (tapPosition, point) =>
                  _handleMapTap(point, drawingController, drawingState),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.soloforte.app',
                maxZoom: 19,
              ),
              // Saved Areas
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
              // Drawing Preview
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
              // Circle Preview
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

              // Drawing Markers (Vertices)
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
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.black12),
                    ],
                  ),
                  child: Text(
                    drawingState.isDrawing ? 'Desenhando...' : 'Mapa',
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

          if (!drawingState.isDrawing) ...[
            // CONTROLS: [📍] [+] [-] [📐] [🖊️]
            Positioned(
              right: 16,
              bottom: 180, // Above layers box
              child: Column(
                children: [
                  _buildMapBtn(
                    Icons.my_location,
                    () =>
                        _mapController.move(const LatLng(-14.235, -51.925), 10),
                  ),
                  const SizedBox(height: 8),
                  _buildMapBtn(
                    Icons.add,
                    () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMapBtn(
                    Icons.remove,
                    () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMapBtn(Icons.straighten, () {}), // Measure
                  const SizedBox(height: 8),
                  _buildMapBtn(
                    Icons.edit,
                    () => drawingController.startDrawing(),
                  ),
                ],
              ),
            ),

            // LAYERS BOX
            // ┌───────────────────────────┐
            // │ Camadas:                  │
            // ...
            Positioned(
              left: 16,
              bottom: 24,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Camadas:',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 8),
                    _buildLayerItem('Minhas Áreas', true),
                    _buildLayerItem('Ocorrências', true),
                    _buildLayerItem('NDVI', false),
                    _buildLayerItem('Radar Clima', false),
                  ],
                ),
              ),
            ),
          ] else ...[
            // DRAWING TOOLBAR (Bottom)
            const Align(
              alignment: Alignment.bottomCenter,
              child: DrawingToolbar(),
            ),

            // Top Right Save Button while drawing (if enough points)
            Positioned(
              top: 40,
              right: 70, // To left of settings
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
        ],
      ),
    );
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

  Widget _buildLayerItem(String label, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
          size: 18,
          color: isChecked ? AppColors.primary : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _handleMapTap(
    LatLng point,
    DrawingController controller,
    DrawingState state,
  ) {
    if (state.isDrawing) {
      if (state.activeTool == 'circle' && state.circleCenter == null) {
        controller.addPoint(point); // Center
        // Mock radius update
        const distance = Distance();
        controller.updateCircleRadius(distance.offset(point, 100, 90));
      } else if (state.activeTool == 'polygon') {
        if (state.currentPoints.isNotEmpty &&
            state.currentPoints.length >= 3 &&
            GeometryUtils.isClosingPoint(state.currentPoints.first, point)) {
          _showSaveDialog(context, controller);
        } else {
          controller.addPoint(point);
        }
      }
    } else {
      // Check tap on existing area
      GeoArea? tapped;
      for (final area in state.savedAreas.reversed) {
        if (GeometryUtils.isPointInPolygon(point, area.points)) {
          tapped = area;
          break;
        }
      }
      if (tapped != null) {
        controller.selectArea(tapped.id);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx) => AreaDetailsSheet(
            area: tapped!,
            onDelete: () {
              Navigator.pop(ctx);
              controller.deleteArea(tapped!.id);
            },
            onEdit: () {
              Navigator.pop(ctx);
              controller.startEditingArea(tapped!);
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
  }

  void _showSaveDialog(BuildContext context, DrawingController controller) {
    PremiumDialog.show(
      context: context,
      builder: (context) =>
          SaveAreaDialog(onSave: (name) => controller.saveArea(name)),
    );
  }
}
