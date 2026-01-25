import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Side Menu (Drawer) - Acesso administrativo e sistêmico
/// Contém apenas:
/// - Configurações
/// - Integrações
/// - Safra
/// - Suporte
/// - Notícias
/// - LinkHub
class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Colors.white,
      // CORREÇÃO: Reduzida de 85% para 65% para NUNCA cobrir os botões flutuantes
      // Os botões flutuantes precisam permanecer sempre visíveis no lado direito
      width: MediaQuery.of(context).size.width * 0.65,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 14,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SoloForte',
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Menu Principal',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Menu Items (sem scroll)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ações do Sistema
                _buildSectionHeader('AÇÕES DO SISTEMA'),

                _DrawerItem(
                  icon: Icons.bug_report_outlined,
                  label: 'Ocorrências',
                  isSelected: location.startsWith('/map/occurrences'),
                  onTap: () => context.go('/map/occurrences'),
                ),
                _DrawerItem(
                  icon: Icons.campaign_outlined,
                  label: 'Publicação',
                  isSelected: location.startsWith('/map/marketing'),
                  onTap: () {
                    if (kDebugMode) {
                      LoggerService.d('[MENU] Publicação clicked', tag: 'MENU');
                      LoggerService.d(
                        '[MENU] Current location: $location',
                        tag: 'MENU',
                      );
                      LoggerService.d(
                        '[MENU] Navigating to: /map/marketing/edit',
                        tag: 'MENU',
                      );
                    }

                    context.go('/map/marketing/edit');
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart_outlined,
                  label: 'Relatórios',
                  isSelected: location.startsWith('/map/reports'),
                  onTap: () => context.go('/map/reports'),
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  label: 'Clientes',
                  isSelected: location.startsWith('/map/clients'),
                  onTap: () => context.go('/map/clients'),
                ),
                _DrawerItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Agenda',
                  isSelected: location.startsWith('/map/calendar'),
                  onTap: () => context.go('/map/calendar'),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Divider(height: 1),
                ),

                _buildSectionHeader('CONSULTORIA'),
                _DrawerItem(
                  icon: Icons.description_outlined,
                  label: 'Documentação',
                  isSelected:
                      location == '/consultoria/comunicacao/documentacao',
                  onTap: () =>
                      context.go('/consultoria/comunicacao/documentacao'),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Divider(height: 1),
                ),

                _buildSectionHeader('CONFIGURAÇÕES'),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Configurações',
                  isSelected: location.startsWith('/map/settings'),
                  onTap: () => context.go('/map/settings'),
                ),
                _DrawerItem(
                  icon: Icons.feedback_outlined,
                  label: 'Feedback',
                  isSelected: location.startsWith('/map/feedback'),
                  onTap: () => context.go('/map/feedback'),
                ),

                const Spacer(),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 6, bottom: 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary.withValues(alpha: 0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Close drawer
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.gray100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
