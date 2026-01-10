import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/application/report_sharing_service.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

/// Modal com opções de compartilhamento de relatório
class ShareOptionsModal extends ConsumerStatefulWidget {
  final String reportId;
  final String reportTitle;
  final Uint8List pdfBytes;

  const ShareOptionsModal({
    super.key,
    required this.reportId,
    required this.reportTitle,
    required this.pdfBytes,
  });

  @override
  ConsumerState<ShareOptionsModal> createState() => _ShareOptionsModalState();
}

class _ShareOptionsModalState extends ConsumerState<ShareOptionsModal> {
  bool _isLoading = false;
  PublicShareLink? _generatedLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_generatedLink != null) ...[
                          _buildGeneratedLinkSection(),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                        ],
                        Text('Compartilhar via:', style: AppTypography.h3),
                        const SizedBox(height: 16),
                        _buildShareOptions(),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                        Text('Criar Link Público:', style: AppTypography.h3),
                        const SizedBox(height: 16),
                        _buildPublicLinkOptions(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.share, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Compartilhar Relatório', style: AppTypography.h2),
                const SizedBox(height: 4),
                Text(
                  widget.reportTitle,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedLinkSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Link Público Criado!',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _generatedLink!.publicUrl,
                    style: AppTypography.caption.copyWith(
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () => _copyToClipboard(_generatedLink!.publicUrl),
                  tooltip: 'Copiar link',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_generatedLink!.hasPassword)
                Chip(
                  label: const Text('🔒 Protegido'),
                  backgroundColor: Colors.orange[100],
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.orange[900],
                  ),
                ),
              if (_generatedLink!.expiresAt != null) ...[
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    '⏰ Expira em ${_formatExpiry(_generatedLink!.expiresAt!)}',
                  ),
                  backgroundColor: Colors.blue[100],
                  labelStyle: TextStyle(fontSize: 11, color: Colors.blue[900]),
                ),
              ],
              if (_generatedLink!.maxViews != null) ...[
                const SizedBox(width: 8),
                Chip(
                  label: Text('👁️ Máx ${_generatedLink!.maxViews} views'),
                  backgroundColor: Colors.purple[100],
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.purple[900],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions() {
    return Column(
      children: [
        _ShareOptionTile(
          icon: Icons.share,
          title: 'Compartilhar',
          subtitle: 'Usar apps instalados no dispositivo',
          color: Colors.blue,
          onTap: () => _shareNative(),
        ),
        const SizedBox(height: 12),
        _ShareOptionTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'Enviar por email com anexo',
          color: Colors.red,
          onTap: () => _shareViaEmail(),
        ),
        const SizedBox(height: 12),
        _ShareOptionTile(
          icon: Icons.chat,
          title: 'WhatsApp',
          subtitle: 'Compartilhar via WhatsApp',
          color: Colors.green,
          onTap: () => _shareViaWhatsApp(),
        ),
        const SizedBox(height: 12),
        _ShareOptionTile(
          icon: Icons.cloud_upload,
          title: 'Google Drive',
          subtitle: 'Fazer upload para o Drive',
          color: Colors.orange,
          onTap: () => _uploadToGoogleDrive(),
        ),
        const SizedBox(height: 12),
        _ShareOptionTile(
          icon: Icons.folder,
          title: 'Dropbox',
          subtitle: 'Fazer upload para o Dropbox',
          color: Colors.indigo,
          onTap: () => _uploadToDropbox(),
        ),
      ],
    );
  }

  Widget _buildPublicLinkOptions() {
    return Column(
      children: [
        PrimaryButton(
          text: 'Criar Link Simples',
          onPressed: () => _createPublicLink(),
          icon: Icons.link,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _showAdvancedLinkOptions(),
          icon: const Icon(Icons.settings),
          label: const Text('Opções Avançadas'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  // Ações de compartilhamento

  Future<void> _shareNative() async {
    setState(() => _isLoading = true);

    final success = await reportSharingService.shareNative(
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compartilhado com sucesso!')),
      );
    }
  }

  Future<void> _shareViaEmail() async {
    setState(() => _isLoading = true);

    final success = await reportSharingService.sendViaEmail(
      recipients: [], // O sistema abrirá o app de email
      subject: widget.reportTitle,
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _shareViaWhatsApp() async {
    setState(() => _isLoading = true);

    final success = await reportSharingService.shareViaWhatsApp(
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _uploadToGoogleDrive() async {
    setState(() => _isLoading = true);

    final url = await reportSharingService.uploadToGoogleDrive(
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            url != null
                ? 'Upload para Google Drive concluído!'
                : 'Função em desenvolvimento',
          ),
        ),
      );
    }
  }

  Future<void> _uploadToDropbox() async {
    setState(() => _isLoading = true);

    final url = await reportSharingService.uploadToDropbox(
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            url != null
                ? 'Upload para Dropbox concluído!'
                : 'Função em desenvolvimento',
          ),
        ),
      );
    }
  }

  Future<void> _createPublicLink() async {
    setState(() => _isLoading = true);

    final link = await reportSharingService.createPublicLink(
      reportId: widget.reportId,
      reportTitle: widget.reportTitle,
      pdfBytes: widget.pdfBytes,
    );

    setState(() {
      _isLoading = false;
      _generatedLink = link;
    });

    if (link != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link público criado!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showAdvancedLinkOptions() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _AdvancedLinkDialog(),
    );

    if (result != null) {
      setState(() => _isLoading = true);

      final link = await reportSharingService.createPublicLink(
        reportId: widget.reportId,
        reportTitle: widget.reportTitle,
        pdfBytes: widget.pdfBytes,
        password: result['password'] as String?,
        expiresAt: result['expiresAt'] as DateTime?,
        maxViews: result['maxViews'] as int?,
      );

      setState(() {
        _isLoading = false;
        _generatedLink = link;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copiado!')));
  }

  String _formatExpiry(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now());
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    return '${diff.inMinutes}min';
  }
}

class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _AdvancedLinkDialog extends StatefulWidget {
  const _AdvancedLinkDialog();

  @override
  State<_AdvancedLinkDialog> createState() => _AdvancedLinkDialogState();
}

class _AdvancedLinkDialogState extends State<_AdvancedLinkDialog> {
  final _passwordController = TextEditingController();
  DateTime? _expiresAt;
  int? _maxViews;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Opções Avançadas'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Senha (opcional):', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Digite uma senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Text('Expiração:', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('24h'),
                  selected:
                      _expiresAt != null &&
                      _expiresAt!.difference(DateTime.now()).inHours == 24,
                  onSelected: (selected) {
                    setState(() {
                      _expiresAt = selected
                          ? DateTime.now().add(const Duration(hours: 24))
                          : null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('7 dias'),
                  selected:
                      _expiresAt != null &&
                      _expiresAt!.difference(DateTime.now()).inDays == 7,
                  onSelected: (selected) {
                    setState(() {
                      _expiresAt = selected
                          ? DateTime.now().add(const Duration(days: 7))
                          : null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('30 dias'),
                  selected:
                      _expiresAt != null &&
                      _expiresAt!.difference(DateTime.now()).inDays == 30,
                  onSelected: (selected) {
                    setState(() {
                      _expiresAt = selected
                          ? DateTime.now().add(const Duration(days: 30))
                          : null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Limite de visualizações:', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [10, 50, 100].map((views) {
                return ChoiceChip(
                  label: Text('$views views'),
                  selected: _maxViews == views,
                  onSelected: (selected) {
                    setState(() => _maxViews = selected ? views : null);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'password': _passwordController.text.isEmpty
                  ? null
                  : _passwordController.text,
              'expiresAt': _expiresAt,
              'maxViews': _maxViews,
            });
          },
          child: const Text('Criar Link'),
        ),
      ],
    );
  }
}
