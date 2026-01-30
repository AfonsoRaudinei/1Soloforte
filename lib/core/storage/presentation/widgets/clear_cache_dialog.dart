import 'package:flutter/material.dart';
import 'package:soloforte_app/core/storage/domain/storage_info.dart';
import 'package:soloforte_app/core/storage/domain/storage_category.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

/// Dialog to confirm cache clearing
///
/// Shows warning about impact and requires explicit user confirmation.
class ClearCacheDialog extends StatelessWidget {
  final StorageInfo info;

  const ClearCacheDialog({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Limpar ${info.category.displayName}?',
              style: AppTypography.h3,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Size info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.delete_sweep, color: Colors.grey[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Espaço a liberar: ',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  info.formattedSize,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Warning message
          if (info.category.clearWarning != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      info.category.clearWarning!,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Confirmation text
          Text(
            'Esta ação não pode ser desfeita.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancelar',
            style: AppTypography.bodyMedium.copyWith(color: Colors.grey[700]),
          ),
        ),

        // Confirm button
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Limpar Cache'),
        ),
      ],
    );
  }

  /// Show the dialog and return user's choice
  static Future<bool> show(BuildContext context, StorageInfo info) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClearCacheDialog(info: info),
    );
    return result ?? false;
  }
}
