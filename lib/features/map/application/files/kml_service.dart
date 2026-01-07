import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;

class KmlService {
  Future<List<GeoArea>> pickAndParseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['kml', 'kmz'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return [];

    final file = result.files.first;
    String kmlContent = '';

    try {
      if (file.extension == 'kmz') {
        // Handle KMZ (Zip)
        final bytes = file.bytes ?? await File(file.path!).readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        // Find the .kml file inside
        final kmlFile = archive.files.firstWhere(
          (f) => f.name.toLowerCase().endsWith('.kml'),
          orElse: () => throw Exception('No KML file found in KMZ'),
        );

        kmlContent = String.fromCharCodes(kmlFile.content as List<int>);
      } else {
        // Handle KML
        if (file.bytes != null) {
          kmlContent = String.fromCharCodes(file.bytes!);
        } else if (file.path != null) {
          kmlContent = await File(file.path!).readAsString();
        }
      }

      if (kmlContent.isEmpty) return [];

      return _parseKml(kmlContent, file.name);
    } catch (e) {
      print('Error parsing KML/KMZ: $e');
      return []; // Return empty list on error
    }
  }

  List<GeoArea> _parseKml(String kmlString, String fileName) {
    final document = XmlDocument.parse(kmlString);
    final areas = <GeoArea>[];

    // Find all Placemarks
    final placemarks = document.findAllElements('Placemark');

    for (var placemark in placemarks) {
      try {
        final name =
            placemark.findElements('name').firstOrNull?.innerText ??
            path.basenameWithoutExtension(fileName);

        // Check for Polygon
        final polygon = placemark.findAllElements('Polygon').firstOrNull;
        if (polygon != null) {
          final outerBoundary = polygon
              .findAllElements('outerBoundaryIs')
              .firstOrNull;
          if (outerBoundary != null) {
            final coordinates = outerBoundary
                .findAllElements('coordinates')
                .firstOrNull;
            if (coordinates != null) {
              final points = _parseCoordinates(coordinates.innerText);
              if (points.isNotEmpty) {
                // Create GeoArea
                // Calculate metrics (simplified)
                final center = _calculateCentroid(points);

                areas.add(
                  GeoArea(
                    id:
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        areas.length.toString(),
                    name: name,
                    points: points,
                    createdAt: DateTime.now(),
                    areaHectares: 0, // Calculate properly later if possible
                    perimeterKm: 0,
                    center: center,
                    type: 'polygon',
                    radius: 0,
                  ),
                );
              }
            }
          }
        }
      } catch (e) {
        print('Error parsing placemark: $e');
        continue;
      }
    }

    return areas;
  }

  List<LatLng> _parseCoordinates(String coordinatesText) {
    final points = <LatLng>[];
    // Coordinate format: lon,lat,alt lon,lat,alt ...
    final coords = coordinatesText.trim().split(RegExp(r'\s+'));

    for (var coord in coords) {
      final parts = coord.split(',');
      if (parts.length >= 2) {
        try {
          final lon = double.parse(parts[0]);
          final lat = double.parse(parts[1]);
          points.add(LatLng(lat, lon));
        } catch (e) {
          // ignore invalid point
        }
      }
    }
    return points;
  }

  LatLng _calculateCentroid(List<LatLng> points) {
    double latSum = 0;
    double lonSum = 0;
    for (var p in points) {
      latSum += p.latitude;
      lonSum += p.longitude;
    }
    return LatLng(latSum / points.length, lonSum / points.length);
  }
}
