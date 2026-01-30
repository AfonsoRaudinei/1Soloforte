import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/storage/application/storage_provider.dart';
import 'package:soloforte_app/core/storage/domain/storage_info.dart';
import 'package:soloforte_app/core/storage/domain/storage_category.dart';
import 'package:soloforte_app/core/storage/presentation/widgets/storage_category_card.dart';
import 'package:soloforte_app/core/storage/presentation/widgets/clear_cache_dialog.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

/// Storage Management Screen - PHASE 2 (Safe Cache Clearing)
///
/// This screen displays storage usage information and allows clearing
/// non-critical caches with explicit confirmation.
///
/// PROTECTED: Database, Secure Storage, SharedPreferences, and user files
/// are NEVER cleared.
class StorageManagementScreen extends ConsumerStatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  ConsumerState<StorageManagementScreen> createState() =>
      _StorageManagementScreenState();
}

class _StorageManagementScreenState
    extends ConsumerState<StorageManagementScreen> {
  bool _isClearing = false;

  /// Handle cache clearing with confirmation
  Future<void> _handleClearCache(StorageInfo info) async {
    // Show confirmation dialog
    final confirmed = await ClearCacheDialog.show(context, info);
    if (!confirmed || !mounted) return;

    // Show loading
    setState(() => _isClearing = true);

    try {
      // Get storage manager
      final manager = ref.read(storageManagerProvider);

      // Clear the cache
      final bytesFreed = await manager.clearCache(info.category);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cache limpo com sucesso! ${(bytesFreed / (1024 * 1024)).toStringAsFixed(1)} MB liberados.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

      // Refresh storage info
      ref.invalidate(storageInfoProvider);
      ref.invalidate(totalStorageProvider);
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Erro ao limpar cache: $e')),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isClearing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageInfoAsync = ref.watch(storageInfoProvider);
    final totalStorageAsync = ref.watch(totalStorageProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Gerenciar Armazenamento', style: AppTypography.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(storageInfoProvider);
              ref.invalidate(totalStorageProvider);
              await ref.read(storageInfoProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Storage Card
                  _buildTotalStorageCard(totalStorageAsync),

                  const SizedBox(height: 24),

                  // Info Banner
                  _buildInfoBanner(),

                  const SizedBox(height: 24),

                  // Section Title
                  Text(
                    'CATEGORIAS',
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Storage Categories List
                  _buildStorageList(storageInfoAsync),

                  const SizedBox(height: 24),

                  // Footer Info
                  _buildFooter(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isClearing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTotalStorageCard(AsyncValue<int> totalStorageAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Uso Total',
                style: AppTypography.h3.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          totalStorageAsync.when(
            data: (totalBytes) {
              final mb = totalBytes / (1024 * 1024);
              return Text(
                '${mb.toStringAsFixed(1)} MB',
                style: AppTypography.h1.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            loading: () => const SizedBox(
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            error: (err, stack) => Text(
              'Erro ao calcular',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Armazenamento local utilizado',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.green[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Limpeza segura de caches disponível',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.green[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageList(AsyncValue<List<StorageInfo>> storageInfoAsync) {
    return storageInfoAsync.when(
      data: (storageList) {
        if (storageList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum dado encontrado',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: storageList.map((info) {
            return StorageCategoryCard(
              info: info,
              onClear: info.category.isClearable
                  ? () => _handleClearCache(info)
                  : null,
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar informações',
              style: AppTypography.h4.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                'Dados Protegidos',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Apenas caches podem ser limpos. Banco de dados, '
            'configurações e arquivos do usuário estão permanentemente protegidos.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Limpando cache...', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
