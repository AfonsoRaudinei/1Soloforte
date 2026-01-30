import 'storage_category.dart';

/// Information about storage usage for a specific category
class StorageInfo {
  final StorageCategory category;
  final int sizeBytes;
  final int? fileCount;
  final String? errorMessage;

  const StorageInfo({
    required this.category,
    required this.sizeBytes,
    this.fileCount,
    this.errorMessage,
  });

  /// Format size in human-readable format
  String get formattedSize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      final kb = sizeBytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (sizeBytes < 1024 * 1024 * 1024) {
      final mb = sizeBytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = sizeBytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(2)} GB';
    }
  }

  /// Get file count description
  String? get fileCountDescription {
    if (fileCount == null) return null;
    if (fileCount == 0) return 'nenhum arquivo';
    if (fileCount == 1) return '1 arquivo';
    return '$fileCount arquivos';
  }

  /// Whether this category has data
  bool get hasData => sizeBytes > 0;

  /// Whether there was an error reading this category
  bool get hasError => errorMessage != null;

  /// Create a copy with updated values
  StorageInfo copyWith({
    StorageCategory? category,
    int? sizeBytes,
    int? fileCount,
    String? errorMessage,
  }) {
    return StorageInfo(
      category: category ?? this.category,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileCount: fileCount ?? this.fileCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Create an error instance
  factory StorageInfo.error(StorageCategory category, String error) {
    return StorageInfo(category: category, sizeBytes: 0, errorMessage: error);
  }
}
