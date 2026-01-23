import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/shared/widgets/modal_handle_bar.dart';

import 'marketing_pin_marker_io.dart'
    if (dart.library.html) 'marketing_pin_marker_web.dart'
    as platform;

class MarketingPublicationBottomSheet extends StatelessWidget {
  final MarketingPublication publication;
  final VoidCallback? onClose;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  const MarketingPublicationBottomSheet({
    super.key,
    required this.publication,
    this.onClose,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          publication: publication,
          onClose: onClose,
        ),
        const Divider(height: 1),
        Expanded(
          child: _Body(
            publication: publication,
            onSecondaryAction: onSecondaryAction,
            secondaryActionLabel: secondaryActionLabel,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final MarketingPublication publication;
  final VoidCallback? onClose;

  const _Header({required this.publication, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModalHandleBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildHeroImage()),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onClose,
                tooltip: 'Fechar',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _titleValue(publication),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Chip(
                label: _typeLabel(publication.type),
                background: const Color(0xFFEFF3FF),
                foreground: const Color(0xFF2C5BD5),
              ),
              _Chip(
                label: publication.investmentLevel,
                background: _investmentColor(
                  publication.investmentLevel,
                ).withValues(alpha: 0.12),
                foreground: _investmentColor(publication.investmentLevel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final cover = publication.coverPhoto;
    if (cover == null || cover.path.trim().isEmpty) {
      return _buildPlaceholder();
    }

    final path = cover.path;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return _buildNetworkImage(path);
    }

    if (path.startsWith('blob:') || path.startsWith('data:')) {
      return _buildNetworkImage(path);
    }

    return _buildLocalImage(path);
  }

  Widget _buildNetworkImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        path,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildLocalImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: platform.buildLocalImage(
        path: path,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder: _buildPlaceholder,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.campaign,
        color: AppColors.primary.withValues(alpha: 0.6),
        size: 48,
      ),
    );
  }

  String _titleValue(MarketingPublication publication) {
    final title = (publication.title ?? '').trim();
    if (title.isNotEmpty) return title;
    final client = (publication.clientName ?? '').trim();
    return client.isNotEmpty ? client : 'Publicacao de marketing';
  }

  String _typeLabel(PublicationType type) {
    switch (type) {
      case PublicationType.antesDepois:
        return 'Antes e depois';
      case PublicationType.aplicacao:
        return 'Aplicacao';
      case PublicationType.resultado:
        return 'Resultado';
      case PublicationType.comparativo:
        return 'Comparativo';
      case PublicationType.caseSucesso:
        return 'Case de sucesso';
    }
  }

  Color _investmentColor(String level) {
    switch (level) {
      case 'ouro':
      case 'premium':
        return const Color(0xFFD4AF37);
      case 'prata':
      case 'medio':
        return const Color(0xFFB0B0B0);
      default:
        return const Color(0xFFCD7F32);
    }
  }
}

class _Body extends StatelessWidget {
  final MarketingPublication publication;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  const _Body({
    required this.publication,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Descricao',
            content: (publication.description ?? '').trim(),
          ),
          _buildComparisonGallery(),
          _buildInfoSection(),
          _buildHighlightSection(),
          _buildSecondaryAction(),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitleStyle()),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildComparisonGallery() {
    final items = publication.comparisons
        .where((entry) => entry.photos.isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Galeria', style: _sectionTitleStyle()),
          const SizedBox(height: 8),
          ...items.map((entry) => _ComparisonRow(entry: entry)),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final rows = <Widget>[
      _InfoRow(label: 'Cliente', value: publication.clientName),
      _InfoRow(label: 'Area', value: publication.areaName),
      _InfoRow(label: 'Produto', value: publication.product),
      _InfoRow(label: 'Campanha', value: publication.campaign),
      _InfoRow(label: 'Safra', value: publication.harvest),
    ].whereType<_InfoRow>().toList();

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informacoes', style: _sectionTitleStyle()),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildHighlightSection() {
    final metric = (publication.highlightMetric ?? '').trim();
    final value = publication.highlightValue;
    if (metric.isEmpty || value == null) return const SizedBox.shrink();
    final formatted = value.toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resultado', style: _sectionTitleStyle()),
          const SizedBox(height: 8),
          Text(
            '$metric: $formatted ${publication.highlightUnit}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryAction() {
    if (!_shouldShowCta(publication) || onSecondaryAction == null) {
      return const SizedBox.shrink();
    }
    final label = (secondaryActionLabel ?? 'Ver case completo').trim();
    if (label.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton(
        onPressed: onSecondaryAction,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.6)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  bool _shouldShowCta(MarketingPublication publication) {
    final hasGallery = publication.comparisons.any(
      (entry) => entry.photos.isNotEmpty,
    );
    final hasHighlight =
        (publication.highlightMetric ?? '').trim().isNotEmpty &&
        publication.highlightValue != null;
    final hasRichPhotos = publication.photos.length >= 3;
    return hasGallery || hasHighlight || hasRichPhotos;
  }

  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
  }
}

class _ComparisonRow extends StatelessWidget {
  final ComparisonEntry entry;

  const _ComparisonRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: entry.photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final photo = entry.photos[index];
                return _Thumbnail(path: photo.path);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String path;

  const _Thumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path.trim().isEmpty) {
      return _placeholder();
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return _network(path);
    }

    if (path.startsWith('blob:') || path.startsWith('data:')) {
      return _network(path);
    }

    return _local(path);
  }

  Widget _network(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _local(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: platform.buildLocalImage(
        path: path,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: _placeholder,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.withValues(alpha: 0.6),
        size: 24,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final content = (value ?? '').trim();
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F4F),
              ),
            ),
          ),
          Expanded(
            child: Text(content, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
