// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    _WeatherForecast(
      currentTemp: (json['currentTemp'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      precipitation: (json['precipitation'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toInt(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      condition: json['condition'] as String,
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts:
          (json['alerts'] as List<dynamic>?)
              ?.map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WeatherForecastToJson(_WeatherForecast instance) =>
    <String, dynamic>{
      'currentTemp': instance.currentTemp,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'precipitation': instance.precipitation,
      'visibility': instance.visibility,
      'cloudCover': instance.cloudCover,
      'uvIndex': instance.uvIndex,
      'condition': instance.condition,
      'daily': instance.daily,
      'hourly': instance.hourly,
      'alerts': instance.alerts,
    };

_DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    _DailyForecast(
      date: DateTime.parse(json['date'] as String),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      rainProbability: (json['rainProbability'] as num).toInt(),
    );

Map<String, dynamic> _$DailyForecastToJson(_DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'maxTemp': instance.maxTemp,
      'minTemp': instance.minTemp,
      'condition': instance.condition,
      'precipitation': instance.precipitation,
      'windSpeed': instance.windSpeed,
      'rainProbability': instance.rainProbability,
    };

_HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    _HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temp: (json['temp'] as num).toDouble(),
      condition: json['condition'] as String,
      rainProbability: (json['rainProbability'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
    );

Map<String, dynamic> _$HourlyForecastToJson(_HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temp': instance.temp,
      'condition': instance.condition,
      'rainProbability': instance.rainProbability,
      'precipitation': instance.precipitation,
    };

_WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) =>
    _WeatherAlert(
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      effective: DateTime.parse(json['effective'] as String),
      expires: DateTime.parse(json['expires'] as String),
      type: json['type'] as String,
    );

Map<String, dynamic> _$WeatherAlertToJson(_WeatherAlert instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'severity': instance.severity,
      'effective': instance.effective.toIso8601String(),
      'expires': instance.expires.toIso8601String(),
      'type': instance.type,
    };
