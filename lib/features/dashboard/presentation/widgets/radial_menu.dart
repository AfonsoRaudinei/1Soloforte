import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class RadialMenu extends StatefulWidget {
  final VoidCallback onClose;

  const RadialMenu({super.key, required this.onClose});

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      icon: Icons.settings,
      label: 'Configuração',
      route: '/map/settings',
    ),
    _MenuItem(
      icon: Icons.satellite_alt,
      label: 'NDVI Viewer',
      route: '/map/ndvi',
    ),
    _MenuItem(icon: Icons.cloud, label: 'Clima Premium', route: '/map/weather'),
    _MenuItem(icon: Icons.people, label: 'Clientes', route: '/map/clients'),
    _MenuItem(
      icon: Icons.calendar_today,
      label: 'Agenda',
      route: '/map/calendar',
    ),
    _MenuItem(
      icon: Icons.campaign,
      label: 'Marketing',
      route: '/map/marketing',
    ),
    _MenuItem(
      icon: Icons.bar_chart,
      label: 'Relatórios',
      route: '/map/reports',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    HapticFeedback.lightImpact();
    _controller.reverse().then((_) => widget.onClose());
  }

  void _navigateTo(String route) {
    HapticFeedback.mediumImpact();
    _controller.reverse().then((_) {
      widget.onClose();
      context.push(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: _handleClose,
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Menu Items List (Vertical)
        Positioned(
          bottom: 100, // Positioned above the FAB
          right: 24,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_menuItems.length, (index) {
                    final item = _menuItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMenuItem(item, index),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item, int index) {
    // Add a slight stagger effect
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton.small(
                  heroTag: 'menu_item_$index',
                  onPressed: () => _navigateTo(item.route),
                  backgroundColor:
                      AppColors.secondary, // Secondary color for actions
                  child: Icon(item.icon, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;

  _MenuItem({required this.icon, required this.label, required this.route});
}
