import 'dart:ui';
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
      backgroundColor: Colors.transparent, // Transparent to show blur
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      width:
          MediaQuery.of(context).size.width *
          0.85, // Slightly wider for modern feel
      child: ClipRRect(
        // Clip the blur
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), // Strong blur
          child: Container(
            color: Colors.white.withOpacity(0.85), // Semi-transparent white

            child: Column(
              children: [
                // Header - Using a gradient or just spacing
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9),
                  ),
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
                              color: Colors.black.withOpacity(0.1),
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

                // Menu Items wrapped in Expanded SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(), // iOS scroll
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _DrawerItem(
                          icon: Icons.dashboard_outlined,
                          label: 'Dashboard',
                          isSelected: location == '/dashboard',
                          onTap: () => context.go('/dashboard'),
                        ),
                        _DrawerItem(
                          icon: Icons.map_outlined,
                          label: 'Mapa',
                          isSelected: location.startsWith('/dashboard/map'),
                          onTap: () => context.go('/dashboard/map'),
                        ),
                        _DrawerItem(
                          icon: Icons.people_outline,
                          label: 'Clientes',
                          isSelected: location.startsWith('/dashboard/clients'),
                          onTap: () => context.go('/dashboard/clients'),
                        ),
                        _DrawerItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Agenda',
                          isSelected: location.startsWith(
                            '/dashboard/calendar',
                          ),
                          onTap: () => context.go('/dashboard/calendar'),
                        ),
                        _DrawerItem(
                          icon: Icons.satellite_alt_outlined,
                          label: 'NDVI',
                          isSelected: location.startsWith('/dashboard/ndvi'),
                          onTap: () => context.go('/dashboard/ndvi'),
                        ),
                        _DrawerItem(
                          icon: Icons.cloud_outlined,
                          label: 'Clima',
                          isSelected: location.startsWith('/dashboard/weather'),
                          onTap: () => context.go('/dashboard/weather'),
                        ),

                        // Management Section
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
                                color: AppColors.textSecondary.withOpacity(0.5),

                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        _DrawerItem(
                          icon: Icons.campaign_outlined,
                          label: 'Marketing',
                          isSelected: location.startsWith(
                            '/dashboard/marketing',
                          ),
                          onTap: () => context.go('/dashboard/marketing'),
                        ),
                        _DrawerItem(
                          icon: Icons.settings_outlined,
                          label: 'Configurações',
                          isSelected: location.startsWith(
                            '/dashboard/settings',
                          ),
                          onTap: () => context.go('/dashboard/settings'),
                        ),
                        _DrawerItem(
                          icon: Icons.bug_report_outlined,
                          label: 'Ocorrências',
                          isSelected: location.startsWith(
                            '/dashboard/occurrences',
                          ),
                          onTap: () => context.go('/dashboard/occurrences'),
                        ),
                        _DrawerItem(
                          icon: Icons.bar_chart_outlined,
                          label: 'Relatórios',
                          isSelected: location.startsWith('/dashboard/reports'),
                          onTap: () => context.go('/dashboard/reports'),
                        ),
                        _DrawerItem(
                          icon: Icons.agriculture_outlined,
                          label: 'Safra',
                          isSelected: location.startsWith('/dashboard/harvest'),
                          onTap: () => context.go('/dashboard/harvest'),
                        ),
                        _DrawerItem(
                          icon: Icons.hub_outlined,
                          label: 'Integrações',
                          isSelected: location.startsWith(
                            '/dashboard/integrations',
                          ),
                          onTap: () => context.go('/dashboard/integrations'),
                        ),
                        _DrawerItem(
                          icon: Icons.link,
                          label: 'LinkHub',
                          isSelected: location.startsWith(
                            '/dashboard/link-hub',
                          ),
                          onTap: () => context.go('/dashboard/link-hub'),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Divider(height: 1),
                        ),

                        _DrawerItem(
                          icon: Icons.newspaper_outlined,
                          label: 'Notícias',
                          isSelected: location.startsWith('/dashboard/feed'),
                          onTap: () => context.go('/dashboard/feed'),
                        ),
                        _DrawerItem(
                          icon: Icons.support_agent_outlined,
                          label: 'Suporte',
                          isSelected: location.startsWith('/dashboard/support'),
                          onTap: () => context.go('/dashboard/support'),
                        ),
                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
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
            ? AppColors.primary.withOpacity(0.1)
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
