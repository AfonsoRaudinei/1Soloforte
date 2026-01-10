import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralized logging service for SoloForte app.
///
/// Use this instead of print() throughout the codebase.
/// In production, ONLY errors and warnings are sent to Sentry for monitoring.
/// Console logs (developer.log) are completely disabled in release builds to prevent
/// sensitive data leakage via logcat/console.
class LoggerService {
  // Prevent instantiation
  LoggerService._();

  /// Debug log - only shown in debug mode
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(message, name: tag ?? 'DEBUG', level: 700);
    }
  }

  /// Info log - only shown in debug mode
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(message, name: tag ?? 'INFO', level: 800);
    }
  }

  /// Warning log - Sent to Sentry in release, shown in console in debug
  static void w(String message, {String? tag, Object? error}) {
    if (kDebugMode) {
      developer.log(message, name: tag ?? 'WARN', level: 900, error: error);
    } else {
      // Send to Sentry in production
      Sentry.captureMessage(message, level: SentryLevel.warning);
    }
  }

  /// Error log - Sent to Sentry in release, shown in console in debug
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'ERROR',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // Send to Sentry in production (only non-debug)
      if (error != null) {
        Sentry.captureException(
          error,
          stackTrace: stackTrace,
          hint: Hint.withMap({'message': message, 'tag': tag}),
        );
      } else {
        Sentry.captureMessage(message, level: SentryLevel.error);
      }
    }
  }

  /// Log an API call (for debugging network issues) - Debug only
  static void api(
    String method,
    String path, {
    int? statusCode,
    String? error,
  }) {
    if (!kDebugMode) return;

    final status = statusCode != null ? ' → $statusCode' : '';
    final err = error != null ? ' [ERROR: $error]' : '';
    developer.log('$method $path$status$err', name: 'API', level: 800);
  }

  /// Log navigation events - Debug only
  static void nav(String event, [String? route]) {
    if (!kDebugMode) return;

    final routeInfo = route != null ? ' → $route' : '';
    developer.log('$event$routeInfo', name: 'NAV', level: 700);
  }

  /// Log performance metrics - Debug only
  static void perf(String operation, int durationMs) {
    if (!kDebugMode) return;

    // Only log strictly slow operations in release if needed, but for now blocking all
    developer.log(
      '$operation completed in ${durationMs}ms',
      name: 'PERF',
      level: 700,
    );
  }
}
