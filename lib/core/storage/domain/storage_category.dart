/// Storage categories for the app
enum StorageCategory {
  /// NDVI images cache stored locally
  ndviCache,

  /// Network images cache (cached_network_image)
  imageCache,

  /// SQLite database (read-only)
  database,

  /// User-generated files (exports, uploads)
  userFiles,
}

/// Extension to provide metadata for each category
extension StorageCategoryExtension on StorageCategory {
  /// Display name for the category
  String get displayName {
    switch (this) {
      case StorageCategory.ndviCache:
        return 'Cache de Imagens NDVI';
      case StorageCategory.imageCache:
        return 'Cache de Imagens';
      case StorageCategory.database:
        return 'Banco de Dados';
      case StorageCategory.userFiles:
        return 'Arquivos do Usuário';
    }
  }

  /// Icon for the category
  String get icon {
    switch (this) {
      case StorageCategory.ndviCache:
        return '📸';
      case StorageCategory.imageCache:
        return '🗺️';
      case StorageCategory.database:
        return '💾';
      case StorageCategory.userFiles:
        return '📁';
    }
  }

  /// Description for the category
  String get description {
    switch (this) {
      case StorageCategory.ndviCache:
        return 'Imagens NDVI armazenadas para visualização offline.';
      case StorageCategory.imageCache:
        return 'Imagens baixadas automaticamente. Podem ser recuperadas com internet.';
      case StorageCategory.database:
        return 'Dados do aplicativo. Não pode ser apagado.';
      case StorageCategory.userFiles:
        return 'Arquivos gerados ou enviados pelo usuário.';
    }
  }

  /// Whether this category can be cleared (Phase 2)
  bool get isClearable {
    switch (this) {
      case StorageCategory.ndviCache:
      case StorageCategory.imageCache:
        return true; // Phase 2: Cache can be safely cleared
      case StorageCategory.database:
      case StorageCategory.userFiles:
        return false; // Never clearable - critical data
    }
  }

  /// Warning message to show before clearing
  String? get clearWarning {
    switch (this) {
      case StorageCategory.ndviCache:
        return 'As imagens NDVI precisarão ser recalculadas quando você estiver offline.';
      case StorageCategory.imageCache:
        return 'As imagens serão baixadas novamente quando houver internet.';
      case StorageCategory.database:
      case StorageCategory.userFiles:
        return null; // Never clearable
    }
  }
}
