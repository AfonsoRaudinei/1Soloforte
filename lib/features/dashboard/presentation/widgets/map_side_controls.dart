import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class MapSideControls extends StatelessWidget {
  final VoidCallback? onLocationTap;
  final VoidCallback? onSyncTap;
  final VoidCallback? onLayersTap;
  final VoidCallback? onDrawTap;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const MapSideControls({
    super.key,
    this.onLocationTap,
    this.onSyncTap,
    this.onLayersTap,
    this.onDrawTap,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 80,
      child: Column(
        children: [
          _buildControlButton(icon: Icons.add, onTap: onZoomIn),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.remove, onTap: onZoomOut),
          const SizedBox(height: 12),
          _buildControlButton(
            icon: Icons.navigation_outlined,
            onTap: onLocationTap,
          ),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.sync, onTap: onSyncTap),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.layers_outlined, onTap: onLayersTap),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.edit_outlined, onTap: onDrawTap),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, VoidCallback? onTap}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
