import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final String? message;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.message,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
  }

  // NOTE: Flutter doesn't have a direct "componentDidCatch" equivalent for widgets in the same tree nicely
  // without using ErrorWidget.builder or custom zones.
  // However, for a simple hardening, we can rely on standard ErrorWidget builder usage globally
  // or use a builder that catches synchronous errors.
  //
  // Since we can't easily wrap "build" in try-catch for the framework calls,
  // we will assume usage of this widget is for "logical" error states provided by AsyncValue,
  // OR we rely on the fact that if child fails to build, we might show something else?
  //
  // Actually, Flutter *does* catch build errors and renders ErrorWidget.
  // The best way to harden is to configure the global ErrorWidget.builder in main.dart.
  // BUT, we can also provide a "SafeBuilder" pattern.

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultFallback();
    }

    // We can't catch build errors here easily *from the child*.
    // But we can offer a standard Error UI component to be used manually.
    return widget.child;
  }

  Widget _buildDefaultFallback() {
    return Center(
      child: EmptyStateWidget(
        title: 'Ops! Algo deu errado',
        message: widget.message ?? 'Não foi possível carregar este conteúdo.',
        icon: Icons.error_outline,
        actionLabel: 'Tentar novamente',
        onAction: () => setState(() => _hasError = false),
      ),
    );
  }
}

/// A widget that safely builds its child, catching errors during the builder execution.
class SafeBuilder extends StatelessWidget {
  final WidgetBuilder builder;
  final Widget? fallback;

  const SafeBuilder({super.key, required this.builder, this.fallback});

  @override
  Widget build(BuildContext context) {
    try {
      return builder(context);
    } catch (e) {
      return fallback ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.error_outline, color: AppColors.textSecondary),
            ),
          );
    }
  }
}
