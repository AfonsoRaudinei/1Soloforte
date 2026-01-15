import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
// PremiumGlassContainer import removed
import 'package:soloforte_app/features/map/presentation/widgets/save_area_bottom_sheet.dart';

class DrawingToolbar extends ConsumerWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drawingControllerProvider);
    final controller = ref.read(drawingControllerProvider.notifier);

    // If not drawing, we show a minimized FAB (although MapScreen might hide this)
    if (!state.isDrawing) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100, right: 16),
          child: FloatingActionButton(
            mini: true,
            heroTag: "minimized_drawing_fab",
            onPressed: () {
              HapticFeedback.lightImpact();
              controller.startDrawing();
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.edit_location_alt_outlined),
          ),
        ),
      );
    }

    // --- Active Drawing Logic ---

    // Save/Commit check
    bool canSave = false;
    final isPolygon = state.activeTool == 'polygon';
    final isCircle = state.activeTool == 'circle';
    final isRectangle = state.activeTool == 'rectangle';

    if (isPolygon) canSave = state.currentPoints.length >= 3;
    if (isCircle) {
      canSave = state.circleCenter != null && state.circleRadius > 0;
    }
    if (isRectangle) canSave = state.currentPoints.length >= 4;

    // Formatting Instruction Text
    String instructionText = 'Toque no mapa para adicionar pontos';
    if (isCircle) {
      instructionText = 'Toque no centro e arraste para o raio';
    } else if (isRectangle) {
      instructionText = 'Marque dois cantos opostos';
    } else if (isPolygon && state.editingAreaId != null) {
      instructionText = 'Arraste os pontos para editar';
    }

    // Determine Active Icon
    IconData activeToolIcon;
    switch (state.activeTool) {
      case 'circle':
        activeToolIcon = Icons.radio_button_unchecked;
        break;
      case 'rectangle':
        activeToolIcon = Icons.crop_square;
        break;
      case 'polygon':
      default:
        activeToolIcon = Icons.polyline;
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Instruction Toast (Float above toolbar)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              instructionText,
              style: AppTypography.caption.copyWith(color: Colors.white),
            ),
          ),

          // 2. Compact Toolbar (Pill)
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // A. Tool Selector (Menu)
                PopupMenuButton<String>(
                  tooltip: 'Selecionar Ferramenta',
                  offset: const Offset(0, -120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (val) {
                    HapticFeedback.selectionClick();
                    controller.setTool(val);
                  },
                  itemBuilder: (ctx) => [
                    _buildMenuItem('polygon', 'Polígono', Icons.polyline),
                    _buildMenuItem(
                      'circle',
                      'Círculo',
                      Icons.radio_button_unchecked,
                    ),
                    _buildMenuItem('rectangle', 'Retângulo', Icons.crop_square),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activeToolIcon,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // C. Divider
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),

                // D. Undo
                IconButton(
                  tooltip: 'Desfazer',
                  onPressed: state.history.isNotEmpty
                      ? () {
                          HapticFeedback.lightImpact();
                          controller.undoLastPoint();
                        }
                      : null,
                  icon: const Icon(Icons.undo),
                  color: Colors.black87,
                  disabledColor: Colors.black26,
                ),

                // E. Cancel/Close
                IconButton(
                  tooltip: 'Cancelar',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    controller.stopDrawing();
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.black87,
                ),

                const SizedBox(width: 4),

                // F. Save/Confirm (Highlighted)
                AnimatedScale(
                  scale: canSave ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: FloatingActionButton.small(
                    elevation: 0,
                    heroTag: "save_drawing_btn",
                    backgroundColor: canSave
                        ? AppColors.secondary
                        : Colors.grey[300],
                    onPressed: canSave
                        ? () {
                            HapticFeedback.heavyImpact();
                            _handleSave(context, controller, state);
                          }
                        : null,
                    child: Icon(
                      Icons.check,
                      color: canSave ? Colors.white : Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }

  void _handleSave(
    BuildContext context,
    DrawingController controller,
    dynamic state,
  ) {
    if (state.editingAreaId != null) {
      // Editing Flow
      try {
        final existing = state.savedAreas.firstWhere(
          (a) => a.id == state.editingAreaId,
        );

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SaveAreaBottomSheet(
            initialData: existing,
            onSave:
                ({
                  required name,
                  required clientId,
                  required clientName,
                  fieldId,
                  fieldName,
                  notes,
                  colorValue,
                  required isDashed,
                }) {
                  controller.saveArea(
                    name: name,
                    clientId: clientId,
                    clientName: clientName,
                    fieldId: fieldId,
                    fieldName: fieldName,
                    notes: notes,
                    colorValue: colorValue,
                  );
                },
            onCancel: () {
              controller.stopDrawing();
            },
          ),
        );
      } catch (e) {
        controller.saveArea(name: "Área Editada");
      }
    } else {
      // New Area Flow
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SaveAreaBottomSheet(
          onSave:
              ({
                required name,
                required clientId,
                required clientName,
                fieldId,
                fieldName,
                notes,
                colorValue,
                required isDashed,
              }) {
                controller.saveArea(
                  name: name,
                  clientId: clientId,
                  clientName: clientName,
                  fieldId: fieldId,
                  fieldName: fieldName,
                  notes: notes,
                  colorValue: colorValue,
                  isDashed: isDashed,
                );
              },
          onCancel: () {
            controller.stopDrawing();
          },
        ),
      );
    }
  }
}
