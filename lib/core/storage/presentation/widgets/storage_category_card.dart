import 'package:flutter/material.dart';
import 'package:soloforte_app/core/storage/domain/storage_info.dart';
import 'package:soloforte_app/core/storage/domain/storage_category.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

/// Card widget to display storage information for a category
///
/// Phase 2: Now supports clearing caches with onClear callback.
class StorageCategoryCard extends StatelessWidget {
  final StorageInfo info;
  final VoidCallback? onClear;

  const StorageCategoryCard({super.key, required this.info, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Icon
              Text(info.category.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(info.category.displayName, style: AppTypography.h4),
              ),

              // Size
              Text(
                info.formattedSize,
                style: AppTypography.h4.copyWith(
                  color: info.hasData ? AppColors.primary : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // File count (if available)
          if (info.fileCountDescription != null)
            Text(
              info.fileCountDescription!,
              style: AppTypography.caption.copyWith(color: Colors.grey[600]),
            ),

          const SizedBox(height: 8),

          // Description
          Text(
            info.category.description,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),

          // Error message (if any)
          if (info.hasError) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      info.errorMessage!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Clear button (Phase 2) or Read-only badge
          if (info.category.isClearable && !info.hasError) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: info.hasData && onClear != null ? onClear : null,
                icon: Icon(
                  Icons.delete_sweep,
                  size: 18,
                  color: info.hasData ? AppColors.error : Colors.grey[400],
                ),
                label: Text(
                  'Limpar Cache',
                  style: AppTypography.bodyMedium.copyWith(
                    color: info.hasData ? AppColors.error : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: info.hasData ? AppColors.error : Colors.grey[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ] else if (!info.category.isClearable && !info.hasError) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Somente leitura',
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
