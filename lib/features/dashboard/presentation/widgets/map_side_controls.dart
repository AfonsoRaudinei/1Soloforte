import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'drawing_tools_menu.dart';

class MapSideControls extends StatelessWidget {
  final VoidCallback? onMarketingTap;
  final VoidCallback? onWeatherTap;
  final VoidCallback? onOccurrencesTap;
  final ValueChanged<String>? onLayerSelected;
  final VoidCallback? onDrawTap;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const MapSideControls({
    super.key,
    this.onMarketingTap,
    this.onWeatherTap,
    this.onOccurrencesTap,
    this.onLayerSelected,
    this.onDrawTap,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 60, // Adjusted top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Marketing
          _buildControlButton(
            icon: Icons.campaign_outlined,
            tooltip: 'Marketing',
            onTap: onMarketingTap,
            color: AppColors.secondary, // Secondary color as per request
          ),
          const SizedBox(height: 12),

          // Weather
          _buildControlButton(
            icon: Icons.cloud_outlined,
            tooltip: 'Clima',
            onTap: onWeatherTap,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),

          // Occurrences
          _buildControlButton(
            icon: Icons.warning_amber_rounded,
            tooltip: 'Ocorrências',
            onTap: onOccurrencesTap,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),

          // Layers (Expandable/Popup)
          _buildLayerMenu(),
          const SizedBox(height: 12),

          // Drawing Tools (Expandable)
          DrawingToolsMenu(onDrawTap: onDrawTap),

          const SizedBox(height: 24), // Spacer between tools and zoom
          // Zoom Controls
          _buildControlButton(
            icon: Icons.add,
            tooltip: 'Zoom In',
            onTap: onZoomIn,
            mini: true,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.remove,
            tooltip: 'Zoom Out',
            onTap: onZoomOut,
            mini: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLayerMenu() {
    return PopupMenuButton<String>(
      onSelected: onLayerSelected,
      offset: const Offset(-10, 0),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'standard',
          child: Row(
            children: [
              Icon(Icons.map_outlined, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text('Padrão'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'satellite',
          child: Row(
            children: [
              Icon(Icons.satellite_outlined, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text('Satélite'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'relief',
          child: Row(
            children: [
              Icon(Icons.terrain_outlined, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text('Relevo'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'ndvi',
          child: Row(
            children: [
              Icon(Icons.grass_outlined, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text('NDVI Viewer'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.layers_outlined, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onTap,
    String? tooltip,
    Color color = AppColors.gray800,
    bool mini = false,
  }) {
    final size = mini ? 36.0 : 44.0; // 44dp minimum touch target
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Icon(icon, color: Colors.white, size: mini ? 20 : 24),
          ),
        ),
      ),
    );
  }
}
