import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/weather/domain/weather_model.dart';
import 'package:soloforte_app/features/weather_radar/presentation/weather_radar_screen.dart';
import 'widgets/notification_settings_modal.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/weather_provider.dart';
import 'weather_next_24h_screen.dart';
import 'weather_next_7d_screen.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  String _location = 'CARREGANDO...';
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _location = 'GPS DESATIVADO');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _location = 'PERMISSÃO NEGADA');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _location = 'PERMISSÃO NEGADA');
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city =
              place.subAdministrativeArea ?? place.locality ?? 'Desconhecido';
          final state = place.administrativeArea ?? '';
          if (mounted) {
            setState(() {
              _location = '$city, $state'.toUpperCase();
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _location =
                '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _location = 'ERRO AO OBTER LOCAL');
      debugPrint('Location error: $e');
    }
  }

  Future<void> _showSearchDialog(BuildContext context) async {
    final TextEditingController searchController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar Cidade'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Digite o nome da cidade...',
            prefixIcon: Icon(Icons.location_city),
          ),
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            Navigator.pop(context);
            _searchLocation(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchLocation(searchController.text);
            },
            child: const Text('BUSCAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() => _location = 'BUSCANDO...');

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        List<Placemark> placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city = place.subAdministrativeArea ?? place.locality ?? query;
          final state = place.administrativeArea ?? '';

          if (mounted) {
            setState(() {
              _location = '$city, $state'.toUpperCase();
              _latitude = loc.latitude;
              _longitude = loc.longitude;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() => _location = 'NÃO ENCONTRADO');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _location = 'ERRO NA BUSCA');
        debugPrint('Search error: $e');
      }
    }
  }

  Future<void> _refresh() async {
    await _initLocation();
    if (_latitude != null && _longitude != null) {
      return ref.refresh(
        weatherForecastProvider(_latitude!, _longitude!).future,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_latitude == null || _longitude == null) {
      if (_location.contains('ERRO') ||
          _location.contains('NEGADA') ||
          _location.contains('DESATIVADO')) {
        return Scaffold(
          appBar: AppBar(title: const Text('Clima')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(_location),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initLocation,
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ),
        );
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final weatherAsync = ref.watch(
      weatherForecastProvider(_latitude!, _longitude!),
    );

    return weatherAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Clima')),
        body: Center(child: Text('Erro: $err')),
      ),
      data: (forecast) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text('Clima'),
            actions: [
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () => _showSearchDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (c) => const NotificationSettingsModal(),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _location,
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Atualizado há 5 min', style: AppTypography.caption),
                  const SizedBox(height: 24),

                  // Box 1: Condition & Temp
                  _buildAsciiBox(
                    child: Column(
                      children: [
                        Icon(
                          _getWeatherIcon(forecast.condition),
                          size: 64,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${forecast.currentTemp.round()}°C',
                          style: AppTypography.display1,
                        ),
                        Text(forecast.condition, style: AppTypography.h3),
                        Text(
                          'Sensação: ${forecast.feelsLike.round()}°C',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Box 2: Details
                  _buildAsciiBoxWithHeader(
                    title: 'Detalhes',
                    content: Column(
                      children: [
                        _buildDetailLine(
                          Icons.air,
                          'Vento: ${forecast.windSpeed} km/h ${forecast.windDirection}',
                        ),
                        _buildDetailLine(
                          Icons.water_drop,
                          'Umidade: ${forecast.humidity}%',
                        ),
                        _buildDetailLine(
                          Icons.umbrella,
                          'Chuva: ${forecast.precipitation} mm',
                        ),
                        _buildDetailLine(Icons.explore, 'Pressão: 1013 hPa'),
                        _buildDetailLine(
                          Icons.visibility,
                          'Visibilidade: ${forecast.visibility} km',
                        ),
                        _buildDetailLine(
                          Icons.cloud,
                          'Nuvens: ${forecast.cloudCover}%',
                        ),
                        _buildDetailLine(
                          Icons.wb_sunny,
                          'UV: ${forecast.uvIndex.round()} (${_getUVLabel(forecast.uvIndex)})',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Box 3: Alerts
                  if (forecast.alerts.isNotEmpty)
                    _buildAlertBox(forecast.alerts.first),

                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WeatherNext24hScreen(forecast: forecast),
                              ),
                            );
                          },
                          icon: const Icon(Icons.umbrella),
                          label: const Text('Próximas 24h'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WeatherNext7dScreen(forecast: forecast),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('7 Dias'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WeatherRadarScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.radar),
                      label: const Text('Radar de Clima'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAsciiBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAsciiBoxWithHeader({
    required String title,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Text(
              title,
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: content),
        ],
      ),
    );
  }

  Widget _buildDetailLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.bodyMedium.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildAlertBox(WeatherAlert alert) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.red.shade50,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.red.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'ALERTAS (1)',
                  style: AppTypography.label.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Amanhã às 18h', style: AppTypography.bodySmall),
                Text(alert.description, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('rain') || c.contains('chuva')) return Icons.water_drop;
    if (c.contains('cloud') || c.contains('nuv')) return Icons.cloud;
    if (c.contains('storm') || c.contains('tempestade')) {
      return Icons.thunderstorm;
    }
    return Icons.wb_sunny;
  }

  String _getUVLabel(double uv) {
    if (uv < 3) return 'Baixo';
    if (uv < 6) return 'Moderado';
    if (uv < 8) return 'Alto';
    return 'Muito Alto';
  }
}
