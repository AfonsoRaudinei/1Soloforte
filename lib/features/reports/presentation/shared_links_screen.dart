import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_sharing_service.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:intl/intl.dart';

/// Tela para gerenciar links compartilhados
class SharedLinksScreen extends ConsumerStatefulWidget {
  const SharedLinksScreen({super.key});

  @override
  ConsumerState<SharedLinksScreen> createState() => _SharedLinksScreenState();
}

class _SharedLinksScreenState extends ConsumerState<SharedLinksScreen> {
  List<PublicShareLink> _sharedLinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSharedLinks();
  }

  Future<void> _loadSharedLinks() async {
    setState(() => _isLoading = true);

    // TODO: Carregar links do backend ou SharedPreferences
    // Por enquanto, lista vazia
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _sharedLinks = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Links Compartilhados'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sharedLinks.isEmpty
          ? _buildEmptyState()
          : _buildLinksList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.link_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              'Nenhum link compartilhado',
              style: AppTypography.h2.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              'Crie links públicos para compartilhar\nseus relatórios com outras pessoas',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _sharedLinks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildLinkCard(_sharedLinks[index]);
      },
    );
  }

  Widget _buildLinkCard(PublicShareLink link) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: link.canBeAccessed
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  link.canBeAccessed ? Icons.link : Icons.link_off,
                  color: link.canBeAccessed ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.reportTitle,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Criado em ${DateFormat('dd/MM/yyyy').format(link.createdAt)}',
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, link),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 20),
                        SizedBox(width: 12),
                        Text('Copiar Link'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'stats',
                    child: Row(
                      children: [
                        Icon(Icons.analytics, size: 20),
                        SizedBox(width: 12),
                        Text('Ver Estatísticas'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'revoke',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text(
                          'Revogar Acesso',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // URL
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    link.publicUrl,
                    style: AppTypography.caption.copyWith(
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(link.publicUrl),
                  tooltip: 'Copiar',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (link.hasPassword)
                _buildBadge(
                  '🔒 Protegido',
                  Colors.orange[100]!,
                  Colors.orange[900]!,
                ),
              if (link.isExpired)
                _buildBadge('⏰ Expirado', Colors.red[100]!, Colors.red[900]!)
              else if (link.expiresAt != null)
                _buildBadge(
                  '⏰ Expira ${DateFormat('dd/MM').format(link.expiresAt!)}',
                  Colors.blue[100]!,
                  Colors.blue[900]!,
                ),
              _buildBadge(
                '👁️ ${link.viewCount} visualizações',
                Colors.purple[100]!,
                Colors.purple[900]!,
              ),
              if (link.maxViews != null)
                _buildBadge(
                  'Máx ${link.maxViews}',
                  Colors.grey[200]!,
                  Colors.grey[700]!,
                ),
              if (!link.isActive)
                _buildBadge('🚫 Inativo', Colors.grey[300]!, Colors.grey[800]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleMenuAction(String action, PublicShareLink link) {
    switch (action) {
      case 'copy':
        _copyToClipboard(link.publicUrl);
        break;
      case 'stats':
        _showStatistics(link);
        break;
      case 'revoke':
        _revokeLink(link);
        break;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copiado!')));
  }

  Future<void> _showStatistics(PublicShareLink link) async {
    final stats = await reportSharingService.getShareStatistics(link.shareId);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estatísticas'),
        content: stats != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    'Total de visualizações:',
                    '${stats.totalViews}',
                  ),
                  _buildStatRow(
                    'Visualizadores únicos:',
                    '${stats.uniqueViewers}',
                  ),
                  if (stats.lastViewedAt != null)
                    _buildStatRow(
                      'Última visualização:',
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(stats.lastViewedAt!),
                    ),
                ],
              )
            : const Text('Não foi possível carregar as estatísticas'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _revokeLink(PublicShareLink link) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar Acesso'),
        content: const Text(
          'Tem certeza que deseja revogar o acesso a este link?\n\n'
          'O link deixará de funcionar imediatamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await reportSharingService.revokePublicLink(link.shareId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Link revogado com sucesso' : 'Erro ao revogar link',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          _loadSharedLinks();
        }
      }
    }
  }
}
