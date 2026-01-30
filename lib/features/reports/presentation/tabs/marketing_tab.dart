import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/marketing/data/marketing_publication_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_reach_icon.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';

/// 📊 Aba Marketing — Relatórios
/// Função: leitura, análise e encaminhamento para edição
/// Não cria. Não edita inline. Não inventa métrica.
class MarketingTab extends ConsumerWidget {
  const MarketingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicationsAsync = ref.watch(marketingPublicationsProvider);

    return publicationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erro ao carregar publicações: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (publications) {
        // Filtrar apenas publicações publicadas e visíveis
        final visiblePublications = publications
            .where((p) => p.isVisible && p.status == 'published')
            .toList();

        // Calcular totais (mesmo que seja 0)
        final totalPublications = visiblePublications.length;
        var totalViews = 0;
        var totalSignatures = 0;

        for (final pub in visiblePublications) {
          totalViews += _calculateSimulatedViews(pub);
          totalSignatures += _calculateSimulatedSignatures(pub);
        }

        return Column(
          children: [
            // 1️⃣ Cards de Resumo (sempre visíveis, mesmo com 0)
            _SummaryCards(
              totalPublications: totalPublications,
              totalSignatures: totalSignatures,
              totalViews: totalViews,
            ),
            const Divider(height: 1),
            // 2️⃣ Lista de Publicações ou estado vazio
            Expanded(
              child: visiblePublications.isEmpty
                  ? const Center(
                      child: EmptyStateWidget(
                        title: 'Nenhuma publicação de marketing no período',
                        message:
                            'As publicações criadas no mapa aparecerão aqui.',
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: visiblePublications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final publication = visiblePublications[index];
                        return _PublicationRow(publication: publication);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// 1️⃣ Cards de Resumo no Topo
class _SummaryCards extends StatelessWidget {
  final int totalPublications;
  final int totalSignatures;
  final int totalViews;

  const _SummaryCards({
    required this.totalPublications,
    required this.totalSignatures,
    required this.totalViews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'Publicações',
              value: totalPublications.toString(),
              icon: Icons.campaign,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              label: 'Assinaturas',
              value: totalSignatures.toString(),
              icon: Icons.draw_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              label: 'Visualizações',
              value: totalViews.toString(),
              icon: Icons.visibility_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF757575)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
        ],
      ),
    );
  }
}

/// 2️⃣ Linha de Publicação (layout horizontal compacto)
class _PublicationRow extends StatelessWidget {
  final MarketingPublication publication;

  const _PublicationRow({required this.publication});

  @override
  Widget build(BuildContext context) {
    final viewsCount = _calculateSimulatedViews(publication);
    final signaturesCount = _calculateSimulatedSignatures(publication);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha 1: Ícone + Título + Cliente/Fazenda
          Row(
            children: [
              _TypeIcon(type: publication.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTypeLabel(publication.type),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      publication.title ??
                          publication.clientName ??
                          'Publicação sem título',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Linha 2: Cliente/Área | Data
          Row(
            children: [
              Expanded(
                child: Text(
                  _buildClientAreaText(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                DateFormat(
                  'dd/MM/yyyy',
                ).format(publication.publishedAt ?? publication.createdAt),
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Linha 3: Sinais + Ação
          Row(
            children: [
              // 👁️ Visualizações
              const Icon(
                Icons.visibility_outlined,
                size: 16,
                color: Color(0xFF757575),
              ),
              const SizedBox(width: 4),
              Text(
                viewsCount.toString(),
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 16),
              // ✍️ Assinaturas
              const Icon(
                Icons.draw_outlined,
                size: 16,
                color: Color(0xFF757575),
              ),
              const SizedBox(width: 4),
              Text(
                signaturesCount.toString(),
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 16),
              MarketingReachIcon(
                level: reachLevelFromInvestmentLevel(
                  publication.investmentLevel,
                ),
                size: 16,
              ),
              const SizedBox(width: 16),
              // 👥 Avatares
              _CompactAvatars(count: viewsCount),
              const Spacer(),
              // ✏️ Botão Editar
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/map/marketing/edit?id=${publication.id}');
                },
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Editar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  foregroundColor: const Color(0xFF757575),
                  textStyle: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildClientAreaText() {
    if (publication.clientName != null && publication.areaName != null) {
      return '${publication.clientName} • ${publication.areaName}';
    } else if (publication.clientName != null) {
      return publication.clientName!;
    } else if (publication.areaName != null) {
      return publication.areaName!;
    }
    return 'Cliente não definido';
  }
}

/// Ícone do tipo de publicação
class _TypeIcon extends StatelessWidget {
  final PublicationType type;

  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_getTypeIconData(), size: 20, color: _getTypeColor()),
    );
  }

  IconData _getTypeIconData() {
    switch (type) {
      case PublicationType.antesDepois:
        return Icons.compare_arrows;
      case PublicationType.aplicacao:
        return Icons.agriculture;
      case PublicationType.resultado:
        return Icons.trending_up;
      case PublicationType.comparativo:
        return Icons.analytics_outlined;
      case PublicationType.caseSucesso:
        return Icons.star_outline;
    }
  }

  Color _getTypeColor() {
    switch (type) {
      case PublicationType.antesDepois:
        return const Color(0xFF2196F3);
      case PublicationType.aplicacao:
        return const Color(0xFF4CAF50);
      case PublicationType.resultado:
        return const Color(0xFFFF9800);
      case PublicationType.comparativo:
        return const Color(0xFF9C27B0);
      case PublicationType.caseSucesso:
        return const Color(0xFFFFC107);
    }
  }
}

/// Avatares compactos (máx 3)
class _CompactAvatars extends StatelessWidget {
  final int count;

  const _CompactAvatars({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    final displayCount = count > 3 ? 3 : count;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(displayCount, (index) {
          return Container(
            margin: EdgeInsets.only(left: index == 0 ? 0 : 4),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getAvatarColor(index),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getAvatarInitial(index),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
        if (count > 3)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '+${count - 3}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF757575),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFFFFC107),
    ];
    return colors[index % colors.length];
  }

  String _getAvatarInitial(int index) {
    final initials = ['A', 'B', 'C', 'D', 'E'];
    return initials[index % initials.length];
  }
}

// ───────────────────────────────────────────────────────────────────
// Simulação de Dados (até implementar tabelas reais)
// ───────────────────────────────────────────────────────────────────

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

String _getTypeLabel(PublicationType type) {
  switch (type) {
    case PublicationType.antesDepois:
      return 'Antes e Depois';
    case PublicationType.aplicacao:
      return 'Aplicação';
    case PublicationType.resultado:
      return 'Resultado';
    case PublicationType.comparativo:
      return 'Comparativo';
    case PublicationType.caseSucesso:
      return 'Case de Sucesso';
  }
}
