import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
// import 'package:geolocator/geolocator.dart'; // Abstracted
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/areas/presentation/providers/areas_controller.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/features/areas/domain/entities/area.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/core/services/location/location_service.dart';
import 'package:soloforte_app/l10n/generated/app_localizations.dart';
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

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _centerOnUserLocation() async {
    try {
      final position = await ref
          .read(locationServiceProvider)
          .getCurrentPosition();
      _mapController.move(position, 15.0);
    } on LocationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorLocation)),
        );
      }
    }
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
        content: Text(
          _isOnline
              ? AppLocalizations.of(context)!.synced
              : AppLocalizations.of(context)!.offlineMode,
        ),
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
    // Providers
    final activeVisitAsync = ref.watch(visitControllerProvider);
    final AsyncValue<List<Area>> areasAsync = ref.watch(
      areasControllerProvider,
    );
    final AsyncValue<List<Occurrence>> occurrencesAsync = ref.watch(
      occurrenceControllerProvider,
    );

    final activeVisit = activeVisitAsync.value;

    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-23.5505, -46.6333),
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
              // Loaded Areas
              if (areasAsync.hasValue)
                PolygonLayer(
                  polygons: areasAsync.value!.map((Area area) {
                    return Polygon(
                      points: area.coordinates,
                      color: _getAreaColor(area.status).withValues(alpha: 0.3),
                      borderColor: _getAreaColor(area.status),
                      borderStrokeWidth: 2,
                    );
                  }).toList(),
                ),

              // Loaded Occurrences Markers
              if (occurrencesAsync.hasValue)
                MarkerLayer(
                  markers: occurrencesAsync.value!.map((occ) {
                    return Marker(
                      point: LatLng(occ.latitude, occ.longitude),
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
                        child: Icon(
                          _getOccurrenceIcon(occ.type),
                          color: _getSeverityColor(occ.severity),
                          size: 24,
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                  _buildOccurrencesHeader(occurrencesAsync),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400,
                    width: 300,
                    child: occurrencesAsync.when(
                      data: (occurrences) {
                        if (occurrences.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.noOccurrences,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: occurrences.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) =>
                              _buildOccurrenceCard(occurrences[index], index),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.layers)),
              );
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
              child: areasAsync.when(
                data: (areas) {
                  if (areas.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noAreasRegistered,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: areas.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        _buildAreaCard(areas[index], index),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Center(
                  child: Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            ),
          ),

          // Active Visit Indicator
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
                          color: AppColors.primary.withValues(alpha: 0.4),
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
                            AppLocalizations.of(
                              context,
                            )!.visitInProgress(activeVisit.client.name),
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

  Widget _buildOccurrencesHeader(
    AsyncValue<List<Occurrence>> occurrencesAsync,
  ) {
    final count = occurrencesAsync.asData?.value.length ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
            AppLocalizations.of(context)!.activeOccurrences,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccurrenceCard(Occurrence occurrence, int index) {
    // Format time ago or date
    final String timeAgo = _formatTimeAgo(occurrence.date);

    return GestureDetector(
      onTap: () => context.push('/occurrences/detail/${occurrence.id}'),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getSeverityColor(
                  occurrence.severity,
                ).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getOccurrenceIcon(occurrence.type),
                color: _getSeverityColor(occurrence.severity),
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
                          occurrence.title,
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
                        timeAgo,
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
                          occurrence.areaName,
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
                            AppLocalizations.of(context)!.severity,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '${(occurrence.severity * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getSeverityColor(occurrence.severity),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: occurrence.severity,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            _getSeverityColor(occurrence.severity),
                          ),
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

  Widget _buildAreaCard(Area area, int index) {
    return Dismissible(
      key: ValueKey('area_${area.id}'),
      direction: DismissDirection.up,
      confirmDismiss: (direction) async {
        // Show options
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.optionsEditDelete),
          ),
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
          if (area.coordinates.isNotEmpty) {
            final first = area.coordinates.first;
            _mapController.move(LatLng(first.latitude, first.longitude), 15.5);
          }
        },
        onLongPress: () {
          // Context menu
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.areaMenu)),
          );
        },
        child: Container(
          width: 160,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                          color: _getAreaColor(
                            area.status,
                          ).withValues(alpha: 0.5),
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
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: _getAreaColor(area.status),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                area.status.toUpperCase(),
                                style: const TextStyle(
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
                        area.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                            '${area.hectares} ha',
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

  // Helpers
  Color _getSeverityColor(double severity) {
    if (severity > 0.7) return Colors.red;
    if (severity > 0.4) return Colors.orange;
    return Colors.purple;
  }

  IconData _getOccurrenceIcon(String type) {
    switch (type) {
      case 'pest':
        return Icons.bug_report_rounded;
      case 'disease':
        return Icons.coronavirus_rounded;
      case 'deficiency':
        return Icons.water_drop_rounded;
      default:
        return Icons.warning_rounded;
    }
  }

  Color _getAreaColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'monitoring':
        return Colors.orange;
      case 'attention':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    final l10n = AppLocalizations.of(context)!;
    if (diff.inDays > 0) return l10n.daysAgo(diff.inDays);
    if (diff.inHours > 0) return l10n.hoursAgo(diff.inHours);
    if (diff.inMinutes > 0) return l10n.minutesAgo(diff.inMinutes);
    return l10n.now;
  }
}
