import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

/// Empty state widget for when no cache is stored
class EmptyStorageState extends StatelessWidget {
  final String message;

  const EmptyStorageState({
    super.key,
    this.message = 'Nenhum cache armazenado',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.folder_open_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Os dados aparecerão aqui assim que forem criados',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading state widget with animation
class LoadingStorageState extends StatelessWidget {
  final String message;

  const LoadingStorageState({
    super.key,
    this.message = 'Calculando tamanhos...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loading indicator
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: const CircularProgressIndicator(strokeWidth: 3),
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Success banner after cache clearing
class SuccessBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const SuccessBanner({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (onDismiss != null)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.green[700],
                      ),
                      onPressed: onDismiss,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
