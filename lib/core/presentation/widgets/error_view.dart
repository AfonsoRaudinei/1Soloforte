import 'package:flutter/material.dart';
import 'package:soloforte_app/core/error/exceptions.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

/// Reusable error display widget.
///
/// Provides consistent error UI across the app with action buttons.
class ErrorView extends StatelessWidget {
  /// The error to display
  final Object? error;

  /// Custom message to display (overrides error message)
  final String? message;

  /// Custom icon to display
  final IconData? icon;

  /// Retry callback - shows "Tentar Novamente" button
  final VoidCallback? onRetry;

  /// Go back callback - shows "Voltar" button
  final VoidCallback? onGoBack;

  /// Custom action button
  final Widget? action;

  /// Whether to show a compact version
  final bool compact;

  const ErrorView({
    super.key,
    this.error,
    this.message,
    this.icon,
    this.onRetry,
    this.onGoBack,
    this.action,
    this.compact = false,
  });

  /// Create from AppException
  factory ErrorView.fromException(
    AppException exception, {
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    bool compact = false,
  }) {
    return ErrorView(
      error: exception,
      message: exception.message,
      icon: _getIconForException(exception),
      onRetry: onRetry,
      onGoBack: onGoBack,
      compact: compact,
    );
  }

  /// Network error view
  factory ErrorView.network({VoidCallback? onRetry, bool compact = false}) {
    return ErrorView(
      message: 'Sem conexão com a internet',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      compact: compact,
    );
  }

  /// Empty state view
  factory ErrorView.empty({
    String message = 'Nenhum item encontrado',
    IconData icon = Icons.inbox_outlined,
    Widget? action,
  }) {
    return ErrorView(message: message, icon: icon, action: action);
  }

  static IconData _getIconForException(AppException exception) {
    return switch (exception) {
      NetworkException() => Icons.wifi_off,
      AuthException() => Icons.lock_outline,
      ValidationException() => Icons.warning_amber,
      StorageException() => Icons.storage,
      ApiException() => Icons.cloud_off,
      UnexpectedException() => Icons.error_outline,
      NotImplementedException() => Icons.construction,
    };
  }

  String get _displayMessage {
    if (message != null) return message!;
    if (error is AppException) return (error as AppException).message;
    if (error != null) return 'Ocorreu um erro inesperado';
    return 'Algo deu errado';
  }

  IconData get _displayIcon {
    if (icon != null) return icon!;
    if (error is AppException)
      return _getIconForException(error as AppException);
    return Icons.error_outline;
  }

  Color get _iconColor {
    if (error is NetworkException) return Colors.orange;
    if (error is AuthException) return Colors.red;
    if (error is ValidationException) return Colors.amber;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _iconColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_displayIcon, color: _iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _displayMessage,
              style: AppTypography.bodyMedium.copyWith(color: Colors.grey[800]),
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: _iconColor,
            ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_displayIcon, size: 64, color: _iconColor),
            ),
            const SizedBox(height: 24),
            Text(
              _displayMessage,
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (error is AppException && (error as AppException).code != null)
              Text(
                'Código: ${(error as AppException).code}',
                style: AppTypography.caption.copyWith(color: Colors.grey),
              ),
            const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final actions = <Widget>[];

    if (onRetry != null) {
      actions.add(
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar Novamente'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }

    if (onGoBack != null) {
      actions.add(
        TextButton.icon(
          onPressed: onGoBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Voltar'),
        ),
      );
    }

    if (action != null) {
      actions.add(action!);
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: actions,
    );
  }
}

/// Inline error text for form fields
class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 12),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: AppColors.error),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Snackbar helper for showing errors
class ErrorSnackBar {
  static void show(BuildContext context, Object error) {
    final message = error is AppException
        ? error.message
        : 'Ocorreu um erro inesperado';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
