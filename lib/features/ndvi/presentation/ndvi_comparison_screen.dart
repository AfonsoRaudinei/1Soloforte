import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_comparison_controller.dart';

class NDVIComparisonScreen extends ConsumerStatefulWidget {
  final List<GeoArea> areas;

  const NDVIComparisonScreen({super.key, required this.areas});

  @override
  ConsumerState<NDVIComparisonScreen> createState() =>
      _NDVIComparisonScreenState();
}

class _NDVIComparisonScreenState extends ConsumerState<NDVIComparisonScreen> {
  late final MapController _mapController;
  final List<Color> _areaColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ndviComparisonControllerProvider.notifier)
          .initializeForAreas(widget.areas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ndviComparisonControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Comparativo de Áreas')),
      body: Column(
        children: [
          // MAP (Top Half)
          Expanded(
            flex: 1,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _getCenter(widget.areas),
                initialZoom: 13.0, // Should calculate based on bounds
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.soloforte.app',
                ),
                PolygonLayer(
                  polygons: widget.areas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final area = entry.value;
                    return Polygon(
                      points: area.points,
                      color: _areaColors[index % _areaColors.length]
                          .withValues(alpha: 0.3),
                      borderColor: _areaColors[index % _areaColors.length],
                      borderStrokeWidth: 2,
                      label: area.name,
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // CHART & LEGEND (Bottom Half)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.errorMessage != null
                  ? Center(child: Text(state.errorMessage!))
                  : Column(
                      children: [
                        // Legend
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: widget.areas.asMap().entries.map((entry) {
                            final index = entry.key;
                            final area = entry.value;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color:
                                      _areaColors[index % _areaColors.length],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  area.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Evolução do Vigor (Média NDVI)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        // Line Chart
                        Expanded(child: _buildComparisonChart(state)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng _getCenter(List<GeoArea> areas) {
    if (areas.isEmpty) return const LatLng(0, 0);
    // Combine all points
    final allPoints = areas.expand((a) => a.points).toList();
    if (allPoints.isEmpty) return const LatLng(0, 0);
    return GeometryUtils.calculateCentroid(allPoints);
  }

  Widget _buildComparisonChart(NdviComparisonState state) {
    if (state.areaStats.isEmpty) {
      return const Center(child: Text('Sem dados disponíveis.'));
    }

    final lineBars = <LineChartBarData>[];
    double minX = double.infinity;
    double maxX = -double.infinity;

    widget.areas.asMap().entries.forEach((entry) {
      final index = entry.key;
      final area = entry.value;
      final points = state.areaStats[area.id];

      if (points != null && points.isNotEmpty) {
        final spots = points.map((p) {
          final x = p.date.millisecondsSinceEpoch.toDouble();
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          return FlSpot(x, p.meanNdvi);
        }).toList();

        lineBars.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _areaColors[index % _areaColors.length],
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );
      }
    });

    if (lineBars.isEmpty) {
      return const Center(child: Text('Sem dados para exibir.'));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1.0,
        lineBarsData: lineBars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // Show dates
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              interval: (maxX - minX) / 4, // Show approx 5 labels
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 0.2,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 0.5,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = DateTime.fromMillisecondsSinceEpoch(
                  spot.x.toInt(),
                );
                return LineTooltipItem(
                  '${DateFormat('dd/MM').format(date)}\n${spot.y.toStringAsFixed(2)}',
                  TextStyle(color: spot.bar.color),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
