import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/constants/map_zoom_constants.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';

class MapControls extends StatelessWidget {
  final MapController mapController;
  final VoidCallback onLocationPressed;
  final VoidCallback onLayersPressed;
  final VoidCallback onImportPressed;
  final VoidCallback onExportPressed;
  final VoidCallback onListPressed;

  const MapControls({
    super.key,
    required this.mapController,
    required this.onLocationPressed,
    required this.onLayersPressed,
    required this.onImportPressed,
    required this.onExportPressed,
    required this.onListPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MapButton(
          icon: Icons.more_horiz,
          onPressed: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => _MoreOptionsMenu(
                onImport: () {
                  Navigator.pop(ctx);
                  onImportPressed();
                },
                onExport: () {
                  Navigator.pop(ctx);
                  onExportPressed();
                },
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _MapButton(
          icon: Icons.list,
          onPressed: () {
            HapticFeedback.lightImpact();
            onListPressed();
          },
        ),
        const SizedBox(height: 12),
        _MapButton(
          icon: Icons.layers_outlined,
          onPressed: () {
            HapticFeedback.lightImpact();
            onLayersPressed();
          },
        ),
        const SizedBox(height: 12),
        _MapButton(
          icon: Icons.my_location,
          onPressed: () {
            HapticFeedback.mediumImpact();
            onLocationPressed();
          },
        ),
        const SizedBox(height: 12),
        _MapButton(
          icon: Icons.add,
          onPressed: () {
            HapticFeedback.selectionClick();
            final newZoom = (mapController.camera.zoom + 1).clamp(
              kAgriculturalMinZoom,
              kAgriculturalMaxZoom,
            );
            mapController.move(mapController.camera.center, newZoom);
          },
        ),
        const SizedBox(height: 8),
        _MapButton(
          icon: Icons.remove,
          onPressed: () {
            HapticFeedback.selectionClick();
            final newZoom = (mapController.camera.zoom - 1).clamp(
              kAgriculturalMinZoom,
              kAgriculturalMaxZoom,
            );
            mapController.move(mapController.camera.center, newZoom);
          },
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Using PremiumGlassContainer with shape circle requires some trickery,
    // or we can allow PremiumGlassContainer to take a shape?
    // Current PremiumGlassContainer uses RRect.
    // Let's stick to RRect with high radius to Simulate Circle or just nice Rounded Squares (Apple Maps style is rounded square)
    // Actually Apple Maps buttons are rounded rectangles. Let's try fully rounded (circle) or 12px radius.
    // Let's use 12px radius for a modern feel, or 50 for circle.

    return PremiumGlassContainer(
      borderRadius: 12,
      padding: EdgeInsets.zero,
      blur: 15,
      color: Colors.white.withValues(alpha: 0.9), // Higher opacity for buttons
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _MoreOptionsMenu extends StatelessWidget {
  final VoidCallback onImport;
  final VoidCallback onExport;

  const _MoreOptionsMenu({required this.onImport, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return PremiumGlassContainer(
      borderRadius: 24,
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importar KML/KMZ'),
            onTap: onImport,
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Exportar KML'),
            onTap: onExport,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
