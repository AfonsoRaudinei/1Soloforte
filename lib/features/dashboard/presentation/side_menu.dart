import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Side Menu (Drawer) - Acesso administrativo e sistêmico
/// Redesenhado para estilo técnico, clean e profissional (Agro Tech)
class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      width: 320, // Largura controlada e fixa (320px)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Bordas retas e limpas
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Minimalista
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Logo simples e técnico
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SoloForte',
                            style: AppTypography.h3.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Menu Principal',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Divisor sutil
          Divider(height: 1, color: AppColors.gray200),

          const SizedBox(height: 24),

          // 2. AÇÕES DO SISTEMA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('AÇÕES DO SISTEMA'),
                  const SizedBox(height: 8),

                  _DrawerItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'Relatórios',
                    isSelected: location.startsWith('/map/reports'),
                    isCompact: false,
                    onTap: () => context.go('/map/reports'),
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline,
                    label: 'Clientes',
                    isSelected: location.startsWith('/map/clients'),
                    isCompact: false,
                    onTap: () => context.go('/map/clients'),
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Agenda',
                    isSelected: location.startsWith('/map/calendar'),
                    isCompact: false,
                    onTap: () => context.go('/map/calendar'),
                  ),

                  const SizedBox(height: 32),

                  // 3. CONFIGURAÇÕES (Visual Secundário)
                  Divider(height: 1, color: AppColors.gray100),
                  const SizedBox(height: 24),

                  _buildSectionTitle('CONFIGURAÇÕES'),
                  const SizedBox(height: 8),

                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Configurações',
                    isSelected: location.startsWith('/map/settings'),
                    isCompact: true, // Visual mais discreto
                    onTap: () => context.go('/map/settings'),
                  ),
                  _DrawerItem(
                    icon: Icons.feedback_outlined,
                    label: 'Feedback',
                    isSelected: location.startsWith('/map/feedback'),
                    isCompact: true,
                    onTap: () => context.go('/map/feedback'),
                  ),
                ],
              ),
            ),
          ),

          // Rodapé técnico (opcional, só para fechar o layout visualmente)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'v1.0.0 • SoloForte Agro',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCompact; // Novo parâmetro para controlar hierarquia
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    // Cores baseadas na hierarquia (Compact = Secundário)
    final Color activeColor = AppColors.primary;
    final Color inactiveIconColor = isCompact
        ? AppColors.textTertiary
        : AppColors.textSecondary;
    final Color inactiveTextColor = isCompact
        ? AppColors.textSecondary
        : AppColors.textPrimary;
    final double iconSize = isCompact ? 18 : 22;
    final FontWeight fontWeight = isSelected
        ? FontWeight.w600
        : (isCompact ? FontWeight.w400 : FontWeight.w500);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Close drawer
            onTap();
          },
          borderRadius: BorderRadius.circular(8),
          hoverColor: AppColors.gray50,
          child: Container(
            decoration: BoxDecoration(
              // Fundo apenas se selecionado, mas sutil
              color: isSelected ? AppColors.blue50 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: AppColors.blue100, width: 1)
                  : Border.all(color: Colors.transparent, width: 1),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: isCompact ? 10 : 12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: isSelected ? activeColor : inactiveIconColor,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? activeColor : inactiveTextColor,
                    fontWeight: fontWeight,
                    fontSize: isCompact ? 13 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
