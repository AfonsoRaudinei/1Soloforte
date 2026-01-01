import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class KPIStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subValue;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isTrendPositive;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const KPIStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subValue,
    required this.icon,
    required this.color,
    this.trend,
    this.isTrendPositive = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12), // replaced Spacer to fix layout crash
            Text(
              value,
              style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
            ),
            if (subValue != null) Text(subValue!, style: AppTypography.caption),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isTrendPositive ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isTrendPositive
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trend!,
                      style: AppTypography.caption.copyWith(
                        color: isTrendPositive
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
