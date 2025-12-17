import 'dart:ui';

class ScanResult {
  final String id;
  final String imagePath;
  final String scientificName;
  final String commonName;
  final double confidence;
  final double severity; // 0.0 to 1.0
  final String description;
  final List<String> symptoms;
  final String recommendation;
  final DateTime scanDate;
  final List<BoundingBox> detections;
  final ScanType type;

  ScanResult({
    required this.id,
    required this.imagePath,
    required this.scientificName,
    required this.commonName,
    required this.confidence,
    required this.severity,
    required this.description,
    required this.symptoms,
    required this.recommendation,
    required this.scanDate,
    required this.detections,
    required this.type,
  });
}

class BoundingBox {
  final double x; // Normalized 0.0-1.0
  final double y; // Normalized 0.0-1.0
  final double width; // Normalized 0.0-1.0
  final double height; // Normalized 0.0-1.0
  final String label;
  final double confidence;

  BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
    required this.confidence,
  });

  // Helper to convert to absolute coordinates based on image/screen size
  Rect toRect(Size size) {
    return Rect.fromLTWH(
      x * size.width,
      y * size.height,
      width * size.width,
      height * size.height,
    );
  }
}

enum ScanType {
  pest, // Praga
  disease, // Doença
  deficiency, // Deficiência Nutricional
  weed, // Planta Daninha
}
