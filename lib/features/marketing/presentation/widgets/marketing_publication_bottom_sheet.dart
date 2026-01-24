/// 🚨 MAPA CANÔNICO — PREVIEW (UI)
///
/// Este widget é o CONTEÚDO do Bottom Sheet que abre ao clicar no mapa.
/// NÃO É UMA ROTA. É um overlay controlado pelo [MarketingPublicationSheetListener].
///
/// ⚠️ NÃO CONFUNDIR COM O EDITOR.
/// Se você alterar aqui, muda apenas o "mini-card" que sobe no mapa.
///
/// FLUXO:
/// MAPA -> Clique -> [MarketingPublicationBottomSheet] (Preview) -> CTA "Ver Completo" -> EDITOR

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
    // 🎨 UX CANÔNICA (Conteúdo & Hierarquia)
    //
    // OBJETIVO: Resumo rápido ("Glanceable")
    //
    // ESTRUTURA OBRIGATÓRIA:
    // 1. Header: Handle bar + Botão Fechar (X)
    // 2. Hero: Imagem Principal ou Placeholder de destaque
    // 3. Info: Título, Cliente, Badges (Tipo/Investimento)
    // 4. Metrics: Destaque de resultado (ex: +15 sc/ha)
    // 5. AÇÃO PRIMÁRIA: Botão "Ver case completo" (Leva ao Editor)
    //
    // 🚫 PROIBIDO NO PREVIEW:
    // - Formulários de edição
    // - Upload de arquivos
    // - Abas complexas (Tabs)
    // - AppBars (Use o Header do próprio sheet)

    final state = _resolveState(publication);
    return Column(
      children: [
        _Header(onClose: onClose),
        const Divider(height: 1),
        Expanded(
          child: _Body(publication: publication, state: state),
        ),
        if (state == _PreviewState.ready &&
            onSecondaryAction != null &&
            (secondaryActionLabel ?? 'Ver case completo').trim().isNotEmpty)
          _FooterCta(
            label: secondaryActionLabel ?? 'Ver case completo',
            onPressed: onSecondaryAction,
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

enum _PreviewState { loading, empty, error, ready }

class _Body extends StatelessWidget {
  final MarketingPublication publication;
  final _PreviewState state;

  const _Body({
    required this.publication,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state == _PreviewState.loading) {
      return const _StatePlaceholder(
        icon: Icons.hourglass_empty,
        title: 'Carregando preview...',
        subtitle: 'Buscando informacoes do case.',
      );
    }
    if (state == _PreviewState.error) {
      return const _StatePlaceholder(
        icon: Icons.error_outline,
        title: 'Nao foi possivel carregar',
        subtitle: 'Tente novamente em alguns instantes.',
      );
    }
    if (state == _PreviewState.empty) {
      return const _StatePlaceholder(
        icon: Icons.inbox_outlined,
        title: 'Sem dados para exibir',
        subtitle: 'Este case ainda nao tem conteudo publicado.',
      );
    }
    return SingleChildScrollView(
      primary: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroImage(publication: publication),
          const SizedBox(height: 16),
          _InfoBlock(publication: publication),
          const SizedBox(height: 12),
          if (_hasHighlight(publication))
            _MetricCard(publication: publication),
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

class _InfoBlock extends StatelessWidget {
  final MarketingPublication publication;

  const _InfoBlock({required this.publication});

  @override
  Widget build(BuildContext context) {
    final title = _titleValue(publication);
    final client = (publication.clientName ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        if (client.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            client,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A5A5A),
            ),
          ),
        ],
        const SizedBox(height: 10),
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
            if (publication.status.trim().isNotEmpty)
              _Chip(
                label: _statusLabel(publication.status),
                background: const Color(0xFFF1F1F1),
                foreground: const Color(0xFF5A5A5A),
              ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final MarketingPublication publication;

  const _MetricCard({required this.publication});

  @override
  Widget build(BuildContext context) {
    final metric = (publication.highlightMetric ?? '').trim();
    final value = publication.highlightValue ?? 0;
    final formatted = value.toStringAsFixed(1);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: Color(0xFF2C5BD5)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$metric: $formatted ${publication.highlightUnit}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCta extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _FooterCta({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatePlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StatePlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF9E9E9E)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF7A7A7A)),
            ),
          ],
        ),
      ),
    );
  }
}

_PreviewState _resolveState(MarketingPublication publication) {
  final status = publication.status.trim().toLowerCase();
  if (status == 'loading') {
    return _PreviewState.loading;
  }
  if (status == 'error') {
    return _PreviewState.error;
  }
  final hasTitle = (publication.title ?? '').trim().isNotEmpty;
  final hasClient = (publication.clientName ?? '').trim().isNotEmpty;
  final hasCover = publication.coverPhoto != null;
  final hasMetric = _hasHighlight(publication);
  if (!hasTitle && !hasClient && !hasCover && !hasMetric) {
    return _PreviewState.empty;
  }
  return _PreviewState.ready;
}

bool _hasHighlight(MarketingPublication publication) {
  return (publication.highlightMetric ?? '').trim().isNotEmpty &&
      publication.highlightValue != null;
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

String _statusLabel(String status) {
  final normalized = status.trim();
  if (normalized.isEmpty) return 'Status';
  return normalized[0].toUpperCase() + normalized.substring(1);
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
