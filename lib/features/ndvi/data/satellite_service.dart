import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:image/image.dart' as img; // Import image package
import 'package:soloforte_app/core/config/satellite_config.dart';
// Updated import to domain entity
import 'package:soloforte_app/features/ndvi/domain/ndvi_heatmap_point.dart';

class SatelliteService {
  final Dio _dio = Dio();

  // Sentinel Hub OGC Base URL
  final String _baseUrl =
      'https://services.sentinel-hub.com/ogc/wms/${SatelliteConfig.sentinelInstanceId}';

  /// Fetches raw NIR (B08) and Red (B04) pixel data for a given polygon.
  /// Returns a byte buffer containing the image data (e.g., GeoTIFF).
  Future<Uint8List?> fetchRawSatelliteData(List<LatLng> polygonPoints) async {
    try {
      final bbox = _calculateBBox(polygonPoints);

      // EvalScript to return Red (B04), NIR (B08), Blue (B02) and Cloud Mask (SCL)
      // EVI Formula requires Blue band.
      const evalScript = '''
        //VERSION=3
        function setup() {
          return {
            input: ["B04", "B08", "B02", "SCL"],
            output: { bands: 4, sampleType: "FLOAT32" }
          };
        }

        function evaluatePixel(sample) {
          // SCL Constants: 
          // 0: NoData, 1: Saturated, 3: CloudShadow, 8: CloudMed, 9: CloudHigh, 10: Cirrus, 11: Snow
          var badClasses = [0, 1, 3, 8, 9, 10, 11];
          var isInvalid = badClasses.includes(sample.SCL);
          
          return [sample.B04, sample.B08, sample.B02, isInvalid ? 0.0 : 1.0];
        }
      ''';

      // Construct WMS Request
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'REQUEST': 'GetMap',
          'CRS': 'CRS:84', // WGS84
          'BBOX': '${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]}',
          'LAYERS': 'NDVI',
          'WIDTH': '64',
          'HEIGHT': '64',
          'FORMAT': 'image/tiff;depth=32f',
          'EVALSCRIPT': evalScript,
        },
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error fetching satellite data: $e');
      return null;
    }
  }

  /// Fetches statistical data (mean, stDev, min, max) for the area directly from the server.
  /// Uses Sentinel Hub FIS (Feature Info Service) to avoid downloading full images.
  /// Returns a Map with statistical data or null if failed.
  /// [startDate] and [endDate] define the time range for the Time Series (optional, defaults to latest).
  Future<Map<String, dynamic>?> fetchStatistics(
    List<LatLng> polygonPoints, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // EvalScript for Statistics:
      // We process NDVI per pixel and output it so the server calculates stats on NDVI values.
      const statsEvalScript = '''
        //VERSION=3
        function setup() {
          return {
            input: ["B04", "B08", "SCL"],
            output: { bands: 1, sampleType: "FLOAT32" }
          };
        }

        function evaluatePixel(sample) {
          // Cloud Masking
          var badClasses = [0, 1, 3, 8, 9, 10, 11];
          if (badClasses.includes(sample.SCL)) {
             return [NaN]; // Exclude from stats
          }

          var ndvi = 0.0;
          if ((sample.B08 + sample.B04) != 0) {
            ndvi = (sample.B08 - sample.B04) / (sample.B08 + sample.B04);
          }
          return [ndvi];
        }
      ''';

      final wkt = _toWkt(polygonPoints);

      // FIS URL
      final fisUrl =
          'https://services.sentinel-hub.com/ogc/fis/${SatelliteConfig.sentinelInstanceId}';

      final queryParams = {
        'LAYER': 'NDVI', // Logical layer name
        'CRS': 'CRS:84',
        'GEOMETRY': wkt, // WKT Polygon
        'RESOLUTION': '10', // 10m per pixel (Sentinel Native)
        'EVALSCRIPT': statsEvalScript,
        'type': 'application/json',
      };

      // Handle Time Range
      if (startDate != null && endDate != null) {
        // Format: YYYY-MM-DDThh:mm:ss/YYYY-MM-DDThh:mm:ss
        final startStr = startDate.toIso8601String().split('.')[0];
        final endStr = endDate.toIso8601String().split('.')[0];
        queryParams['TIME'] = '$startStr/$endStr';
      }

      final response = await _dio.get(fisUrl, queryParameters: queryParams);

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error fetching statistics: $e');
      return null;
    }
  }

  String _toWkt(List<LatLng> points) {
    if (points.isEmpty) return "";
    final buffer = StringBuffer("POLYGON((");
    for (var i = 0; i < points.length; i++) {
      buffer.write("${points[i].longitude} ${points[i].latitude},");
    }
    // Close loop
    if (points.isNotEmpty) {
      buffer.write("${points[0].longitude} ${points[0].latitude}");
    }
    buffer.write("))");
    return buffer.toString();
  }

  /// Parses the raw GeoTIFF bytes and calculates real Vegetation Index for each pixel.
  /// [useEvi] - If true, calculates Enhanced Vegetation Index (EVI) instead of NDVI.
  /// Uses manual binary parsing to ensure Float32 precision is preserved.
  List<NdviHeatmapPoint> parseNdviData(
    Uint8List tiffBytes, {
    bool useEvi = false,
  }) {
    try {
      // 1. Try safe manual parsing for Float32 precision
      return _parseTiffFloat32(tiffBytes, useEvi: useEvi);
    } catch (e) {
      print('Manual TIFF parsing failed ($e), falling back to library...');
      // 2. Fallback to Image library (might lose precision but better than crash)
      final image = img.decodeTiff(tiffBytes);
      if (image == null) return [];

      final points = <NdviHeatmapPoint>[];
      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          // Library might map 4 bands to R, G, B, A
          final red = pixel.r;
          final nir = pixel.g;
          final blue = pixel.b;
          final mask = pixel.a; // 4th band mapped to Alpha
          _addPoint(
            points,
            x,
            y,
            image.width,
            image.height,
            red,
            nir,
            blue,
            mask,
            useEvi,
          );
        }
      }
      return points;
    }
  }

  void _addPoint(
    List<NdviHeatmapPoint> points,
    int x,
    int y,
    int width,
    int height,
    num red,
    num nir,
    num blue,
    num mask,
    bool useEvi,
  ) {
    // Check Cloud Mask (1.0 = Valid, 0.0 = Invalid)
    if (mask < 0.5) return; // Skip clouds/shadows

    double value = 0.0;

    if (useEvi) {
      // EVI Formula: 2.5 * ((NIR - Red) / (NIR + 6 * Red - 7.5 * Blue + 1))
      final numerator = nir - red;
      final denominator = nir + (6.0 * red) - (7.5 * blue) + 1.0;
      if (denominator != 0) {
        value = 2.5 * (numerator / denominator);
      }
    } else {
      // NDVI Formula: (NIR - Red) / (NIR + Red)
      if ((nir + red) != 0) {
        value = (nir - red) / (nir + red);
      }
    }

    // Check for empty/padding pixels (all zeros)
    if (red == 0 && nir == 0 && blue == 0) return;

    points.add(
      NdviHeatmapPoint(
        x: x / width,
        y: y / height,
        ndviValue: value.clamp(-1.0, 1.0),
      ),
    );
  }

  /// Minimal manual TIFF parser to extract uncompressed Float32 strips
  List<NdviHeatmapPoint> _parseTiffFloat32(
    Uint8List bytes, {
    required bool useEvi,
  }) {
    final data = ByteData.view(bytes.buffer);

    // 1. Header
    // Byte Order: II (0x4949) = Little Endian, MM (0x4D4D) = Big Endian
    final byteOrder = data.getUint16(0);
    final isLittleEndian = byteOrder == 0x4949;
    final endian = isLittleEndian ? Endian.little : Endian.big;

    if (byteOrder != 0x4949 && byteOrder != 0x4D4D) {
      throw Exception("Invalid TIFF Header");
    }

    final magic = data.getUint16(2, endian);
    if (magic != 42) throw Exception("Not a TIFF file");

    final ifdOffset = data.getUint32(4, endian);

    // 2. Read IFD
    // Simple parser: assuming 1st IFD has what we need
    int currentPos = ifdOffset;
    final numEntries = data.getUint16(currentPos, endian);
    currentPos += 2;

    int? width;
    int? height;
    List<int> stripOffsets = [];
    List<int> stripByteCounts = [];

    for (var i = 0; i < numEntries; i++) {
      final tag = data.getUint16(currentPos, endian);
      // type and count unused in simplified parser
      data.getUint16(currentPos + 2, endian); // Read type to advance currentPos
      final count = data.getUint32(currentPos + 4, endian);
      // Value or Offset to value
      final valueOrOffset = data.getUint32(currentPos + 8, endian);

      currentPos += 12;

      // Processing specific tags
      if (tag == 256) width = valueOrOffset; // ImageWidth
      if (tag == 257) height = valueOrOffset; // ImageLength
      // 258 (BitsPerSample) and 339 (SampleFormat) unused in simplified logic
      // as we assume 32f based on request
      if (tag == 273) {
        // StripOffsets
        if (count == 1) {
          stripOffsets.add(valueOrOffset);
        } else {
          // If multiple strips, follow offset.
          // Implementing only single strip logic for simplicity of this snippet
          // or direct offset reading if fits.
          // Failsafe:
          stripOffsets.add(valueOrOffset);
        }
      }
      if (tag == 279) {
        // StripByteCounts
        if (count == 1) stripByteCounts.add(valueOrOffset);
      }
      // Tag 339 (SampleFormat) skipped
    }

    if (width == null || height == null || stripOffsets.isEmpty) {
      throw Exception("Missing basic TIFF tags");
    }

    // 3. Read Data
    // Assuming Single Strip for small WMS tile logic or just reading first strip
    final points = <NdviHeatmapPoint>[];
    final stripOffset = stripOffsets[0];

    // Requesting 4 bands (Red, NIR, Blue, Mask) -> 4 * Float32 = 16 bytes per pixel
    int dataPtr = stripOffset;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (dataPtr + 16 > bytes.length) break;

        // Read 4 Float32s
        final red = data.getFloat32(dataPtr, endian);
        final nir = data.getFloat32(dataPtr + 4, endian);
        final blue = data.getFloat32(dataPtr + 8, endian);
        final mask = data.getFloat32(dataPtr + 12, endian);

        dataPtr += 16; // 4 floats * 4 bytes

        _addPoint(points, x, y, width, height, red, nir, blue, mask, useEvi);
      }
    }

    return points;
  }

  /// Calculates the Bounding Box [minX, minY, maxX, maxY] for a polygon
  List<double> _calculateBBox(List<LatLng> points) {
    if (points.isEmpty) return [0, 0, 0, 0];

    double minX = points[0].longitude;
    double minY = points[0].latitude;
    double maxX = points[0].longitude;
    double maxY = points[0].latitude;

    for (var point in points) {
      if (point.longitude < minX) minX = point.longitude;
      if (point.latitude < minY) minY = point.latitude;
      if (point.longitude > maxX) maxX = point.longitude;
      if (point.latitude > maxY) maxY = point.latitude;
    }

    return [minX, minY, maxX, maxY];
  }
}
