import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import '../domain/weather_model.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class WeatherService {
  final Dio _dio;
  final DatabaseHelper _dbHelper;
  static const int _cacheTtlMinutes = 60;
  static const double _locationApproximation = 0.01; // ~1.1km

  WeatherService(this._dio, this._dbHelper);

  Future<WeatherForecast> getWeather(double lat, double lon) async {
    // 1. Check Cache
    final cached = await _getCachedWeather(lat, lon);
    if (cached != null) {
      if (!_isExpired(cached['timestamp'] as int)) {
        LoggerService.d('Using fresh weather cache', tag: 'WEATHER');
        return _parseOpenMeteoResponse(jsonDecode(cached['data'] as String));
      } else {
        LoggerService.d(
          'Weather cache expired, trying to refresh...',
          tag: 'WEATHER',
        );
      }
    }

    try {
      // 2. Fetch from API
      // Using OpenMeteo API (Free, no key required)
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current':
              'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m',
          'hourly':
              'temperature_2m,relative_humidity_2m,precipitation_probability,precipitation,weather_code',
          'daily':
              'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max',
          'timezone': 'auto',
          'forecast_days': 14,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // 3. Save to Cache
        await _cacheWeather(lat, lon, data);
        return _parseOpenMeteoResponse(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      LoggerService.e('Weather fetch error', error: e, tag: 'WEATHER');
      // 4. Fallback to expired cache if available
      if (cached != null) {
        LoggerService.d(
          'Falling back to expired weather cache',
          tag: 'WEATHER',
        );
        return _parseOpenMeteoResponse(jsonDecode(cached['data'] as String));
      }
      rethrow;
    }
  }

  Future<Map<String, Object?>?> _getCachedWeather(
    double lat,
    double lon,
  ) async {
    final db = await _dbHelper.database;
    // Approximating location to avoid too much fragmentation
    final results = await db.query(
      'weather_cache',
      where: 'ABS(latitude - ?) < ? AND ABS(longitude - ?) < ?',
      whereArgs: [lat, _locationApproximation, lon, _locationApproximation],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> _cacheWeather(
    double lat,
    double lon,
    Map<String, dynamic> data,
  ) async {
    final db = await _dbHelper.database;
    // Remove old cache for this location area
    await db.delete(
      'weather_cache',
      where: 'ABS(latitude - ?) < ? AND ABS(longitude - ?) < ?',
      whereArgs: [lat, _locationApproximation, lon, _locationApproximation],
    );
    // Insert new
    await db.insert('weather_cache', {
      'latitude': lat,
      'longitude': lon,
      'data': jsonEncode(data),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  bool _isExpired(int timestamp) {
    const ttl = _cacheTtlMinutes * 60 * 1000;
    return (DateTime.now().millisecondsSinceEpoch - timestamp) > ttl;
  }

  WeatherForecast _parseOpenMeteoResponse(Map<String, dynamic> data) {
    final current = data['current'];
    final hourly = data['hourly'];
    final daily = data['daily'];

    // Helper to map WMO codes to condition strings
    String getCondition(int code) {
      if (code == 0) return 'Limpo';
      if (code == 1 || code == 2 || code == 3) return 'Nublado';
      if (code >= 45 && code <= 48) return 'Nevoeiro';
      if (code >= 51 && code <= 67) return 'Chuva';
      if (code >= 71 && code <= 77) return 'Neve';
      if (code >= 80 && code <= 82) return 'Chuva Forte';
      if (code >= 95) return 'Tempestade';
      return 'Desconhecido';
    }

    // Parse Hourly
    List<HourlyForecast> hourlyList = [];
    final times = hourly['time'] as List;
    for (int i = 0; i < 24 && i < times.length; i++) {
      // Get next 24h
      hourlyList.add(
        HourlyForecast(
          time: DateTime.parse(times[i]),
          temp: (hourly['temperature_2m'][i] as num).toDouble(),
          condition: getCondition(hourly['weather_code'][i] as int),
          rainProbability: (hourly['precipitation_probability'][i] as num)
              .toInt(),
          precipitation: (hourly['precipitation'][i] as num).toDouble(),
        ),
      );
    }

    // Parse Daily
    List<DailyForecast> dailyList = [];
    final dates = daily['time'] as List;
    for (int i = 0; i < dates.length; i++) {
      dailyList.add(
        DailyForecast(
          date: DateTime.parse(dates[i]),
          maxTemp: (daily['temperature_2m_max'][i] as num).toDouble(),
          minTemp: (daily['temperature_2m_min'][i] as num).toDouble(),
          condition: getCondition(daily['weather_code'][i] as int),
          precipitation: (daily['precipitation_sum'][i] as num).toDouble(),
          windSpeed: (daily['wind_speed_10m_max'][i] as num).toDouble(),
          rainProbability: (daily['precipitation_probability_max'][i] as num)
              .toInt(),
        ),
      );
    }

    return WeatherForecast(
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      windDirection: _getWindDirection(current['wind_direction_10m'] as num),
      precipitation: (current['precipitation'] as num).toDouble(),
      visibility:
          10.0, // OpenMeteo doesn't provide visibility in free tier comfortably, mocking
      cloudCover: (current['cloud_cover'] as num).toInt(),
      uvIndex:
          5.0, // Needs separate API call in OpenMeteo or distinct param, mocking safe avg
      condition: getCondition(current['weather_code'] as int),
      hourly: hourlyList,
      daily: dailyList,
      alerts: [], // Alerts require separate endpoint usually
    );
  }

  String _getWindDirection(num degrees) {
    const directions = ['N', 'NE', 'L', 'SE', 'S', 'SW', 'O', 'NW'];
    final index = ((degrees + 22.5) % 360) ~/ 45;
    return directions[index];
  }
}
