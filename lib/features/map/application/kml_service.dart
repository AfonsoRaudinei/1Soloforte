import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xml/xml.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import '../domain/geo_area.dart';
import 'geometry_utils.dart';

class KmlService {
  /// Import KML/KMZ file and parse geometries
  Future<List<GeoArea>> pickAndParseKml() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['kml', 'xml'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        return parseKmlContent(content);
      }
    } catch (e) {
      LoggerService.e('Error picking/parsing KML', error: e, tag: 'KML');
    }
    return [];
  }

  /// Parse KML content string to GeoAreas
  List<GeoArea> parseKmlContent(String kmlContent) {
    final List<GeoArea> areas = [];
    try {
      final document = XmlDocument.parse(kmlContent);
      final placemarks = document.findAllElements('Placemark');

      for (final placemark in placemarks) {
        final name =
            placemark.findElements('name').firstOrNull?.text ?? 'Sem nome';
        final description =
            placemark.findElements('description').firstOrNull?.text ?? '';

        // Try Polygon
        final polygon = placemark.findAllElements('Polygon').firstOrNull;
        if (polygon != null) {
          final coordinatesNode = polygon
              .findAllElements('coordinates')
              .firstOrNull;
          if (coordinatesNode != null) {
            final points = _parseCoordinates(coordinatesNode.text);
            if (points.length >= 3) {
              final area = _createGeoAreaFromPoints(
                name,
                points,
                description: description,
              );
              areas.add(area);
            }
          }
        }

        // TODO: Handle LineString or Point if needed, though GeoArea is primarily Polygon/Circle for this app usage
      }
    } catch (e) {
      LoggerService.e('Error parsing KML XML', error: e, tag: 'KML');
    }
    return areas;
  }

  List<LatLng> _parseCoordinates(String coordinatesText) {
    final List<LatLng> points = [];
    final coords = coordinatesText.trim().split(RegExp(r'\s+'));

    for (final coord in coords) {
      final parts = coord.split(',');
      if (parts.length >= 2) {
        final double? lon = double.tryParse(parts[0]);
        final double? lat = double.tryParse(parts[1]);
        if (lat != null && lon != null) {
          points.add(LatLng(lat, lon));
        }
      }
    }
    return points;
  }

  GeoArea _createGeoAreaFromPoints(
    String name,
    List<LatLng> points, {
    String description = '',
  }) {
    // Determine if it's a closed polygon (first == last)
    if (points.isNotEmpty && points.first == points.last) {
      points
          .removeLast(); // We use open lists in our model usually, handled by PolygonLayer
    }

    final areaHectares = GeometryUtils.calculateAreaHectares(points);
    final perimeterKm = GeometryUtils.calculatePerimeterKm(points);
    final center = GeometryUtils.calculateCentroid(points);

    return GeoArea(
      id:
          DateTime.now().millisecondsSinceEpoch.toString() +
          areasCounter.toString(), // Unique-ish
      name: name,
      points: points,
      createdAt: DateTime.now(),
      areaHectares: areaHectares,
      perimeterKm: perimeterKm,
      center: center,
      type: 'polygon', // KML polygons are polygons
    );
  }

  static int areasCounter =
      0; // Simple counter to help with ID generation in a loop

  /// Export list of GeoAreas to KML
  Future<void> exportToKml(List<GeoArea> areas) async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(
      'kml',
      namespaces: {'http://www.opengis.net/kml/2.2': null},
      nest: () {
        builder.element(
          'Document',
          nest: () {
            builder.element('name', nest: 'SoloForte Export');

            // Add Style for Polygons
            builder.element(
              'Style',
              attributes: {'id': 'polyStyle'},
              nest: () {
                builder.element(
                  'LineStyle',
                  nest: () {
                    builder.element('color', nest: 'ff0000ff'); // Red, AABBGGRR
                    builder.element('width', nest: '2');
                  },
                );
                builder.element(
                  'PolyStyle',
                  nest: () {
                    builder.element(
                      'color',
                      nest: '7f0000ff',
                    ); // Semi-transparent Red
                  },
                );
              },
            );

            for (final area in areas) {
              builder.element(
                'Placemark',
                nest: () {
                  builder.element('name', nest: area.name);
                  builder.element(
                    'description',
                    nest:
                        'Área: ${area.areaHectares.toStringAsFixed(2)} ha, Perímetro: ${area.perimeterKm.toStringAsFixed(2)} km',
                  );
                  builder.element('styleUrl', nest: '#polyStyle');

                  if (area.type == 'polygon' ||
                      area.type == 'rectangle' ||
                      area.type == 'circle') {
                    // Note: Circle is exported as polygon points
                    builder.element(
                      'Polygon',
                      nest: () {
                        builder.element(
                          'outerBoundaryIs',
                          nest: () {
                            builder.element(
                              'LinearRing',
                              nest: () {
                                builder.element(
                                  'coordinates',
                                  nest: _formatCoordinates(area.points),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        );
      },
    );

    final document = builder.buildDocument();
    final String kmlString = document.toXmlString(pretty: true);

    await _shareFile(kmlString, 'soloforte_areas.kml');
  }

  Future<void> _shareFile(String content, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Áreas exportadas do SoloForte');
    } catch (e) {
      LoggerService.e('Error sharing KML', error: e, tag: 'KML');
    }
  }

  String _formatCoordinates(List<LatLng> points) {
    if (points.isEmpty) return '';

    // KML expects lon,lat,alt
    // And it needs to be closed loop for polygons
    final buffer = StringBuffer();
    for (final point in points) {
      buffer.write('${point.longitude},${point.latitude},0 ');
    }
    // Close the loop
    if (points.isNotEmpty) {
      buffer.write('${points.first.longitude},${points.first.latitude},0');
    }

    return buffer.toString();
  }
}
