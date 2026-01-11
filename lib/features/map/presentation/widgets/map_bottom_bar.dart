import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_state.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';

class MapBottomBar extends ConsumerWidget {
  const MapBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    // If drawing mode is active, we hide this bar because DrawingToolbar takes over
    // Or we could merge them, but let's follow the logic of "switching modes"
    if (state.activeMode == MapMode.drawing) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: PremiumGlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomBarItem(
                icon: Icons.bug_report_outlined,
                activeIcon: Icons.bug_report,
                label: 'Ocorrência',
                isActive: state.activeMode == MapMode.occurrence,
                onTap: () {
                  HapticFeedback.selectionClick();
                  controller.setMode(MapMode.occurrence);
                },
              ),
              _BottomBarItem(
                icon: Icons.edit_location_alt_outlined,
                activeIcon: Icons.edit_location_alt,
                label: 'Desenhar',
                isActive: state.activeMode == MapMode.drawing,
                onTap: () {
                  HapticFeedback.selectionClick();
                  // For drawing, we also need to trigger the DrawingController
                  // But MapScreen will listen to the state change and trigger it
                  controller.setMode(MapMode.drawing);
                },
              ),
              _BottomBarItem(
                icon: Icons.campaign_outlined,
                activeIcon: Icons.campaign,
                label: 'Marketing',
                isActive: state.activeMode == MapMode.marketing,
                onTap: () {
                  HapticFeedback.selectionClick();
                  controller.setMode(MapMode.marketing);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
