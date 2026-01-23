import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:soloforte_app/core/config/sentinel_config.dart';
import 'package:soloforte_app/features/ndvi/data/models/sentinel_token.dart';

class SentinelService {
  final Dio _dio = Dio();
  SentinelToken? _currentToken;

  SentinelService() {
    _dio.options.headers['Content-Type'] = 'application/json';
    // Add interceptor for logging? Maybe later.
  }

  /// Authenticate with Sentinel Hub using Client Credentials
  Future<void> authenticate() async {
    try {
      final clientId = SentinelConfig.clientId;
      final clientSecret = SentinelConfig.clientSecret;

      if (clientId == 'YOUR_CLIENT_ID_HERE' ||
          clientSecret == 'YOUR_CLIENT_SECRET_HERE') {
        throw Exception(
          'Sentinel Credentials not configured properly in sentinel_config.dart',
        );
      }

      final response = await _dio.post(
        SentinelConfig.authUrl,
        data: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      _currentToken = SentinelToken.fromJson(
        response.data,
      ).copyWith(receivedAt: DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      LoggerService.e(
        'Error authenticating with Sentinel Hub',
        error: e,
        tag: 'SENTINEL',
      );
      rethrow;
    }
  }

  /// Ensure we have a valid token, refreshing if necessary
  Future<String> _getValidToken() async {
    if (_currentToken == null) {
      await authenticate();
    } else {
      final now = DateTime.now().millisecondsSinceEpoch;
      // Expires in is in seconds. Buffer of 60 seconds.
      final expirationTime =
          _currentToken!.receivedAt + (_currentToken!.expiresIn * 1000);
      if (now > expirationTime - 60000) {
        await authenticate();
      }
    }
    return _currentToken!.accessToken;
  }

  /// Search for available Sentinel-2 images in a given bbox and date range
  /// Returns a list of features (scenes)
  Future<List<Map<String, dynamic>>> searchImages({
    required List<double> bbox, // [minX, minY, maxX, maxY]
    required DateTime startDate,
    required DateTime endDate,
    double maxCloudCover = 20.0,
  }) async {
    try {
      final token = await _getValidToken();
      final fromDate = startDate.toIso8601String();
      final toDate = endDate.toIso8601String();

      final body = {
        "collections": [SentinelConfig.sentinel2CollectionId],
        "datetime": "$fromDate/$toDate",
        "bbox": bbox,
        "filter": {
          "op": "<=",
          "args": [
            {"property": "eo:cloud_cover"},
            maxCloudCover,
          ],
        },
        "limit": 10, // Limit to 10 most recent results
      };

      final response = await _dio.post(
        '${SentinelConfig.catalogUrl}/search',
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final features = List<Map<String, dynamic>>.from(
        response.data['features'],
      );
      return features;
    } catch (e) {
      LoggerService.e('Error searching images', error: e, tag: 'SENTINEL');
      rethrow;
    }
  }

  /// Fetch a processed NDVI image (PNG) for a specific bbox and time
  /// Returns raw bytes of the image
  Future<Uint8List> fetchNDVIImage({
    required List<double> bbox,
    Map<String, dynamic>? geometry, // Optional geometry for clipping
    required DateTime date,
    required int width,
    required int height,
  }) async {
    try {
      final token = await _getValidToken();

      // NDVI Evalscript with requested color scale
      // Vermelho (-1.0 a 0.2)
      // Amarelo (0.2 a 0.4)
      // Verde claro (0.4 a 0.6)
      // Verde escuro (0.6 a 1.0)
      const evalscript = '''
      //VERSION=3
      function setup() {
        return {
          input: ["B04", "B08", "dataMask"],
          output: { bands: 4 }
        };
      }

      function evaluatePixel(sample) {
        let ndvi = (sample.B08 - sample.B04) / (sample.B08 + sample.B04);
        
        if (sample.dataMask == 0) return [0, 0, 0, 0];

        // Custom Color Map
        if (ndvi < 0.2) return [1, 0, 0, 1]; // Red
        if (ndvi < 0.4) return [1, 1, 0, 1]; // Yellow
        if (ndvi < 0.6) return [0.5, 1, 0.5, 1]; // Light Green
        return [0, 0.4, 0, 1]; // Dark Green
      }
      ''';

      // Ensure request uses the specific time range (full day)
      // Or specific instant if precise enough. Usually date range is safer.
      final dateStr = date.toIso8601String().split('T')[0];
      final timeRange = "${dateStr}T00:00:00Z/${dateStr}T23:59:59Z";

      final body = {
        "input": {
          "bounds": {
            "bbox": bbox,
            if (geometry != null) "geometry": geometry,
            "properties": {"crs": "http://www.opengis.net/def/crs/EPSG/0/4326"},
          },
          "data": [
            {
              "type": SentinelConfig.sentinel2CollectionId,
              "dataFilter": {
                "timeRange": {
                  "from": timeRange.split('/')[0],
                  "to": timeRange.split('/')[1],
                },
                "mosaickingOrder": "leastCC", // Lease cloud cover pixel
              },
            },
          ],
        },
        "output": {
          "width": width,
          "height": height,
          "responses": [
            {
              "identifier": "default",
              "format": {"type": "image/png"},
            },
          ],
        },
        "evalscript": evalscript,
      };

      final response = await _dio.post(
        SentinelConfig.processUrl,
        data: body,
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Accept': 'image/png'},
          responseType: ResponseType.bytes,
        ),
      );

      return response.data;
    } catch (e) {
      LoggerService.e('Error fetching NDVI image', error: e, tag: 'SENTINEL');
      rethrow;
    }
  }

  /// Get Statistical Data
  /// If startDate and endDate are provided, fetches for range.
  /// If only date is provided, fetches for that single day.
  Future<Map<String, dynamic>> fetchStatistics({
    required Map<String, dynamic> geoJsonGeometry,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final token = await _getValidToken();

      String timeRangeStr;
      if (startDate != null && endDate != null) {
        timeRangeStr =
            "${startDate.toIso8601String()}/${endDate.toIso8601String()}";
      } else if (date != null) {
        final dateStr = date.toIso8601String().split('T')[0];
        timeRangeStr = "${dateStr}T00:00:00Z/${dateStr}T23:59:59Z";
      } else {
        throw ArgumentError("Must provide date or start/end date range");
      }

      final body = {
        "input": {
          "bounds": {
            "geometry": geoJsonGeometry,
            "properties": {"crs": "http://www.opengis.net/def/crs/EPSG/0/4326"},
          },
          "data": [
            {
              "type": SentinelConfig.sentinel2CollectionId,
              "dataFilter": {
                "timeRange": {
                  "from": timeRangeStr.split('/')[0],
                  "to": timeRangeStr.split('/')[1],
                },
              },
            },
          ],
        },
        "aggregation": {
          "timeRange": {
            "from": timeRangeStr.split('/')[0],
            "to": timeRangeStr.split('/')[1],
          },
          "aggregationInterval": {"of": "P1D"},
          "evalscript": '''
            //VERSION=3
            function setup() {
              return {
                input: ["B04", "B08", "dataMask"],
                output: [
                  { id: "ndvi", bands: 1 }
                ]
              };
            }

            function evaluatePixel(sample) {
              let ndvi = (sample.B08 - sample.B04) / (sample.B08 + sample.B04);
              return {
                ndvi: [ndvi]
              };
            }
          ''',
          "width": 100, // Number of bins
          "height": 100,
        },
      };

      final response = await _dio.post(
        SentinelConfig.statisticsUrl,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      LoggerService.e('Error fetching statistics', error: e, tag: 'SENTINEL');
      return {};
    }
  }
}

final sentinelServiceProvider = Provider((ref) => SentinelService());
