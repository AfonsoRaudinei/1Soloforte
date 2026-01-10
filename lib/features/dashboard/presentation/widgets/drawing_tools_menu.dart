import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';

class DrawingToolsMenu extends ConsumerStatefulWidget {
  final VoidCallback? onDrawTap;

  const DrawingToolsMenu({super.key, this.onDrawTap});

  @override
  ConsumerState<DrawingToolsMenu> createState() => _DrawingToolsMenuState();
}

class _DrawingToolsMenuState extends ConsumerState<DrawingToolsMenu>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleAction(VoidCallback action) {
    // Close menu then perform action
    _toggleMenu();
    Future.delayed(const Duration(milliseconds: 150), action);
  }

  @override
  Widget build(BuildContext context) {
    final drawingController = ref.read(drawingControllerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Expanded Options
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildOption(
                icon: Icons.upload_file,
                label: 'Importar KML/KMZ',
                onTap: () =>
                    _handleAction(() => drawingController.importFromFile()),
                delay: 0,
              ),
              const SizedBox(height: 12),
              _buildOption(
                icon: Icons.radio_button_unchecked,
                label: 'Pivô (Círculo)',
                onTap: () => _handleAction(() {
                  drawingController.startDrawing();
                  drawingController.setTool('circle');
                }),
                delay: 1,
              ),
              const SizedBox(height: 12),
              _buildOption(
                icon: Icons.polyline,
                label: 'Talhão (Polígono)',
                onTap: () => _handleAction(() {
                  drawingController.startDrawing();
                  drawingController.setTool('polygon');
                }),
                delay: 2,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // Main Button (Styled like MapSideControls)
        Material(
          color: Colors.transparent,
          child: Tooltip(
            message: 'Ferramentas de Desenho',
            child: InkWell(
              onTap: _toggleMenu,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isExpanded
                      ? AppColors.textPrimary
                      : AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.125 : 0, // 45 deg rotation
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isExpanded ? Icons.add : Icons.edit_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.secondary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
