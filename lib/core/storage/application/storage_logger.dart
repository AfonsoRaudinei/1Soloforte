import 'package:flutter/foundation.dart';
import '../domain/storage_category.dart';

/// Internal logger for storage operations
///
/// Logs storage-related events for debugging and auditing.
/// NO SENSITIVE DATA is logged (no file names, no user data).
class StorageLogger {
  static const String _tag = '[StorageManager]';

  /// Log screen opened
  static void screenOpened() {
    if (kDebugMode) {
      print('$_tag Screen opened at ${DateTime.now().toIso8601String()}');
    }
  }

  /// Log size calculation started
  static void calculatingSize(StorageCategory category) {
    if (kDebugMode) {
      print('$_tag Calculating size for: ${category.displayName}');
    }
  }

  /// Log size calculation completed
  static void sizeCalculated(
    StorageCategory category,
    int bytes,
    int? fileCount,
  ) {
    if (kDebugMode) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(2);
      final files = fileCount != null ? ', $fileCount files' : '';
      print('$_tag ${category.displayName}: $mb MB$files');
    }
  }

  /// Log size calculation error
  static void sizeCalculationError(StorageCategory category, Object error) {
    if (kDebugMode) {
      print('$_tag ERROR calculating ${category.displayName}: $error');
    }
  }

  /// Log cache clearing started
  static void clearingCache(StorageCategory category, int sizeBytes) {
    if (kDebugMode) {
      final mb = (sizeBytes / (1024 * 1024)).toStringAsFixed(2);
      print(
        '$_tag CLEARING ${category.displayName} ($mb MB) at ${DateTime.now().toIso8601String()}',
      );
    }
  }

  /// Log cache clearing success
  static void cacheCleared(
    StorageCategory category,
    int bytesFreed,
    int filesDeleted,
  ) {
    if (kDebugMode) {
      final mb = (bytesFreed / (1024 * 1024)).toStringAsFixed(2);
      print(
        '$_tag SUCCESS: ${category.displayName} cleared - $mb MB freed, $filesDeleted files deleted',
      );
    }
  }

  /// Log cache clearing error
  static void cacheClearError(StorageCategory category, Object error) {
    if (kDebugMode) {
      print('$_tag ERROR clearing ${category.displayName}: $error');
    }
  }

  /// Log file deletion error (non-critical)
  static void fileDeleteError(String fileType, Object error) {
    if (kDebugMode) {
      print('$_tag WARNING: Could not delete $fileType file: $error');
    }
  }

  /// Log operation completed
  static void operationCompleted(String operation, Duration duration) {
    if (kDebugMode) {
      print('$_tag $operation completed in ${duration.inMilliseconds}ms');
    }
  }
}
