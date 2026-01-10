import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soloforte_app/core/error/exceptions.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Global error handler for the application.
///
/// Catches all uncaught errors and:
/// - Logs them appropriately
/// - Reports to Sentry in production
/// - Shows user-friendly error UI
class GlobalErrorHandler {
  static bool _initialized = false;

  /// Initialize global error handling.
  /// Call this in main() before runApp().
  static void init() {
    if (_initialized) return;
    _initialized = true;

    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Handle errors outside Flutter (platform, isolates)
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true; // Prevent default error handling
    };

    LoggerService.i('GlobalErrorHandler initialized', tag: 'ERROR');
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    LoggerService.e(
      'Flutter Error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FLUTTER',
    );

    // Report to Sentry in production
    if (!kDebugMode) {
      Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
        hint: Hint.withMap({
          'library': details.library,
          'context': details.context?.toDescription(),
        }),
      );
    }

    // In debug mode, use default Flutter behavior
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Handle platform/isolate errors
  static void _handlePlatformError(Object error, StackTrace stack) {
    LoggerService.e(
      'Platform Error: $error',
      error: error,
      stackTrace: stack,
      tag: 'PLATFORM',
    );

    // Report to Sentry in production
    if (!kDebugMode) {
      Sentry.captureException(error, stackTrace: stack);
    }
  }

  /// Run the app with error zone protection.
  ///
  /// Usage:
  /// ```dart
  /// void main() {
  ///   GlobalErrorHandler.init();
  ///   GlobalErrorHandler.runAppGuarded(() => runApp(MyApp()));
  /// }
  /// ```
  static void runAppGuarded(void Function() appRunner) {
    runZonedGuarded(appRunner, (error, stack) {
      _handleZoneError(error, stack);
    });
  }

  /// Handle errors caught by runZonedGuarded
  static void _handleZoneError(Object error, StackTrace stack) {
    // Convert to AppException if possible for better handling
    final AppException appError = _convertToAppException(error);

    LoggerService.e(
      'Zone Error: ${appError.message}',
      error: error,
      stackTrace: stack,
      tag: 'ZONE',
    );

    // Report to Sentry in production
    if (!kDebugMode) {
      Sentry.captureException(error, stackTrace: stack);
    }
  }

  /// Convert generic errors to AppException
  static AppException _convertToAppException(Object error) {
    if (error is AppException) return error;

    // Handle common error types
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return NetworkException(originalError: error);
    }

    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('token')) {
      return AuthException(originalError: error);
    }

    if (errorString.contains('database') ||
        errorString.contains('storage') ||
        errorString.contains('file')) {
      return StorageException(originalError: error);
    }

    return UnexpectedException(originalError: error);
  }

  /// Show error dialog - use for critical errors that need user attention
  static Future<void> showErrorDialog(
    BuildContext context,
    Object error, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    final appError = error is AppException
        ? error
        : _convertToAppException(error);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getIconForError(appError), color: Colors.red),
            const SizedBox(width: 8),
            Text(title ?? 'Erro'),
          ],
        ),
        content: Text(appError.message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Tentar Novamente'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static IconData _getIconForError(AppException error) {
    return switch (error) {
      NetworkException() => Icons.wifi_off,
      AuthException() => Icons.lock_outline,
      ValidationException() => Icons.warning_amber,
      StorageException() => Icons.storage,
      ApiException() => Icons.cloud_off,
      UnexpectedException() => Icons.error_outline,
      NotImplementedException() => Icons.construction,
    };
  }
}

/// Extension for Result pattern - safer error handling
extension SafeAsync<T> on Future<T> {
  /// Execute future safely, returning null on error
  Future<T?> get safe async {
    try {
      return await this;
    } catch (e, stack) {
      LoggerService.e('Safe async failed', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Execute with retry on failure
  Future<T> withRetry({
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    Object? lastError;

    while (attempt < maxAttempts) {
      try {
        return await this;
      } catch (e) {
        lastError = e;
        attempt++;
        if (attempt < maxAttempts) {
          await Future.delayed(delay * attempt);
        }
      }
    }

    throw lastError!;
  }

  /// Execute with fallback value on error
  Future<T> withDefault(T defaultValue) async {
    try {
      return await this;
    } catch (_) {
      return defaultValue;
    }
  }
}
