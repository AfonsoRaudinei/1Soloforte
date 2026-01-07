import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'side_menu.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  const DashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Check if current route is map (exactly /map) to hide AppBar/BottomNav
    final String location = GoRouterState.of(context).uri.path;
    final bool isMap = location == '/map';

    // Also check for sub-routes if we want them to be full screen?
    // Instruction says "Remover AppBar para rotas /map (fullscreen)... Manter apenas para outras rotas fora do /map"
    // Since everything is under /map prefix now, we should interpret "rotas /map" as the MAIN map screen.
    // If I am at /map/reports, I likely want the standard layout (or maybe the new design uses full screen for everything?)
    // Phase 2 says "FAB abre menu radial... 7 opções principais" -> implies the Radial Menu is the new navigation.
    // "Remover BottomNavigationBar para rotas /map... Manter apenas para outras rotas fora do /map"
    // Since ALL main routes are now /map/..., maybe formatting implies the OLD routes?
    // Let's assume for now that if we are on the main map screen '/map', we hide everything.
    // If we are on '/map/reports', we show the standard scaffolding?
    // Actually, Phase 2 implies a "Interface Fullscreen" for the home screen.
    // Let's implement logic: isMap = location == '/map'.

    return Scaffold(
      extendBodyBehindAppBar: isMap,
      appBar: isMap
          ? null
          : AppBar(
              title: const Text('SoloForte'),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
            ),
      drawer: const SideMenu(),
      body: child,
      // Only show bottom nav if NOT map and NOT a sub-feature that has its own nav?
      // User said "Manter apenas para outras rotas fora do /map".
      // Since /map is the new prefix for mostly everything... this is tricky.
      // But presumably "outras rotas fora do /map" means things that are NOT the map dashboard.
      // Wait, logically, if /map/reports is a screen, does it need a bottom bar?
      // The new design relies on the Radial Menu on the Map Screen.
      // Navigating to /map/reports likely takes you AWAY from the map.
      // So on Reports screen, you might want a way back or a menu.
      // For now, I will hide BottomNavBar for location == '/map'.
      bottomNavigationBar: isMap
          ? null
          : BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  label: 'Mapa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bug_report_outlined),
                  label: 'Ocorrências',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  label: 'Relatórios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  label: 'Clientes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Agenda',
                ),
              ],
            ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    try {
      final String location = GoRouterState.of(context).uri.path;
      if (location == '/map') return 0;
      if (location.startsWith('/map/occurrences')) return 1;
      if (location.startsWith('/map/reports')) return 2;
      if (location.startsWith('/map/clients')) return 3;
      if (location.startsWith('/map/calendar')) return 4;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/map');
        break;
      case 1:
        context.go('/map/occurrences');
        break;
      case 2:
        context.go('/map/reports');
        break;
      case 3:
        context.go('/map/clients');
        break;
      case 4:
        context.go('/map/calendar');
        break;
    }
  }
}
