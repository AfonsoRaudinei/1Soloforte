import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:soloforte_app/core/config/platform_capabilities.dart';
import 'package:soloforte_app/shared/widgets/contextual_floating_button.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/web_dashboard_gate.dart';
import 'side_menu.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;
  final bool isPublicPreview;
  const DashboardLayout({
    super.key,
    required this.child,
    required this.isPublicPreview,
  });

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
    // 🧱 GATE DE WEB (OBRIGATÓRIO)
    // Impede que o Dashboard/Mapa execute lógica pesada de storage no primeiro frame
    // Retorna a UI simplificada se estiver no Web e na rota principal
    // 🧱 GATE DE WEB (REMOVIDO A PEDIDO - "MODO NORMAL")
    // O usuário solicitou ver o app completo mesmo no web/preview.
    /*
    if (PlatformCapabilities.isWeb) {
      final String location = GoRouterState.of(context).uri.path;
      // Rotas pesadas que devem ser bloqueadas no Web
      // '/map' e '/' usam HomeScreen que tem init pesado
      if (location == '/map' || location == '/') {
        return const WebDashboardGate();
      }
    }
    */

    final isPublicPreview = widget.isPublicPreview;
    final shouldRenderInternalUi = !isPublicPreview;
    assert(
      !(isPublicPreview && shouldRenderInternalUi),
      'UI interna renderizada em modo publico',
    );

    return DashboardDrawerScope(
      isEndDrawerOpen: _isEndDrawerOpen,
      openEndDrawer: () {
        if (shouldRenderInternalUi) {
          _scaffoldKey.currentState?.openEndDrawer();
        }
      },
      child: Stack(
        children: [
          // Scaffold principal
          Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            appBar: null, // Sem AppBar no ShellRoute (Hard Mode)
            endDrawer: shouldRenderInternalUi ? const SideMenu() : null,
            endDrawerEnableOpenDragGesture: shouldRenderInternalUi,
            drawerScrimColor: Colors.black.withValues(alpha: 0.4),
            onEndDrawerChanged: (isOpen) => _isEndDrawerOpen.value = isOpen,
            body: widget.child,
            // BottomNavigationBar removido para manter interface fullscreen em todo o ShellRoute
          ),

          // ✅ CORREÇÃO ESTRUTURAL DE Z-ORDER:
          // Botão Flutuante Contextual posicionado FORA do Scaffold
          // para garantir que NUNCA seja coberto pelo Drawer.
          if (shouldRenderInternalUi)
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
    super.key,
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
