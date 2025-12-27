import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';
import 'package:soloforte_app/core/presentation/widgets/premium_dialog.dart';
import 'package:soloforte_app/features/map/presentation/widgets/save_area_dialog.dart';

class DrawingToolbar extends ConsumerWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drawingControllerProvider);
    final controller = ref.read(drawingControllerProvider.notifier);

    if (!state.isDrawing) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingActionButton.extended(
            onPressed: () {
              HapticFeedback.lightImpact();
              controller.startDrawing();
            },
            icon: const Icon(Icons.edit_location_alt_outlined),
            label: const Text('Desenhar Área'),
            backgroundColor: AppColors.primary,
          ),
        ),
      );
    }

    final isPolygon = state.activeTool == 'polygon';
    final isCircle = state.activeTool == 'circle';
    final isRectangle = state.activeTool == 'rectangle';

    bool canSave = false;
    if (isPolygon) canSave = state.currentPoints.length >= 3;
    if (isCircle) {
      canSave = state.circleCenter != null && state.circleRadius > 0;
    }
    if (isRectangle) canSave = state.currentPoints.length >= 4;

    String instructionText = 'Toque no mapa para adicionar vértices';
    if (isCircle) {
      instructionText = 'Toque no centro e arraste para definir o raio';
    } else if (isRectangle) {
      instructionText = 'Toque em dois cantos opostos para criar o retângulo';
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: PremiumGlassContainer(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Modo Desenho',
              style: AppTypography.h3.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Tool Switcher
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100]?.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolSegment(
                      label: 'Polígono',
                      icon: Icons.polyline,
                      isSelected: isPolygon,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.setTool('polygon');
                      },
                    ),
                  ),
                  Expanded(
                    child: _ToolSegment(
                      label: 'Círculo',
                      icon: Icons.radio_button_unchecked,
                      isSelected: isCircle,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.setTool('circle');
                      },
                    ),
                  ),
                  Expanded(
                    child: _ToolSegment(
                      label: 'Retângulo',
                      icon: Icons.crop_square,
                      isSelected: state.activeTool == 'rectangle',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.setTool('rectangle');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              instructionText,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isPolygon) ...[
                  _ToolButton(
                    icon: Icons.undo,
                    label: 'Desfazer',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      controller.undoLastPoint();
                    },
                    isEnabled: state.history.isNotEmpty,
                  ),
                ],
                _ToolButton(
                  icon: Icons.close,
                  label: 'Cancelar',
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    controller.stopDrawing();
                  },
                  color: AppColors.error,
                  isEnabled: true,
                ),
                _ToolButton(
                  icon: Icons.check,
                  label: 'Salvar',
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    PremiumDialog.show(
                      context: context,
                      builder: (context) => SaveAreaDialog(
                        onSave: (name) => controller.saveArea(name),
                      ),
                    );
                  },
                  color: AppColors.secondary,
                  isEnabled: canSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolSegment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? color;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isEnabled,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isEnabled
        ? (color ?? AppColors.textPrimary)
        : AppColors.textDisabled;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: effectiveColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(color: effectiveColor),
            ),
          ],
        ),
      ),
    );
  }
}

// Internal _SaveAreaDialog class removed.
