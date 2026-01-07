import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current route to highlight active item
    final String location = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.eco, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'SoloForte',
                  style: AppTypography.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _DrawerItem(
                    icon: Icons.map_outlined,
                    label: 'Mapa',
                    isSelected: location == '/map',
                    onTap: () => context.go('/map'),
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
                  _DrawerItem(
                    icon: Icons.satellite_alt_outlined,
                    label: 'NDVI',
                    isSelected: location.startsWith('/map/ndvi'),
                    onTap: () => context.go('/map/ndvi'),
                  ),
                  _DrawerItem(
                    icon: Icons.cloud_outlined,
                    label: 'Clima',
                    isSelected: location.startsWith('/map/weather'),
                    onTap: () => context.go('/map/weather'),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      top: 24,
                      bottom: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GESTÃO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.campaign_outlined,
                    label: 'Marketing',
                    isSelected: location.startsWith('/map/marketing'),
                    onTap: () => context.go('/map/marketing'),
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Configurações',
                    isSelected: location.startsWith('/map/settings'),
                    onTap: () => context.go('/map/settings'),
                  ),
                  _DrawerItem(
                    icon: Icons.bug_report_outlined,
                    label: 'Ocorrências',
                    isSelected: location.startsWith('/map/occurrences'),
                    onTap: () => context.go('/map/occurrences'),
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'Relatórios',
                    isSelected: location.startsWith('/map/reports'),
                    onTap: () => context.go('/map/reports'),
                  ),
                  _DrawerItem(
                    icon: Icons.agriculture_outlined,
                    label: 'Safra',
                    isSelected: location.startsWith('/map/harvest'),
                    onTap: () => context.go('/map/harvest'),
                  ),
                  _DrawerItem(
                    icon: Icons.hub_outlined,
                    label: 'Integrações',
                    isSelected: location.startsWith('/map/integrations'),
                    onTap: () => context.go('/map/integrations'),
                  ),
                  _DrawerItem(
                    icon: Icons.link,
                    label: 'LinkHub',
                    isSelected: location.startsWith('/map/link-hub'),
                    onTap: () => context.go('/map/link-hub'),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Divider(height: 1),
                  ),

                  _DrawerItem(
                    icon: Icons.newspaper_outlined,
                    label: 'Notícias',
                    isSelected: location.startsWith('/map/feed'),
                    onTap: () => context.go('/map/feed'),
                  ),
                  _DrawerItem(
                    icon: Icons.support_agent_outlined,
                    label: 'Suporte',
                    isSelected: location.startsWith('/map/support'),
                    onTap: () => context.go('/map/support'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Close drawer
            onTap();
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
