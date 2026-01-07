import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import '../application/geometry_utils.dart';
import '../domain/geo_area.dart';
import 'files/kml_service.dart';

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
  final List<List<LatLng>>
  activeHoles; // Holes for the current area being drawn
  final bool isSubtracting; // If true, current drawing adds to activeHoles
  final List<LatLng> basePoints; // The main polygon points when drawing a hole

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
    this.activeHoles = const [],
    this.isSubtracting = false,
    this.basePoints = const [],
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
    List<List<LatLng>>? activeHoles,
    bool? isSubtracting,
    List<LatLng>? basePoints,
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
      activeHoles: activeHoles ?? this.activeHoles,
      isSubtracting: isSubtracting ?? this.isSubtracting,
      basePoints: basePoints ?? this.basePoints,
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

  void setMode(bool subtracting) {
    if (subtracting) {
      // Enter Subtraction Mode
      if (state.currentPoints.isEmpty && state.editingAreaId == null) return;

      // Move current drawing to basePoints so we can draw the hole
      state = state.copyWith(
        isSubtracting: true,
        basePoints: state.currentPoints,
        currentPoints: [], // Clean slate for hole
        history: [],
      );
    } else {
      // Exit Subtraction Mode
      // Restore main polygon.
      // If we were drawing a hole that wasn't saved, it's lost (or we auto-commit?)
      // Let's discard unfinished hole for safety or maybe commit if valid?

      state = state.copyWith(
        isSubtracting: false,
        currentPoints: state.basePoints, // Restore main
        basePoints: [],
        history: [],
      );
    }
  }

  void stopDrawing() {
    state = state.copyWith(
      isDrawing: false,
      currentPoints: [],
      activeHoles: [],
      basePoints: [],
      circleCenter: null,
      circleRadius: 0.0,
      editingAreaId: null,
      isSubtracting: false,
    );
  }

  void startEditingArea(GeoArea area) {
    final tool = area.type == 'circle' ? 'circle' : 'polygon';

    state = state.copyWith(
      isDrawing: true,
      activeTool: tool,
      currentPoints: area.points,
      activeHoles: area.holes, // Load existing holes
      circleCenter: area.center,
      circleRadius: area.radius,
      editingAreaId: area.id,
      selectedAreaId: null,
      history: [area.points],
      isSubtracting: false,
      basePoints: [],
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
        state = state.copyWith(currentPoints: [point]);
      } else if (state.currentPoints.length == 1) {
        final p1 = state.currentPoints.first;
        final rectPoints = GeometryUtils.createRectanglePolygon(p1, point);
        state = state.copyWith(currentPoints: rectPoints);
      } else {
        state = state.copyWith(currentPoints: [point]);
      }
      return;
    }

    // Polygon logic (Add point)
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

  void commitHole() {
    if (state.currentPoints.length < 3) return;

    state = state.copyWith(
      activeHoles: [...state.activeHoles, state.currentPoints],
      currentPoints: [], // Ready for next hole or finish
      history: [],
      // Keep mode active
    );
  }

  void saveArea(String name) {
    // If we are in subtraction mode and have points, those are a hole pending commit.
    if (state.isSubtracting && state.currentPoints.isNotEmpty) {
      commitHole(); // Commit pending hole first
      // Do not return, continue to save logic?
      // No, if user clicks SAVE while in subtraction mode, they probably mean "Finish Editing".
      // So we commit hole, then restore mode, then save.

      // Auto-exit subtraction mode to prepare for save
      setMode(false);
      // Now state.currentPoints has the basePoints restored.
    } else if (state.isSubtracting) {
      setMode(false); // Just exit mode
    }

    if (state.activeTool == 'polygon' &&
        state.currentPoints.length < 3 &&
        state.activeHoles.isEmpty) {
      return;
    }

    // ... validation ...

    double areaHectares = 0;
    double perimeterKm = 0;
    LatLng? center;
    List<LatLng> points = [];
    List<List<LatLng>> holes = state.activeHoles;

    if (state.activeTool == 'circle') {
      if (holes.isNotEmpty) {
        // Convert circle to polygon to support holes
        points = GeometryUtils.createCirclePolygon(
          state.circleCenter!,
          state.circleRadius,
        );
        // Calculate area = Circle Area - Holes Area
        double holesArea = 0;
        for (var hole in holes) {
          holesArea += GeometryUtils.calculateAreaHectares(hole);
        }
        areaHectares =
            GeometryUtils.calculateCircleAreaHectares(state.circleRadius) -
            holesArea;
        if (areaHectares < 0) areaHectares = 0;

        perimeterKm = (2 * math.pi * state.circleRadius) / 1000.0;
        // Add holes perimeter? Usually yes.
        for (var hole in holes) {
          perimeterKm += GeometryUtils.calculatePerimeterKm(hole);
        }
      } else {
        // Standard circle
        areaHectares = GeometryUtils.calculateCircleAreaHectares(
          state.circleRadius,
        );
        perimeterKm = (2 * math.pi * state.circleRadius) / 1000.0;
        points = GeometryUtils.createCirclePolygon(
          state.circleCenter!,
          state.circleRadius,
        );
      }
      center = state.circleCenter;
    } else {
      // Polygon
      points = state.currentPoints;
      double grossArea = GeometryUtils.calculateAreaHectares(points);
      double holesArea = 0;
      double holesPerim = 0;

      for (var hole in holes) {
        holesArea += GeometryUtils.calculateAreaHectares(hole);
        holesPerim += GeometryUtils.calculatePerimeterKm(hole);
      }

      areaHectares = grossArea - holesArea;
      if (areaHectares < 0) areaHectares = 0;

      perimeterKm = GeometryUtils.calculatePerimeterKm(points) + holesPerim;
      center = GeometryUtils.calculateCentroid(points);
    }

    final newAreaType = (state.activeTool == 'circle' && holes.isEmpty)
        ? 'circle'
        : 'polygon';

    if (state.editingAreaId != null) {
      // Update existing
      final updatedSavedAreas = state.savedAreas.map((area) {
        if (area.id == state.editingAreaId) {
          return area.copyWith(
            name: name,
            points: points,
            holes: holes,
            areaHectares: areaHectares,
            perimeterKm: perimeterKm,
            center: center,
            type: newAreaType,
            radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
          );
        }
        return area;
      }).toList();

      state = state.copyWith(
        savedAreas: updatedSavedAreas,
        isDrawing: false,
        currentPoints: [],
        activeHoles: [],
        history: [],
        circleCenter: null,
        circleRadius: 0.0,
        editingAreaId: null,
        isSubtracting: false,
        basePoints: [],
      );
    } else {
      // Create New
      final newArea = GeoArea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        points: points,
        holes: holes,
        createdAt: DateTime.now(),
        areaHectares: areaHectares,
        perimeterKm: perimeterKm,
        center: center,
        type: newAreaType,
        radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
      );

      state = state.copyWith(
        savedAreas: [...state.savedAreas, newArea],
        isDrawing: false,
        currentPoints: [],
        activeHoles: [],
        history: [],
        circleCenter: null,
        circleRadius: 0.0,
        editingAreaId: null,
        isSubtracting: false,
        basePoints: [],
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

  Future<void> importFromFile() async {
    final kmlService = KmlService();
    // This is async, UI should probably show loading.
    final areas = await kmlService.pickAndParseFile();

    // Calculate proper metrics for imported areas
    final processedAreas = areas.map((area) {
      if (area.type == 'polygon' && area.points.isNotEmpty) {
        final hectares = GeometryUtils.calculateAreaHectares(area.points);
        final perimeter = GeometryUtils.calculatePerimeterKm(area.points);
        // Ensure center is calculated if not present
        final center =
            area.center ?? GeometryUtils.calculateCentroid(area.points);
        return area.copyWith(
          areaHectares: hectares,
          perimeterKm: perimeter,
          center: center,
        );
      }
      return area;
    }).toList();

    if (processedAreas.isNotEmpty) {
      state = state.copyWith(
        savedAreas: [...state.savedAreas, ...processedAreas],
      );
    }
  }
}

final drawingControllerProvider =
    NotifierProvider<DrawingController, DrawingState>(() {
      return DrawingController();
    });
