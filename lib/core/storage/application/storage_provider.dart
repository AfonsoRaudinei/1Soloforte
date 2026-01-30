import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/storage/application/storage_manager.dart';
import 'package:soloforte_app/core/storage/domain/storage_info.dart';

/// Provider for StorageManager instance
final storageManagerProvider = Provider<StorageManager>((ref) {
  return StorageManager();
});

/// Provider for storage information
///
/// This is a FutureProvider that calculates storage usage.
/// It's READ-ONLY - no data is modified.
final storageInfoProvider = FutureProvider<List<StorageInfo>>((ref) async {
  final manager = ref.watch(storageManagerProvider);
  return await manager.getAllStorageInfo();
});

/// Provider for total storage used
final totalStorageProvider = FutureProvider<int>((ref) async {
  final manager = ref.watch(storageManagerProvider);
  return await manager.getTotalStorageBytes();
});
