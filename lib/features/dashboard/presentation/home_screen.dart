import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'widgets/map_side_controls.dart';
import 'widgets/radial_menu.dart';
import 'widgets/online_status_badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MapController _mapController = MapController();
  bool _isOnline = true;
  bool _isRadialMenuOpen = false;

  // Mock Data
  final List<Polygon> _mockAreas = [
    Polygon(
      points: [
        const LatLng(-14.2350, -51.9253),
        const LatLng(-14.2400, -51.9253),
        const LatLng(-14.2400, -51.9300),
        const LatLng(-14.2350, -51.9300),
      ],
      color: Colors.green.withOpacity(0.3),
      borderColor: Colors.green,
      borderStrokeWidth: 2,
    ),
    Polygon(
      points: [
        const LatLng(-14.2450, -51.9353),
        const LatLng(-14.2500, -51.9353),
        const LatLng(-14.2500, -51.9400),
        const LatLng(-14.2450, -51.9400),
      ],
      color: Colors.orange.withOpacity(0.3),
      borderColor: Colors.orange,
      borderStrokeWidth: 2,
    ),
  ];

  final List<Marker> _mockOccurrences = [
    Marker(
      point: const LatLng(-14.2375, -51.9275),
      width: 40,
      height: 40,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.bug_report, color: Colors.red, size: 24),
      ),
    ),
    Marker(
      point: const LatLng(-14.2475, -51.9375),
      width: 40,
      height: 40,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.water_drop, color: Colors.blue, size: 24),
      ),
    ),
  ];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _centerOnUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviços de localização desativados.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissões de localização permanentemente negadas.'),
          ),
        );
      }
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _handleSync() {
    setState(() {
      _isOnline = !_isOnline;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'Sincronizado' : 'Modo Offline'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _hideMenus() {
    if (_isRadialMenuOpen) {
      setState(() => _isRadialMenuOpen = false);
    }
  }

  void _toggleRadialMenu() {
    setState(() {
      _isRadialMenuOpen = !_isRadialMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch active visit to show sticky card
    final activeVisitAsync = ref.watch(visitControllerProvider);
    final activeVisit = activeVisitAsync.value;

    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-14.2350, -51.9253),
              initialZoom: 13.0,
              minZoom: 3.0,
              maxZoom: 18.0,
              onTap: (_, __) => _hideMenus(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.soloforte.app',
                maxZoom: 19,
              ),
              PolygonLayer(polygons: _mockAreas),
              MarkerLayer(markers: _mockOccurrences),
            ],
          ),

          // Online Status Badge (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: OnlineStatusBadge(
                isOnline: _isOnline,
                onSyncTap: _handleSync,
              ),
            ),
          ),

          // Occurrences List (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Ocorrências Ativas',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400, // Increased height to fit cards
                    width: 300,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) =>
                          _buildOccurrenceCard(index),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Side Controls (Right Side)
          MapSideControls(
            onLocationTap: _centerOnUserLocation,
            onSyncTap: _handleSync,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onLayersTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Camadas')));
            },
            onDrawTap: () {
              context.push('/analysis/new');
            },
          ),

          // Area List (Bottom, above BottomBar)
          Positioned(
            bottom: 100, // Above bottom bar
            left: 0,
            right: 0,
            child: SizedBox(
              height: 150,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _buildAreaCard(index),
              ),
            ),
          ),

          // Active Visit Indicator (Bottom Center, just above areas/nav)
          if (activeVisit != null && activeVisit.status.name == 'ongoing')
            Positioned(
              top: 80, // Below header
              left: 16,
              right: 80,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => context.push('/visit/active'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Em andamento: ${activeVisit.client.name}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Radial Menu Overlay
          if (_isRadialMenuOpen)
            Positioned.fill(
              child: RadialMenu(
                onDrawTap: () {
                  _toggleRadialMenu();
                  context.push('/analysis/new');
                },
                onOccurrenceTap: () {
                  _toggleRadialMenu();
                  context.push('/occurrences/new');
                },
                onScannerTap: () {
                  _toggleRadialMenu();
                  context.push('/dashboard/scanner');
                },
                onReportTap: () {
                  _toggleRadialMenu();
                  context.push('/dashboard/report/new');
                },
                onClose: _toggleRadialMenu,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRadialMenu,
        backgroundColor: _isRadialMenuOpen
            ? Colors.grey
            : const Color(0xFF0057FF),
        child: Icon(
          _isRadialMenuOpen ? Icons.close : Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildOccurrenceCard(int index) {
    // Mock data for display
    final titles = ['Lagarta na Soja', 'Ferrugem Asiática', 'Buva Resistente'];
    final severity = [0.85, 0.60, 0.45];
    final locations = ['Talhão Norte', 'Talhão Sul', 'Área Teste'];
    final colors = [Colors.red, Colors.orange, Colors.purple];
    final times = ['Há 2h', 'Há 5h', 'Ontem'];

    return GestureDetector(
      onTap: () => context.push('/occurrences/detail/$index'),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors[index % 3].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bug_report_rounded,
                color: colors[index % 3],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          titles[index % 3],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        times[index % 3],
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          locations[index % 3],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Severity Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Severidade',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '${(severity[index % 3] * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colors[index % 3],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: severity[index % 3],
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(colors[index % 3]),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(int index) {
    return Dismissible(
      key: ValueKey('area_$index'),
      direction: DismissDirection.up,
      confirmDismiss: (direction) async {
        // Show options
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opções: Editar / Excluir')),
        );
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: () {
          _mapController.move(const LatLng(-14.2350, -51.9253), 15.5);
        },
        onLongPress: () {
          // Context menu
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Menu da Área')));
        },
        child: Container(
          width: 160,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Mini Map / Image placeholder
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder pattern or image
                      Opacity(
                        opacity: 0.5,
                        child: Icon(
                          Icons.grass,
                          size: 60,
                          color: Colors.green[200],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.green[400],
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Ativa',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Talhão ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(120 + index * 15)} ha',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
