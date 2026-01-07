/// Represents a normalized data point for NDVI Heatmap visualization.
class NdviHeatmapPoint {
  final double x; // 0.0 to 1.0 (Horizontal Position)
  final double y; // 0.0 to 1.0 (Vertical Position)
  final double ndviValue; // -1.0 to 1.0 (NDVI Index)

  NdviHeatmapPoint({required this.x, required this.y, required this.ndviValue});
}
