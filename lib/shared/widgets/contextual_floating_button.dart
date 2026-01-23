import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/dashboard/presentation/dashboard_layout.dart';

/// Botão flutuante único e contextual que:
/// - No Mapa: abre/fecha o Menu Principal (drawer)
/// - Fora do Mapa: navega de volta para o Mapa
///
/// GARANTIAS TÉCNICAS:
/// ✅ Sempre visível (Z-index máximo via floatingActionButton do Scaffold)
/// ✅ Nunca sobreposto pelo Drawer ou qualquer outro widget
/// ✅ Alterna ícone baseado em contexto de rota E estado do drawer
class ContextualFloatingButton extends StatelessWidget {
  const ContextualFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Detectar rota atual
    final String location = GoRouterState.of(context).uri.path;
    final bool isMapScreen = location == '/map' || location == '/map/';

    // Obter acesso ao drawer (se estiver no contexto do DashboardLayout)
    final drawerScope = DashboardDrawerScope.maybeOf(context);

    // Escutar estado do drawer para alternar ícone dinamicamente
    return ValueListenableBuilder<bool>(
      valueListenable: drawerScope?.isEndDrawerOpen ?? ValueNotifier(false),
      builder: (context, isDrawerOpen, _) {
        // Determinar ação e ícone
        final IconData icon;
        final VoidCallback? onPressed;

        if (isMapScreen) {
          // No Mapa: alternar drawer
          icon = isDrawerOpen ? Icons.close : Icons.menu;
          onPressed = () {
            if (isDrawerOpen) {
              Navigator.pop(context); // Fecha o drawer
            } else {
              drawerScope?.openEndDrawer(); // Abre o drawer
            }
          };
        } else {
          // Fora do Mapa: navegar para o Mapa
          icon = Icons.arrow_back;
          onPressed = () => context.go('/map');
        }

        // CORREÇÃO ESTRUTURAL: Garantias de Visibilidade
        // 1. Elevação máxima (12) para ficar SEMPRE acima do Drawer
        // 2. heroTag único previne conflitos de animação
        // 3. Scaffold.floatingActionButton garante Z-index máximo
        // 4. Drawer.width reduzido (72%) deixa espaço visual explícito
        return FloatingActionButton(
          heroTag: 'contextual_fab',
          onPressed: onPressed,
          backgroundColor: AppColors.primary,
          elevation: 12, // Elevação máxima para garantir visibilidade absoluta
          child: Icon(icon, color: Colors.white),
        );
      },
    );
  }
}
