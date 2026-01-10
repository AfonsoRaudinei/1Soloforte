import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';
import 'package:soloforte_app/features/reports/application/report_service.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

import 'ndvi_history_screen.dart';
import 'ndvi_comparison_screen.dart';

class NDVIDetailScreen extends ConsumerStatefulWidget {
  final GeoArea area;

  const NDVIDetailScreen({super.key, required this.area});

  @override
  ConsumerState<NDVIDetailScreen> createState() => _NDVIDetailScreenState();
}

class _NDVIDetailScreenState extends ConsumerState<NDVIDetailScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ndviControllerProvider.notifier).initializeForArea(widget.area);
    });
  }

  void _exportReport() async {
    final state = ref.read(ndviControllerProvider);
    if (state.selectedDate == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gerando relatório...')));

    try {
      await ref
          .read(reportServiceProvider)
          .generateAndShareNDVIReport(
            area: widget.area,
            date: state.selectedDate!,
            ndviImageBytes: state.currentImageBytes,
            stats: state.currentStats,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ndviState = ref.watch(ndviControllerProvider);
    final selectedDateFormatted = ndviState.selectedDate != null
        ? DateFormat(
            'dd/MMM/yyyy',
            'pt_BR',
          ).format(ndviState.selectedDate!).toUpperCase()
        : '...';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('NDVI - ${widget.area.name}'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area Selector
            const Text(
              'Selecionar Área',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.area.name} - ${widget.area.areaHectares.toStringAsFixed(1)} ha',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Image Box
            // ╔═════════════════════════════╗
            // ║ IMAGEM SATÉLITE NDVI        ║
            // ...
            _buildAsciiBox(
              title: 'IMAGEM SATÉLITE NDVI',
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    // Using FlutterMap as the "Image" viewer for now to keep overlay logic
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _getCenter(widget.area),
                          initialZoom: 15.0, // Or auto-fit bounds
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.soloforte.app',
                          ),
                          if (ndviState.currentImageBytes != null)
                            OverlayImageLayer(
                              overlayImages: [
                                OverlayImage(
                                  bounds: _getBounds(widget.area.points),
                                  imageProvider: MemoryImage(
                                    ndviState.currentImageBytes!,
                                  ),
                                  opacity: 0.8,
                                ),
                              ],
                            ),
                          PolygonLayer(
                            polygons: [
                              Polygon(
                                points: widget.area.points,
                                color: Colors.transparent,
                                borderColor: Colors.white,
                                borderStrokeWidth: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Legend / Info Overlay inside box
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendRow(Colors.green, 'Saudável'),
                            _buildLegendRow(Colors.yellow, 'Médio'),
                            _buildLegendRow(Colors.red, 'Estresse'),
                          ],
                        ),
                      ),
                    ),

                    if (ndviState.isImageLoading)
                      Container(
                        color: Colors.black12,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Scale
            // Escala NDVI:
            // [████████████]
            Text(
              'Escala NDVI:',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.yellow, Colors.green],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '-1.0',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text('0.0', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('0.3', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('0.6', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('1.0', style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 24),

            // Date Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Data:', style: TextStyle(color: Colors.grey)),
                    Text(selectedDateFormatted, style: AppTypography.h4),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        /* Prev */
                      },
                      icon: const Icon(Icons.arrow_back, size: 14),
                      label: const Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        /* Next */
                      },
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Row(
                        children: [
                          Text('Próxima'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Statistics Box
            // ┌─────────────────────────┐
            // │ 📊 Estatísticas         │
            // ...
            _buildStatisticsBox(ndviState),

            const SizedBox(height: 32),

            // Actions
            _buildActionButton(Icons.calendar_today, 'Ver Histórico', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NDVIHistoryScreen()),
              );
            }),
            const SizedBox(height: 12),
            _buildActionButton(Icons.compare_arrows, 'Comparar Áreas', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NDVIComparisonScreen(areas: [widget.area]),
                ),
              ); // Passing single area for now, user selects more there
            }),
            const SizedBox(height: 12),
            _buildActionButton(
              Icons.download,
              'Baixar Relatório',
              _exportReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsciiBox({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ), // Double border effect simulated with thickness
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade100,
            child: Center(
              child: Text(
                title,
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildStatisticsBox(dynamic state) {
    // Typing dynamic for brevity accessing fields
    final mean = state.currentStats?.meanNdvi.toStringAsFixed(2) ?? '-';
    // Mock percentages for now if not in stats
    const health = '78%';
    const stress = '12%';
    const soil = '10%';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Estatísticas', style: AppTypography.h4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatLine('NDVI Médio:', mean),
                _buildStatLine('Área Saudável:', health),
                _buildStatLine('Área Estresse:', stress),
                _buildStatLine('Área Solo:', soil),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.centerLeft,
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(const LatLng(0, 0), const LatLng(0, 0));
    }
    final bbox = GeometryUtils.calculateBBox(points);
    return LatLngBounds(LatLng(bbox[1], bbox[0]), LatLng(bbox[3], bbox[2]));
  }

  LatLng _getCenter(GeoArea area) {
    if (area.center != null) return area.center!;
    if (area.points.isNotEmpty) {
      return GeometryUtils.calculateCentroid(area.points);
    }
    return const LatLng(0, 0);
  }
}
