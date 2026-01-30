import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/shared/widgets/modal_handle_bar.dart';

import 'marketing_pin_marker_io.dart'
    if (dart.library.html) 'marketing_pin_marker_web.dart'
    as platform;

class MarketingPublicPreviewBottomSheet extends StatelessWidget {
  final MarketingPublication publication;
  final VoidCallback? onClose;
  final VoidCallback? onLogin;

  const MarketingPublicPreviewBottomSheet({
    super.key,
    required this.publication,
    this.onClose,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(onClose: onClose),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            primary: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroImage(publication: publication),
                const SizedBox(height: 16),
                const Text(
                  'Publicacao de marketing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  _approximateLocation(publication),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF5A5A5A)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: Color(0xFF757575),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_calculateSimulatedViews(publication)} visualizacoes',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '•',
                      style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.draw_outlined,
                      size: 14,
                      color: Color(0xFF757575),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_calculateSimulatedSignatures(publication)} assinaturas',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Entrar para ver detalhes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
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

class _HeroImage extends StatelessWidget {
  final MarketingPublication publication;

  const _HeroImage({required this.publication});

  @override
  Widget build(BuildContext context) {
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
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        path,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildLocalImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: platform.buildLocalImage(
        path: path,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: _buildPlaceholder,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.campaign,
        color: AppColors.primary.withValues(alpha: 0.6),
        size: 52,
      ),
    );
  }
}

String _approximateLocation(MarketingPublication publication) {
  final lat = publication.latitude.toStringAsFixed(1);
  final lng = publication.longitude.toStringAsFixed(1);
  return 'Localizacao aproximada: $lat, $lng';
}

int _calculateSimulatedViews(MarketingPublication publication) {
  final daysSincePublished = DateTime.now()
      .difference(publication.publishedAt ?? publication.createdAt)
      .inDays;
  final seed = publication.id.hashCode.abs() % 10;
  return (daysSincePublished * 2) + seed + 5;
}

int _calculateSimulatedSignatures(MarketingPublication publication) {
  final views = _calculateSimulatedViews(publication);
  final seed = publication.id.hashCode.abs() % 3;
  return (views * 0.2).round() + seed;
}
