import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/shared/widgets/modal_handle_bar.dart';

class OccurrencePreviewBottomSheet extends StatelessWidget {
  final Occurrence occurrence;
  final VoidCallback? onClose;

  const OccurrencePreviewBottomSheet({
    super.key,
    required this.occurrence,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(onClose: onClose),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderInfo(occurrence: occurrence),
                SizedBox(height: AppSpacing.md),
                _StatusBadge(status: occurrence.status),
                if (occurrence.images.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.md),
                  _ImageScroll(images: occurrence.images),
                ],
                if (occurrence.description.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.md),
                  Text('Descrição', style: AppTypography.h4),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    occurrence.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        _FooterActions(occurrenceId: occurrence.id),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback? onClose;

  const _Header({this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const ModalHandleBar(),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClose,
              tooltip: 'Fechar',
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final Occurrence occurrence;

  const _HeaderInfo({required this.occurrence});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(occurrence.type),
                color: AppColors.primary,
                size: 24,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(occurrence.title, style: AppTypography.h3),
                  Text(
                    '📍 ${occurrence.areaName}',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'pest':
        return Icons.bug_report;
      case 'disease':
        return Icons.coronavirus;
      case 'weed':
        return Icons.grass;
      default:
        return Icons.warning;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.error;
      case 'monitoring':
        return AppColors.warning;
      case 'resolved':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'ATIVA';
      case 'monitoring':
        return 'MONITORANDO';
      case 'resolved':
        return 'RESOLVIDA';
      default:
        return status.toUpperCase();
    }
  }
}

class _ImageScroll extends StatelessWidget {
  final List<String> images;

  const _ImageScroll({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final path = images[index];
          final isNetwork = path.startsWith('http') || path.startsWith('https');

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isNetwork
                ? Image.network(
                    path,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : Image.file(
                    File(path),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}

class _FooterActions extends StatelessWidget {
  final String occurrenceId;

  const _FooterActions({required this.occurrenceId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navegação CANÔNICA para detalhes
              context.push('/occurrences/detail/$occurrenceId');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Ver detalhes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
