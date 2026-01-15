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
    if (area.activeVisitId != null) return;
    final tool = area.type == 'circle' ? 'circle' : 'polygon';

    state = state.copyWith(
      isDrawing: true,
      activeTool: tool,
      currentPoints: area.points,
      circleCenter: area.center,
      circleRadius: area.radius,
      editingAreaId: area.id,
      selectedAreaId: null,
      history: [area.points],
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

  void removeVertex(int index) {
    if (!state.isDrawing || state.currentPoints.length <= 3) return;

    final newPoints = List<LatLng>.from(state.currentPoints)..removeAt(index);
    state = state.copyWith(currentPoints: newPoints);
  }

  void insertVertex(int index, LatLng point) {
    if (!state.isDrawing) return;
    final newPoints = List<LatLng>.from(state.currentPoints);
    // Insert after the index
    newPoints.insert(index + 1, point);
    state = state.copyWith(currentPoints: newPoints);
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

  void saveArea({
    required String name,
    String? clientId,
    String? clientName,
    String? fieldId,
    String? fieldName,
    String? notes,
    int? colorValue,
    bool isDashed = false,
  }) {
    if (state.activeTool == 'polygon' && state.currentPoints.length < 3) {
      return;
    }

    // ... validation ...

    double areaHectares = 0;
    double perimeterKm = 0;
    LatLng? center;
    List<LatLng> points = [];

    if (state.activeTool == 'circle') {
      // Standard circle
      areaHectares = GeometryUtils.calculateCircleAreaHectares(
        state.circleRadius,
      );
      perimeterKm = (2 * math.pi * state.circleRadius) / 1000.0;
      points = GeometryUtils.createCirclePolygon(
        state.circleCenter!,
        state.circleRadius,
      );
      center = state.circleCenter;
    } else {
      // Polygon
      points = state.currentPoints;
      areaHectares = GeometryUtils.calculateAreaHectares(points);
      perimeterKm = GeometryUtils.calculatePerimeterKm(points);
      center = GeometryUtils.calculateCentroid(points);
    }

    final newAreaType = state.activeTool == 'circle' ? 'circle' : 'polygon';

    if (state.editingAreaId != null) {
      // Update existing
      final updatedSavedAreas = state.savedAreas.map((area) {
        if (area.id == state.editingAreaId) {
          return area.copyWith(
            name: name,
            points: points,
            holes: [], // Holes wiped on edit
            areaHectares: areaHectares,
            perimeterKm: perimeterKm,
            center: center,
            type: newAreaType,
            radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
            clientId: clientId ?? area.clientId,
            clientName: clientName ?? area.clientName,
            fieldId: fieldId ?? area.fieldId,
            fieldName: fieldName ?? area.fieldName,
            notes: notes ?? area.notes,
            colorValue: colorValue ?? area.colorValue,
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
        holes: [],
        createdAt: DateTime.now(),
        areaHectares: areaHectares,
        perimeterKm: perimeterKm,
        center: center,
        type: newAreaType,
        radius: state.activeTool == 'circle' ? state.circleRadius : 0.0,
        clientId: clientId,
        clientName: clientName,
        fieldId: fieldId,
        fieldName: fieldName,
        notes: notes,
        colorValue: colorValue,
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

  void updateAreaVisitStatus(
    String areaId, {
    String? activeVisitId,
    DateTime? lastVisitDate,
  }) {
    final updatedAreas = state.savedAreas.map((area) {
      if (area.id == areaId) {
        return area.copyWith(
          activeVisitId: activeVisitId,
          lastVisitDate: lastVisitDate ?? area.lastVisitDate,
        );
      }
      return area;
    }).toList();

    state = state.copyWith(savedAreas: updatedAreas);
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
          holes: [], // Ignore holes on import
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
