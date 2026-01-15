import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';

class DrawingLayer extends ConsumerWidget {
  const DrawingLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawingState = ref.watch(drawingControllerProvider);

    if (!drawingState.isDrawing) return const SizedBox.shrink();

    // FieldView Style Config
    const vertexColor = AppColors.surface;
    const vertexStroke = Colors.black;

    // Determine points to render for Main Polygon
    final mainPoints = drawingState.currentPoints;

    return Stack(
      children: [
        // 1. Polygon/Line Layer (Main Shape)
        if (mainPoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  ...mainPoints,
                  if (drawingState.activeTool == 'polygon' &&
                      mainPoints.length > 2)
                    mainPoints.first,
                ],
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ],
          ),

        if (drawingState.activeTool == 'polygon' && mainPoints.length > 2)
          PolygonLayer(
            polygons: [
              Polygon(
                points: mainPoints,
                // Holes removed per simplification requirement
                holePointsList: [],
                color: AppColors.primary.withValues(alpha: 0.2),
                borderStrokeWidth: 0,
              ),
            ],
          ),

        // 3. Circle Layer
        if (drawingState.activeTool == 'circle' &&
            drawingState.circleCenter != null &&
            drawingState.circleRadius > 0)
          CircleLayer(
            circles: [
              CircleMarker(
                point: drawingState.circleCenter!,
                radius: drawingState.circleRadius,
                useRadiusInMeter: true,
                color: AppColors.primary.withValues(alpha: 0.3),
                borderColor: AppColors.primary,
                borderStrokeWidth: 2,
              ),
            ],
          ),

        // 4. Vertices Markers (Editor Handles) - DRAGGABLE
        if (drawingState.currentPoints.isNotEmpty)
          MarkerLayer(
            markers: drawingState.currentPoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;

              return Marker(
                point: point,
                width: 32, // Hitbox
                height: 32,
                child: GestureDetector(
                  onDoubleTap: () {
                    // Remove vertex on double tap
                    ref
                        .read(drawingControllerProvider.notifier)
                        .removeVertex(index);
                  },
                  onPanUpdate: (details) {
                    // Start dragging
                    final mapCamera = MapCamera.of(context);
                    final renderBox = context.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      final localPosition = renderBox.globalToLocal(
                        details.globalPosition,
                      );
                      // Use screenOffsetToLatLng as per flutter_map v6+ conventions for MapCamera
                      final newLatLng = mapCamera.screenOffsetToLatLng(
                        localPosition,
                      );

                      ref
                          .read(drawingControllerProvider.notifier)
                          .moveVertex(index, newLatLng);
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 18, // Visual size
                      height: 18,
                      decoration: BoxDecoration(
                        color: vertexColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: vertexStroke, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        // 5. Center Handle for Circle - DRAGGABLE
        if (drawingState.activeTool == 'circle' &&
            drawingState.circleCenter != null)
          MarkerLayer(
            markers: [
              Marker(
                point: drawingState.circleCenter!,
                width: 32,
                height: 32,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final mapCamera = MapCamera.of(context);
                    final renderBox = context.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      final localPosition = renderBox.globalToLocal(
                        details.globalPosition,
                      );
                      final newLatLng = mapCamera.screenOffsetToLatLng(
                        localPosition,
                      );

                      ref
                          .read(drawingControllerProvider.notifier)
                          .moveCircleCenter(newLatLng);
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: vertexColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: vertexStroke, width: 2),
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
                ),
              ),
            ],
          ),

        // 6. Resize Handle for Circle - DRAGGABLE
        if (drawingState.activeTool == 'circle' &&
            drawingState.circleCenter != null &&
            drawingState.circleRadius > 0)
          MarkerLayer(
            markers: [
              Marker(
                point: const Distance().offset(
                  drawingState.circleCenter!,
                  drawingState.circleRadius,
                  90,
                ),
                width: 32,
                height: 32,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final mapCamera = MapCamera.of(context);
                    final renderBox = context.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      final localPosition = renderBox.globalToLocal(
                        details.globalPosition,
                      );
                      final newLatLng = mapCamera.screenOffsetToLatLng(
                        localPosition,
                      );

                      ref
                          .read(drawingControllerProvider.notifier)
                          .updateCircleRadius(newLatLng);
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.open_in_full,
                        size: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
