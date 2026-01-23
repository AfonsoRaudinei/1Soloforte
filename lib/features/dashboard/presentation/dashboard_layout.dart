import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/shared/widgets/contextual_floating_button.dart';
import 'side_menu.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;
  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  final ValueNotifier<bool> _isEndDrawerOpen = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _isEndDrawerOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardDrawerScope(
      isEndDrawerOpen: _isEndDrawerOpen,
      openEndDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
      child: Stack(
        children: [
          // Scaffold principal
          Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            appBar: null, // Sem AppBar no ShellRoute (Hard Mode)
            endDrawer: const SideMenu(),
            endDrawerEnableOpenDragGesture: true,
            drawerScrimColor: Colors.black.withValues(alpha: 0.4),
            onEndDrawerChanged: (isOpen) => _isEndDrawerOpen.value = isOpen,
            body: widget.child,
            // BottomNavigationBar removido para manter interface fullscreen em todo o ShellRoute
          ),

          // ✅ CORREÇÃO ESTRUTURAL DE Z-ORDER:
          // Botão Flutuante Contextual posicionado FORA do Scaffold
          // para garantir que NUNCA seja coberto pelo Drawer.
          Positioned(
            right: 16,
            bottom: 16,
            child: const ContextualFloatingButton(),
          ),
        ],
      ),
    );
  }
}

class DashboardDrawerScope extends InheritedWidget {
  final ValueListenable<bool> isEndDrawerOpen;
  final VoidCallback openEndDrawer;

  const DashboardDrawerScope({
    required this.isEndDrawerOpen,
    required this.openEndDrawer,
    required super.child,
  });

  static DashboardDrawerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DashboardDrawerScope>();
  }

  @override
  bool updateShouldNotify(DashboardDrawerScope oldWidget) {
    return oldWidget.isEndDrawerOpen != isEndDrawerOpen;
  }
}
