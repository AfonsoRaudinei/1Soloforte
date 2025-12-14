import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/application/client_history_service.dart';

class ClientQuickActions extends ConsumerWidget {
  final String phone;
  final String email;
  final String clientId;
  final VoidCallback? onCallComplete;
  final VoidCallback? onWhatsAppComplete;
  final VoidCallback? onEmailComplete;

  const ClientQuickActions({
    super.key,
    required this.phone,
    required this.email,
    required this.clientId,
    this.onCallComplete,
    this.onWhatsAppComplete,
    this.onEmailComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ações Rápidas', style: AppTypography.h4),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickActionButton(
                icon: Icons.phone,
                label: 'Ligar',
                color: Colors.green,
                onTap: () => _makePhoneCall(context, ref),
              ),
              _QuickActionButton(
                icon: Icons.chat,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => _openWhatsApp(context, ref),
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                color: Colors.blue,
                onTap: () => _sendEmail(context, ref),
              ),
              _QuickActionButton(
                icon: Icons.description,
                label: 'Relatórios',
                color: AppColors.info,
                onTap: () => _viewReports(context),
              ),
              _QuickActionButton(
                icon: Icons.map,
                label: 'Ver no Mapa',
                color: AppColors.primary,
                onTap: () => _viewOnMap(context),
              ),
              _QuickActionButton(
                icon: Icons.calendar_today,
                label: 'Agendar',
                color: Colors.orange,
                onTap: () => _scheduleVisit(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, WidgetRef ref) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('tel:$cleanPhone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);

      // Registrar no histórico
      try {
        await ref
            .read(clientHistoryServiceProvider)
            .recordCall(clientId: clientId, phone: phone);
      } catch (e) {
        debugPrint('Erro ao registrar ligação no histórico: $e');
      }

      onCallComplete?.call();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível fazer a ligação')),
        );
      }
    }
  }

  Future<void> _openWhatsApp(BuildContext context, WidgetRef ref) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/55$cleanPhone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // Registrar no histórico
      try {
        await ref
            .read(clientHistoryServiceProvider)
            .recordWhatsApp(clientId: clientId, phone: phone);
      } catch (e) {
        debugPrint('Erro ao registrar WhatsApp no histórico: $e');
      }

      onWhatsAppComplete?.call();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, WidgetRef ref) async {
    final uri = Uri.parse('mailto:$email');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);

      // Registrar no histórico
      try {
        await ref
            .read(clientHistoryServiceProvider)
            .recordEmail(clientId: clientId, email: email);
      } catch (e) {
        debugPrint('Erro ao registrar email no histórico: $e');
      }

      onEmailComplete?.call();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o email')),
        );
      }
    }
  }

  void _viewReports(BuildContext context) {
    // TODO: Navegar para tela de relatórios filtrados por cliente
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ver relatórios (em desenvolvimento)')),
    );
  }

  void _viewOnMap(BuildContext context) {
    // TODO: Navegar para mapa com áreas do cliente
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ver no mapa (em desenvolvimento)')),
    );
  }

  void _scheduleVisit(BuildContext context) {
    // TODO: Navegar para tela de agendamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendar visita (em desenvolvimento)')),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
