import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';

class DrawingMeasurementOverlay extends ConsumerWidget {
  const DrawingMeasurementOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drawingControllerProvider);

    // Only show if drawing/editing
    if (!state.isDrawing) return const SizedBox.shrink();

    double area = 0.0;
    bool isSmall = false;
    bool hasEnoughPoints = false;

    if (state.activeTool == 'circle') {
      if (state.circleRadius > 0) {
        area = GeometryUtils.calculateCircleAreaHectares(state.circleRadius);
        hasEnoughPoints = true;
      }
    } else {
      // Polygon / Rectangle
      if (state.currentPoints.length >= 3) {
        hasEnoughPoints = true;
        area = GeometryUtils.calculateAreaHectares(state.currentPoints);
      }
    }

    if (area < 0.01 && hasEnoughPoints) {
      isSmall = true;
    }

    if (!hasEnoughPoints) {
      // Don't show anything until we have a substantial shape
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 110, // Just below the top bar (approx 40 + 50 padding)
      left: 0,
      right: 0,
      child: Center(
        child: PremiumGlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderRadius: 24,
          blur: 15,
          // Use a subtle white glass appearance
          color: Colors.white.withValues(alpha: 0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSmall ? Icons.warning_amber_rounded : Icons.landscape,
                size: 20,
                color: isSmall ? AppColors.error : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                isSmall
                    ? "Área muito pequena (<0.01 ha)"
                    : "${area.toStringAsFixed(2)} ha",
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSmall ? AppColors.error : AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
