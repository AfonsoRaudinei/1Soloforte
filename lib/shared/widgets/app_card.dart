import 'package:flutter/material.dart';
import 'package:soloforte_app/shared/widgets/touch_scale_wrapper.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Premium iOS-style decoration
    final decoration = BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(20), // More rounded corners
      border: Border.all(
        color: AppColors.border.withValues(alpha: 0.5), // Softer border
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.03,
          ), // Very subtle ambient shadow
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02), // Sharper key shadow
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );

    Widget content = Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: decoration,
      child: Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      return TouchScaleWrapper(
        onTap: onTap,
        pressedScale: 0.98,
        child: content,
      );
    }

    return content;
  }
}
