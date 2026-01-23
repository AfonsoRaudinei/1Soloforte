import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class WeatherRadarWidget extends StatefulWidget {
  const WeatherRadarWidget({super.key});

  @override
  State<WeatherRadarWidget> createState() => _WeatherRadarWidgetState();
}

class _WeatherRadarWidgetState extends State<WeatherRadarWidget> {
  String _activeLayer = 'precipitation'; // precipitation, wind, clouds
  List<int> _timestamps = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _fetchRadarData();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRadarData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.rainviewer.com/public/weather-maps.json',
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final radarData = data['radar'] as Map<String, dynamic>?;

        if (radarData != null) {
          final List<int> times = [];

          // Past data
          if (radarData['past'] != null) {
            for (var item in radarData['past'] as List) {
              times.add(item['time']);
            }
          }

          // Nowcast (Future) data
          if (radarData['nowcast'] != null) {
            for (var item in radarData['nowcast'] as List) {
              times.add(item['time']);
            }
          }

          if (times.isNotEmpty) {
            if (mounted) {
              setState(() {
                _timestamps = times;
                _currentIndex =
                    (radarData['past'] != null &&
                        (radarData['past'] as List).isNotEmpty)
                    ? (radarData['past'] as List).length - 1
                    : times.length - 1;
              });
            }
            return; // Success
          }
        }
      }
    } catch (e) {
      LoggerService.e('Error fetching radar data', error: e, tag: 'WEATHER');
    }

    // Fallback: Simulate data if API fails or returns nothing (so UI controls are visible)
    if (mounted && _timestamps.isEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final simulatedTimes = List.generate(
        12,
        (index) => now - (12 - index) * 600,
      ); // Past 2 hours every 10 min
      setState(() {
        _timestamps = simulatedTimes;
        _currentIndex = simulatedTimes.length - 1;
      });
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animationTimer = Timer.periodic(const Duration(milliseconds: 500), (
          timer,
        ) {
          _nextFrame();
        });
      } else {
        _animationTimer?.cancel();
      }
    });
  }

  void _nextFrame() {
    if (mounted) {
      setState(() {
        if (_timestamps.isEmpty) return;
        _currentIndex = (_currentIndex + 1) % _timestamps.length;
      });
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentIndex = value.toInt();
      // Pause if user drags slider manually? Nice interaction but not strict.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current Timestamp Logic
    int? currentTimestamp;
    String timeLabel = 'Carregando...';

    if (_timestamps.isNotEmpty && _currentIndex < _timestamps.length) {
      currentTimestamp = _timestamps[_currentIndex];
      final date = DateTime.fromMillisecondsSinceEpoch(currentTimestamp * 1000);
      timeLabel = DateFormat('HH:mm').format(date);
    }

    final radarUrl = currentTimestamp != null
        ? 'https://tile.rainviewer.com/$currentTimestamp/256/{z}/{x}/{y}/2/1_1.png'
        : 'https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png'; // Fallback

    return Column(
      children: [
        Container(
          height: 400, // Increased height for controls
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(-13.06, -55.91), // Sorriso-MT roughly
                  initialZoom: 7,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.soloforte.app',
                  ),
                  // Data Layer
                  if (_activeLayer == 'precipitation')
                    TileLayer(
                      key: ValueKey(
                        currentTimestamp,
                      ), // Force rebuild/update on timestamp change?
                      // TileLayer caches, so changing urlTemplate triggers update usually.
                      // ValueKey helps ensure it refreshes.
                      urlTemplate: radarUrl,
                    ),
                  if (_activeLayer == 'clouds')
                    const CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(-13.06, -55.91),
                          color: Colors.white54,
                          radius: 100000,
                          useRadiusInMeter: true,
                        ),
                        CircleMarker(
                          point: LatLng(-12.5, -55.5),
                          color: Colors.white38,
                          radius: 80000,
                          useRadiusInMeter: true,
                        ),
                      ],
                    ),
                ],
              ),

              // Top Right: Status Badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getLayerIcon(_activeLayer),
                        color: _getLayerColor(_activeLayer),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getLayerTitle(_activeLayer).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Side: Intensity Legend (Only for precipitation)
              if (_activeLayer == 'precipitation')
                Positioned(
                  top: 60,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Forte',
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.purple, // Hail/Extreme
                                Colors.red, // Heavy
                                Colors.orange, // Moderate-Heavy
                                Colors.yellow, // Moderate
                                Colors.green, // Light
                                Colors.blue, // Drizzle
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fraco',
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Area: Controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Time Animation Controls
                      if (_activeLayer == 'precipitation' &&
                          _timestamps.isNotEmpty)
                        Row(
                          children: [
                            IconButton(
                              onPressed: _togglePlay,
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Radar: $timeLabel',
                                    style: AppTypography.label.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                    child: Slider(
                                      value: _currentIndex.toDouble(),
                                      min: 0,
                                      max: (_timestamps.length - 1).toDouble(),
                                      onChanged: _onSliderChanged,
                                      activeColor: AppColors.primary,
                                      inactiveColor: Colors.white24,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('HH:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              _timestamps.first * 1000,
                                            ),
                                          ),
                                          style: AppTypography.label.copyWith(
                                            color: Colors.white60,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              _timestamps.last * 1000,
                                            ),
                                          ),
                                          style: AppTypography.label.copyWith(
                                            color: Colors.white60,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: AppSpacing.sm),

                      // Layer Switcher
                      Container(
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildControlItem(
                              'Chuva',
                              Icons.water_drop,
                              'precipitation',
                            ),
                            VerticalDivider(color: Colors.white24, width: 1),
                            _buildControlItem('Vento', Icons.air, 'wind'),
                            VerticalDivider(color: Colors.white24, width: 1),
                            _buildControlItem('Nuvens', Icons.cloud, 'clouds'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlItem(String label, IconData icon, String key) {
    final isSelected = _activeLayer == key;
    return GestureDetector(
      onTap: () => setState(() => _activeLayer = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white60,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLayerTitle(String key) {
    switch (key) {
      case 'precipitation':
        return 'Radar de Chuva';
      case 'wind':
        return 'Velocidade do Vento';
      case 'clouds':
        return 'Cobertura de Nuvens';
      default:
        return 'Radar';
    }
  }

  IconData _getLayerIcon(String key) {
    switch (key) {
      case 'precipitation':
        return Icons.water_drop;
      case 'wind':
        return Icons.air;
      case 'clouds':
        return Icons.cloud;
      default:
        return Icons.radar;
    }
  }

  Color _getLayerColor(String key) {
    switch (key) {
      case 'precipitation':
        return Colors.blueAccent;
      case 'wind':
        return Colors.greenAccent;
      case 'clouds':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }
}
