import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/areas/domain/entities/area.dart';
import 'package:soloforte_app/features/areas/presentation/providers/areas_controller.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';

class AreasLayer extends ConsumerWidget {
  const AreasLayer({super.key});

  Color _getAreaColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      case 'draft':
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(areasControllerProvider);
    final drawingState = ref.watch(drawingControllerProvider);

    // Newly drawn/imported areas (Session) (Exclude editing)
    final sessionAreas = drawingState.savedAreas
        .where((area) => area.id != drawingState.editingAreaId)
        .toList();
    final sessionIds = sessionAreas.map((a) => a.id).toSet();

    // Existing DB Areas (Exclude editing AND overridden by session)
    final dbAreas = (areasAsync.valueOrNull ?? [])
        .where(
          (area) =>
              area.id != drawingState.editingAreaId &&
              !sessionIds.contains(area.id),
        )
        .toList();

    return PolygonLayer(
      polygons: [
        // 1. Render Database Areas
        ...dbAreas.map((Area area) {
          return Polygon(
            points: area.coordinates,
            // Area entity doesn't support holes yet
            color: _getAreaColor(area.status).withValues(alpha: 0.3),
            borderColor: _getAreaColor(area.status),
            borderStrokeWidth: 2,
            label: area.name,
            labelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            rotateLabel: true,
          );
        }),

        // 2. Render Session GeoAreas (with Hole Support!)
        ...sessionAreas.map((GeoArea geoArea) {
          return Polygon(
            points: geoArea.points,
            holePointsList: geoArea.holes,
            color: _getAreaColor('draft').withValues(alpha: 0.3),
            borderColor: _getAreaColor('draft'),
            borderStrokeWidth: 2,
            label: "${geoArea.name} (Novo)",
            labelStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            rotateLabel: true,
          );
        }),
      ],
    );
  }
}
