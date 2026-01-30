import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/core/config/platform_capabilities.dart';
import '../domain/storage_category.dart';
import '../domain/storage_info.dart';
import 'storage_logger.dart';

/// Manager for storage operations (read-only in Phase 1)
///
/// IMPORTANT: This class only calculates storage sizes.
/// NO deletion or clearing operations are implemented.
class StorageManager {
  /// Get storage information for all categories
  ///
  /// Returns a list of StorageInfo objects, one for each category.
  /// This is a READ-ONLY operation. No data is modified.
  Future<List<StorageInfo>> getAllStorageInfo() async {
    final results = <StorageInfo>[];

    // NDVI Cache
    try {
      StorageLogger.calculatingSize(StorageCategory.ndviCache);
      final ndviInfo = await _getNdviCacheInfo();
      results.add(ndviInfo);
    } catch (e) {
      StorageLogger.sizeCalculationError(StorageCategory.ndviCache, e);
      results.add(
        StorageInfo.error(
          StorageCategory.ndviCache,
          'Não foi possível calcular o tamanho',
        ),
      );
    }

    // Image Cache
    try {
      StorageLogger.calculatingSize(StorageCategory.imageCache);
      final imageCacheInfo = await _getImageCacheInfo();
      results.add(imageCacheInfo);
    } catch (e) {
      StorageLogger.sizeCalculationError(StorageCategory.imageCache, e);
      results.add(
        StorageInfo.error(
          StorageCategory.imageCache,
          'Não foi possível calcular o tamanho',
        ),
      );
    }

    // Database
    try {
      StorageLogger.calculatingSize(StorageCategory.database);
      final dbInfo = await _getDatabaseInfo();
      results.add(dbInfo);
    } catch (e) {
      StorageLogger.sizeCalculationError(StorageCategory.database, e);
      results.add(
        StorageInfo.error(
          StorageCategory.database,
          'Não foi possível calcular o tamanho',
        ),
      );
    }

    // User Files
    try {
      StorageLogger.calculatingSize(StorageCategory.userFiles);
      final userFilesInfo = await _getUserFilesInfo();
      results.add(userFilesInfo);
    } catch (e) {
      StorageLogger.sizeCalculationError(StorageCategory.userFiles, e);
      results.add(
        StorageInfo.error(
          StorageCategory.userFiles,
          'Não foi possível calcular o tamanho',
        ),
      );
    }

    return results;
  }

  /// Get total storage used across all categories
  Future<int> getTotalStorageBytes() async {
    final allInfo = await getAllStorageInfo();
    return allInfo.fold<int>(0, (sum, info) => sum + info.sizeBytes);
  }

  // ========================================================================
  // CACHE CLEARING METHODS - PHASE 2
  // ========================================================================

  /// Clear NDVI cache
  ///
  /// Deletes all .png files in the ndvi_images directory.
  /// This is SAFE to clear - NDVI images can be recalculated.
  ///
  /// Returns the number of bytes freed, or throws on error.
  Future<int> clearNdviCache() async {
    if (!PlatformCapabilities.supportsLocalDatabase) {
      return 0; // No cache on web
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final ndviDir = Directory(p.join(directory.path, 'ndvi_images'));

      if (!await ndviDir.exists()) {
        return 0; // Nothing to clear
      }

      int bytesFreed = 0;
      int filesDeleted = 0;

      // Delete files atomically (one by one)
      await for (final entity in ndviDir.list(recursive: true)) {
        if (entity is File && p.extension(entity.path) == '.png') {
          try {
            final stat = await entity.stat();
            final fileSize = stat.size;

            await entity.delete();

            bytesFreed += fileSize;
            filesDeleted++;
          } catch (e) {
            StorageLogger.fileDeleteError('NDVI', e);
          }
        }
      }

      StorageLogger.cacheCleared(
        StorageCategory.ndviCache,
        bytesFreed,
        filesDeleted,
      );

      return bytesFreed;
    } catch (e) {
      StorageLogger.cacheClearError(StorageCategory.ndviCache, e);
      throw Exception(
        'Não foi possível limpar o cache agora. Tente novamente.',
      );
    }
  }

  /// Clear image cache
  ///
  /// Clears the cached_network_image cache directory.
  /// This is SAFE to clear - images will be re-downloaded when needed.
  ///
  /// Returns the number of bytes freed, or throws on error.
  Future<int> clearImageCache() async {
    if (!PlatformCapabilities.supportsLocalDatabase) {
      return 0; // No cache on web
    }

    try {
      final cacheDir = await getApplicationCacheDirectory();

      if (!await cacheDir.exists()) {
        return 0; // Nothing to clear
      }

      // Calculate size before deletion
      int bytesFreed = 0;
      int filesDeleted = 0;

      // Delete files atomically
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            final fileSize = stat.size;

            await entity.delete();

            bytesFreed += fileSize;
            filesDeleted++;
          } catch (e) {
            StorageLogger.fileDeleteError('cache image', e);
          }
        }
      }

      StorageLogger.cacheCleared(
        StorageCategory.imageCache,
        bytesFreed,
        filesDeleted,
      );

      return bytesFreed;
    } catch (e) {
      StorageLogger.cacheClearError(StorageCategory.imageCache, e);
      throw Exception(
        'Não foi possível limpar o cache agora. Tente novamente.',
      );
    }
  }

  /// Clear cache for a specific category
  ///
  /// This is the main entry point for clearing caches.
  /// Only clearable categories are allowed.
  ///
  /// Returns the number of bytes freed, or throws on error.
  Future<int> clearCache(StorageCategory category) async {
    if (!category.isClearable) {
      throw Exception(
        'Esta categoria não pode ser limpa: ${category.displayName}',
      );
    }

    switch (category) {
      case StorageCategory.ndviCache:
        return await clearNdviCache();
      case StorageCategory.imageCache:
        return await clearImageCache();
      case StorageCategory.database:
      case StorageCategory.userFiles:
        throw Exception(
          'ERRO DE SEGURANÇA: Tentativa de limpar dados críticos!',
        );
    }
  }

  // ========================================================================
  // PRIVATE METHODS - Storage Calculation (READ-ONLY)
  // ========================================================================

  /// Calculate NDVI cache size
  ///
  /// Reads the ndvi_images directory and sums up all .png files.
  /// This is READ-ONLY - no files are deleted.
  Future<StorageInfo> _getNdviCacheInfo() async {
    if (!PlatformCapabilities.supportsLocalDatabase) {
      return StorageInfo(
        category: StorageCategory.ndviCache,
        sizeBytes: 0,
        fileCount: 0,
      );
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final ndviDir = Directory(p.join(directory.path, 'ndvi_images'));

      if (!await ndviDir.exists()) {
        return StorageInfo(
          category: StorageCategory.ndviCache,
          sizeBytes: 0,
          fileCount: 0,
        );
      }

      int totalSize = 0;
      int fileCount = 0;

      await for (final entity in ndviDir.list(recursive: true)) {
        if (entity is File && p.extension(entity.path) == '.png') {
          final stat = await entity.stat();
          totalSize += stat.size;
          fileCount++;
        }
      }

      return StorageInfo(
        category: StorageCategory.ndviCache,
        sizeBytes: totalSize,
        fileCount: fileCount,
      );
    } catch (e) {
      return StorageInfo.error(StorageCategory.ndviCache, e.toString());
    }
  }

  /// Calculate image cache size
  ///
  /// Estimates cache size from cached_network_image.
  /// This is READ-ONLY - no cache is cleared.
  Future<StorageInfo> _getImageCacheInfo() async {
    try {
      // On web, cached_network_image uses browser cache
      if (!PlatformCapabilities.supportsLocalDatabase) {
        return StorageInfo(
          category: StorageCategory.imageCache,
          sizeBytes: 0,
          fileCount: null,
        );
      }

      // On mobile, check application cache directory
      final cacheDir = await getApplicationCacheDirectory();

      if (!await cacheDir.exists()) {
        return StorageInfo(
          category: StorageCategory.imageCache,
          sizeBytes: 0,
          fileCount: 0,
        );
      }

      int totalSize = 0;
      int fileCount = 0;

      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            totalSize += stat.size;
            fileCount++;
          } catch (_) {
            // Skip files we can't read
          }
        }
      }

      return StorageInfo(
        category: StorageCategory.imageCache,
        sizeBytes: totalSize,
        fileCount: fileCount,
      );
    } catch (e) {
      return StorageInfo.error(StorageCategory.imageCache, e.toString());
    }
  }

  /// Get database size
  ///
  /// Returns the size of the SQLite database file.
  /// This is READ-ONLY - database is never deleted.
  Future<StorageInfo> _getDatabaseInfo() async {
    if (!PlatformCapabilities.supportsLocalDatabase) {
      return StorageInfo(
        category: StorageCategory.database,
        sizeBytes: 0,
        fileCount: null,
      );
    }

    try {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;
      final dbPath = db.path;

      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        return StorageInfo(category: StorageCategory.database, sizeBytes: 0);
      }

      final stat = await dbFile.stat();
      return StorageInfo(
        category: StorageCategory.database,
        sizeBytes: stat.size,
        fileCount: 1,
      );
    } catch (e) {
      return StorageInfo.error(StorageCategory.database, e.toString());
    }
  }

  /// Get user files size
  ///
  /// Calculates size of user-generated files (uploads, exports).
  /// This is READ-ONLY - user files are never deleted without explicit confirmation.
  Future<StorageInfo> _getUserFilesInfo() async {
    if (!PlatformCapabilities.supportsLocalDatabase) {
      return StorageInfo(
        category: StorageCategory.userFiles,
        sizeBytes: 0,
        fileCount: 0,
      );
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      int totalSize = 0;
      int fileCount = 0;

      // Check uploads directory
      final uploadsDir = Directory(p.join(directory.path, 'uploads'));
      if (await uploadsDir.exists()) {
        await for (final entity in uploadsDir.list(recursive: true)) {
          if (entity is File) {
            try {
              final stat = await entity.stat();
              totalSize += stat.size;
              fileCount++;
            } catch (_) {}
          }
        }
      }

      // Check exported directory
      final exportedDir = Directory(p.join(directory.path, 'exported'));
      if (await exportedDir.exists()) {
        await for (final entity in exportedDir.list(recursive: true)) {
          if (entity is File) {
            try {
              final stat = await entity.stat();
              totalSize += stat.size;
              fileCount++;
            } catch (_) {}
          }
        }
      }

      return StorageInfo(
        category: StorageCategory.userFiles,
        sizeBytes: totalSize,
        fileCount: fileCount,
      );
    } catch (e) {
      return StorageInfo.error(StorageCategory.userFiles, e.toString());
    }
  }
}
