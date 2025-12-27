import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import '../application/geometry_utils.dart';
import '../domain/geo_area.dart';

// State for the drawing mode
class DrawingState {
  final bool isDrawing;
  final List<LatLng> currentPoints;
  final List<List<LatLng>> history; // For undo support
  final List<GeoArea> savedAreas;
  final String? selectedAreaId;
  final String activeTool; // 'polygon', 'circle', 'rectangle'
  final LatLng? circleCenter;
  final double circleRadius;
  final String? editingAreaId; // ID of the area being edited

  const DrawingState({
    this.isDrawing = false,
    this.currentPoints = const [],
    this.history = const [],
    this.savedAreas = const [],
    this.selectedAreaId,
    this.activeTool = 'polygon',
    this.circleCenter,
    this.circleRadius = 0.0,
    this.editingAreaId,
  });

  DrawingState copyWith({
    bool? isDrawing,
    List<LatLng>? currentPoints,
    List<List<LatLng>>? history,
    List<GeoArea>? savedAreas,
    String? selectedAreaId,
    String? activeTool,
    LatLng? circleCenter,
    double? circleRadius,
    String? editingAreaId,
  }) {
    return DrawingState(
      isDrawing: isDrawing ?? this.isDrawing,
      currentPoints: currentPoints ?? this.currentPoints,
      history: history ?? this.history,
      savedAreas: savedAreas ?? this.savedAreas,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      activeTool: activeTool ?? this.activeTool,
      circleCenter: circleCenter ?? this.circleCenter,
      circleRadius: circleRadius ?? this.circleRadius,
      editingAreaId: editingAreaId ?? this.editingAreaId,
    );
  }
}

class DrawingController extends Notifier<DrawingState> {
  @override
  DrawingState build() {
    return const DrawingState();
  }

  void setTool(String tool) {
    if (state.editingAreaId != null) {
      return; // Prevent changing tool while editing
    }
    state = state.copyWith(activeTool: tool);
  }

  void startDrawing() {
    state = state.copyWith(
      isDrawing: true,
      currentPoints: [],
      history: [],
      circleCenter: null,
      circleRadius: 0.0,
      editingAreaId: null,
      selectedAreaId: null,
    );
  }

  void stopDrawing() {
    state = state.copyWith(
      isDrawing: false,
      currentPoints: [],
      circleCenter: null,
      circleRadius: 0.0,
      editingAreaId: null,
    );
  }

  void startEditingArea(GeoArea area) {
    // Determine tool based on area type
    // If it's a rectangle, we might treat it as polygon for flexible vertex editing
    // Or try to keep it as rectangle if we strictly support that.
    // For now, let's treat polygon/rectangle as 'polygon' mode (vertex editing)
    // and circle as 'circle' mode.

    final tool = area.type == 'circle' ? 'circle' : 'polygon';

    state = state.copyWith(
      isDrawing: true,
      activeTool: tool,
      currentPoints: area.points,
      circleCenter: area.center, // Center IS persisted for circle
      circleRadius: area.radius,
      editingAreaId: area.id,
      selectedAreaId: null, // Deselect while editing
      history: [area.points], // Add initial state to history for undo?
    );
  }

  void moveVertex(int index, LatLng newPosition) {
    if (!state.isDrawing) return;

    final newPoints = List<LatLng>.from(state.currentPoints);
    if (index >= 0 && index < newPoints.length) {
      newPoints[index] = newPosition;
      state = state.copyWith(currentPoints: newPoints);
    }
  }

  void moveCircleCenter(LatLng newCenter) {
    if (!state.isDrawing || state.activeTool != 'circle') return;
    state = state.copyWith(circleCenter: newCenter);
  }

  void addPoint(LatLng point) {
    if (!state.isDrawing) return;

    if (state.activeTool == 'circle') {
      if (state.circleCenter == null) {
        state = state.copyWith(circleCenter: point, circleRadius: 0);
      } else {
        // Second tap defines radius and finishes? Or just updates?
        // Let's assume tap defines center, then drag/tap update radius.
        // If simply adding point, maybe just update radius based on distance.
        final radius = GeometryUtils.calculateDistance(
          state.circleCenter!,
          point,
        );
        state = state.copyWith(circleRadius: radius);
      }
      return;
    }

    if (state.activeTool == 'rectangle') {
      if (state.currentPoints.isEmpty) {
        // Start point
        state = state.copyWith(currentPoints: [point]);
      } else if (state.currentPoints.length == 1) {
        // End point - generate rectangle immediately
        final p1 = state.currentPoints.first;
        final rectPoints = GeometryUtils.createRectanglePolygon(p1, point);
        state = state.copyWith(currentPoints: rectPoints);
      } else {
        // If we already have a rectangle (4 points), maybe reset or modify?
        // Let's assume user wants to reset if they tap again, or we just ignore.
        // Or better: clear and start new?
        // Let's stick to "Tap 2 closes and prepares for save".
        // But the user might want to adjust.
        // For simplified V1:
        // If has 4 points (rectangle formed), do nothing or reset?
        // Let's say we clear if they want to start over, but they probably use Undo/Clear buttons.
        // Let's allow replacing the "end point" if they tap again? No, that's complex without drag.
      }
      return;
    }

    // Polygon logic
    final newPoints = [...state.currentPoints, point];
    final newHistory = [...state.history, state.currentPoints];

    state = state.copyWith(currentPoints: newPoints, history: newHistory);
  }

  void updateCircleRadius(LatLng point) {
    if (!state.isDrawing ||
        state.activeTool != 'circle' ||
        state.circleCenter == null) {
      return;
    }
    final radius = GeometryUtils.calculateDistance(state.circleCenter!, point);
    state = state.copyWith(circleRadius: radius);
  }

  void undoLastPoint() {
    if (state.history.isEmpty) return;

    final previousPoints = state.history.last;
    final newHistory = List<List<LatLng>>.from(state.history)..removeLast();

    state = state.copyWith(currentPoints: previousPoints, history: newHistory);
  }

  void saveArea(String name) {
    if (state.activeTool == 'polygon' && state.currentPoints.length < 3) return;
    if (state.activeTool == 'circle' &&
        (state.circleCenter == null || state.circleRadius == 0)) {
      return;
    }
    if (state.activeTool == 'rectangle' && state.currentPoints.isEmpty) {
      return; // Should have points
    }

    double areaHectares = 0;
    double perimeterKm = 0;
    LatLng? center;
    List<LatLng> points = [];

    if (state.activeTool == 'circle') {
      areaHectares = GeometryUtils.calculateCircleAreaHectares(
        state.circleRadius,
      );
      // Perimeter = 2 * pi * r
      perimeterKm = (2 * math.pi * state.circleRadius) / 1000.0;
      center = state.circleCenter;
      // Generate points for polygon representation/compatibility
      points = GeometryUtils.createCirclePolygon(
        state.circleCenter!,
        state.circleRadius,
      );
    } else {
      // Rectangle or Polygon
      // If rectangle, maybe ensure it's closed?
      points = state.currentPoints;
      areaHectares = GeometryUtils.calculateAreaHectares(points);
      perimeterKm = GeometryUtils.calculatePerimeterKm(points);
      center = GeometryUtils.calculateCentroid(points);
    }

    // specific logic for updates
    if (state.editingAreaId != null) {
      // Update existing
      final updatedSavedAreas = state.savedAreas.map((area) {
        if (area.id == state.editingAreaId) {
          return area.copyWith(
            name: name,
            points: points,
            areaHectares: areaHectares,
            perimeterKm: perimeterKm,
            center: center,
            type: state.activeTool == 'rectangle'
                ? 'polygon'
                : state.activeTool,
            radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
          );
        }
        return area;
      }).toList();

      state = state.copyWith(
        savedAreas: updatedSavedAreas,
        isDrawing: false,
        currentPoints: [],
        history: [],
        circleCenter: null,
        circleRadius: 0.0,
        editingAreaId: null,
      );
    } else {
      // Create New
      final newArea = GeoArea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        points: points,
        createdAt: DateTime.now(),
        areaHectares: areaHectares,
        perimeterKm: perimeterKm,
        center: center,
        type: state.activeTool,
        radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
      );

      state = state.copyWith(
        savedAreas: [...state.savedAreas, newArea],
        isDrawing: false,
        currentPoints: [],
        history: [],
        circleCenter: null,
        circleRadius: 0.0,
        editingAreaId: null,
      );
    }
  }

  void selectArea(String? id) {
    state = state.copyWith(selectedAreaId: id);
  }

  void deleteArea(String id) {
    final newAreas = state.savedAreas.where((a) => a.id != id).toList();
    state = state.copyWith(
      savedAreas: newAreas,
      selectedAreaId: state.selectedAreaId == id ? null : state.selectedAreaId,
    );
  }

  void importArea(GeoArea area) {
    state = state.copyWith(savedAreas: [...state.savedAreas, area]);
  }
}

final drawingControllerProvider =
    NotifierProvider<DrawingController, DrawingState>(() {
      return DrawingController();
    });
