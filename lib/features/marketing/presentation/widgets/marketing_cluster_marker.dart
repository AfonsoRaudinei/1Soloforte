import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/marketing/services/pin_visibility_service.dart';

/// Widget para exibir um cluster de pins de Marketing no mapa.
///
/// Mostra um ícone circular com o número de pins agrupados.
/// Ao clicar, pode expandir para mostrar detalhes ou dar zoom.
class MarketingClusterMarker extends StatelessWidget {
  /// O cluster de pins a ser exibido
  final PinCluster cluster;

  /// Callback ao clicar no cluster
  final VoidCallback? onTap;

  /// Nível de zoom atual (afeta tamanho do cluster)
  final double zoom;

  const MarketingClusterMarker({
    super.key,
    required this.cluster,
    this.onTap,
    this.zoom = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final count = cluster.pins.length;
    final size = _calculateSize(count);
    final color = _calculateColor(count);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _calculateFontSize(count),
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              Text(
                'cases',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcula o tamanho do cluster baseado na quantidade de pins
  double _calculateSize(int count) {
    if (count <= 3) return 50;
    if (count <= 5) return 56;
    if (count <= 10) return 64;
    if (count <= 20) return 72;
    return 80;
  }

  /// Calcula o tamanho da fonte baseado na quantidade
  double _calculateFontSize(int count) {
    if (count <= 9) return 18;
    if (count <= 99) return 16;
    return 14;
  }

  /// Calcula a cor do cluster baseado na quantidade de pins
  Color _calculateColor(int count) {
    if (count <= 3) {
      return AppColors.primary; // Verde padrão para poucos
    }
    if (count <= 10) {
      return const Color(0xFF3B82F6); // Azul para médio
    }
    if (count <= 20) {
      return const Color(0xFFF59E0B); // Laranja para muitos
    }
    return const Color(0xFFEF4444); // Vermelho para muitos muitos
  }
}

/// Widget simplificado para marker de Marketing em zoom médio
class SimplifiedMarketingMarker extends StatelessWidget {
  /// Callback ao clicar
  final VoidCallback? onTap;

  /// Cor do marker (baseada no nível de investimento)
  final Color color;

  /// Label curto (ex: "Case")
  final String label;

  /// Marker selecionado
  final bool isSelected;

  const SimplifiedMarketingMarker({
    super.key,
    this.onTap,
    this.color = AppColors.primary,
    this.label = 'Case',
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: isSelected ? 1.04 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: isSelected ? 3 : 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.2 : 0.15),
                blurRadius: isSelected ? 8 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.campaign, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget de ponto mínimo para zoom extremo
class MinimalMarketingMarker extends StatelessWidget {
  /// Callback ao clicar
  final VoidCallback? onTap;

  /// Cor do ponto
  final Color color;

  const MinimalMarketingMarker({
    super.key,
    this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
