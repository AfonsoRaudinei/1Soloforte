import 'package:flutter/material.dart';

/// Bottom Sheet estilo iOS / Apple Maps
///
/// Características:
/// - Altura inicial: ~30-35% da tela
/// - Expandível até ~85% via drag
/// - Handle (barra superior cinza)
/// - Fundo branco com bordas arredondadas
/// - Sombra sutil
/// - Draggable para expandir/recolher
/// - Fecha ao arrastar para baixo
class IosMapBottomSheet extends StatefulWidget {
  final Widget child;
  final double initialHeightFactor;
  final double maxHeightFactor;
  final BorderRadius? borderRadius;

  const IosMapBottomSheet({
    super.key,
    required this.child,
    this.initialHeightFactor = 0.35,
    this.maxHeightFactor = 0.85,
    this.borderRadius,
  });

  @override
  State<IosMapBottomSheet> createState() => _IosMapBottomSheetState();

  /// Método estático para exibir o Bottom Sheet
  ///
  /// Exemplo de uso:
  /// ```dart
  /// IosMapBottomSheet.show(
  ///   context: context,
  ///   child: YourContentWidget(),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double initialHeightFactor = 0.35,
    double maxHeightFactor = 0.85,
    BorderRadius? borderRadius,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => IosMapBottomSheet(
        initialHeightFactor: initialHeightFactor,
        maxHeightFactor: maxHeightFactor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class _IosMapBottomSheetState extends State<IosMapBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _dragExtent = 0.0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent -= details.primaryDelta ?? 0.0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final currentHeight = _isExpanded
        ? screenHeight * widget.maxHeightFactor
        : screenHeight * widget.initialHeightFactor;

    final draggedHeight = currentHeight + _dragExtent;
    final midHeight =
        screenHeight *
        ((widget.initialHeightFactor + widget.maxHeightFactor) / 2);

    // Se arrastou para baixo mais que a altura inicial, fecha
    if (draggedHeight < screenHeight * widget.initialHeightFactor * 0.7) {
      Navigator.of(context).pop();
      return;
    }

    // Se arrastou além do meio, expande; senão, retrai
    setState(() {
      _isExpanded = draggedHeight > midHeight;
      _dragExtent = 0.0;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final initialHeight = screenHeight * widget.initialHeightFactor;
    final maxHeight = screenHeight * widget.maxHeightFactor;

    final currentHeight = _isExpanded
        ? maxHeight + _dragExtent
        : initialHeight + _dragExtent;

    final clampedHeight = currentHeight.clamp(initialHeight * 0.5, maxHeight);

    final defaultBorderRadius = BorderRadius.circular(28);
    final borderRadius = widget.borderRadius ?? defaultBorderRadius;

    return GestureDetector(
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: clampedHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            children: [
              // Handle (barra superior)
              _buildHandle(),

              // Conteúdo
              Expanded(child: SafeArea(top: false, child: widget.child)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 36,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

/// Widget de conteúdo genérico/placeholder para o Bottom Sheet
///
/// Este é apenas um exemplo de conteúdo reutilizável.
/// Substitua pelo conteúdo real conforme necessário.
class IosMapBottomSheetContent extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? description;
  final Widget? customContent;

  const IosMapBottomSheetContent({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (description != null) ...[
            Text(
              description!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (customContent != null) customContent!,

          // Espaço extra para conteúdo scrollável
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
