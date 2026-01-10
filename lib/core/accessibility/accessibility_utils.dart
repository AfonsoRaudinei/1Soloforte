import 'package:flutter/material.dart';

/// Utilities for improving accessibility in the app.
///
/// Use these helpers to add proper semantics for screen readers
/// and improve the overall accessibility of the application.

/// Extension to easily wrap widgets with accessibility semantics.
extension AccessibilityExtension on Widget {
  /// Wrap widget with button semantics.
  Widget semanticButton({
    required String label,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      child: this,
    );
  }

  /// Wrap widget with image semantics.
  Widget semanticImage({required String label, bool excludeSemantics = false}) {
    return Semantics(
      image: true,
      label: label,
      excludeSemantics: excludeSemantics,
      child: this,
    );
  }

  /// Wrap widget with link semantics.
  Widget semanticLink({required String label, String? hint}) {
    return Semantics(link: true, label: label, hint: hint, child: this);
  }

  /// Wrap widget with header semantics for screen reader navigation.
  Widget semanticHeader({required String label, bool isHeader = true}) {
    return Semantics(header: isHeader, label: label, child: this);
  }

  /// Exclude widget from semantics tree (for decorative elements).
  Widget excludeFromSemantics() {
    return ExcludeSemantics(child: this);
  }

  /// Merge semantics with children into single node.
  Widget mergeSemantics() {
    return MergeSemantics(child: this);
  }

  /// Add custom semantic label.
  Widget withSemanticLabel(String label) {
    return Semantics(label: label, child: this);
  }
}

/// Accessible icon button with proper semantics.
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? semanticHint;
  final double size;
  final Color? color;
  final EdgeInsets padding;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.semanticHint,
    this.size = 24,
    this.color,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      hint: semanticHint,
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        onPressed: onPressed,
        padding: padding,
      ),
    );
  }
}

/// Accessible image with proper semantics.
class AccessibleImage extends StatelessWidget {
  final ImageProvider image;
  final String semanticLabel;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isDecorative;

  const AccessibleImage({
    super.key,
    required this.image,
    required this.semanticLabel,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
    );

    if (isDecorative) {
      return ExcludeSemantics(child: imageWidget);
    }

    return Semantics(image: true, label: semanticLabel, child: imageWidget);
  }
}

/// Widget that announces changes to screen readers.
class LiveRegion extends StatelessWidget {
  final Widget child;
  final String? announcement;
  final bool assertive;

  const LiveRegion({
    super.key,
    required this.child,
    this.announcement,
    this.assertive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(liveRegion: true, label: announcement, child: child);
  }
}

/// Helper class for WCAG contrast ratio calculations.
class ContrastChecker {
  ContrastChecker._();

  /// Calculate contrast ratio between two colors.
  /// Returns a value between 1 and 21.
  static double contrastRatio(Color foreground, Color background) {
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast meets WCAG AA for normal text (>= 4.5:1).
  static bool meetsAANormal(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 4.5;
  }

  /// Check if contrast meets WCAG AA for large text (>= 3:1).
  static bool meetsAALarge(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 3.0;
  }

  /// Check if contrast meets WCAG AAA for normal text (>= 7:1).
  static bool meetsAAANormal(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 7.0;
  }

  /// Calculate relative luminance of a color.
  static double _relativeLuminance(Color color) {
    double r = _linearize(color.r / 255.0);
    double g = _linearize(color.g / 255.0);
    double b = _linearize(color.b / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    }
    return _pow((value + 0.055) / 1.055, 2.4);
  }

  /// Power function for linearize calculation.
  static double _pow(double base, double exponent) {
    // Using repeated multiplication for common cases
    if (exponent == 2.4) {
      // Approximation: base^2.4 ≈ base^2 * base^0.4
      return base *
          base *
          _sqrt(_sqrt(base)); // base^2 * base^(1/2 * 0.8) ≈ base^2.4
    }
    // Fallback for other cases
    double result = 1.0;
    for (int i = 0; i < exponent.toInt(); i++) {
      result *= base;
    }
    // Handle fractional part
    final fractional = exponent - exponent.toInt();
    if (fractional > 0) {
      result *= _sqrt(base); // Approximation for fractional
    }
    return result;
  }

  static double _sqrt(double value) {
    // Newton's method for square root
    if (value <= 0) return 0;
    double x = value;
    for (int i = 0; i < 10; i++) {
      x = (x + value / x) / 2;
    }
    return x;
  }
}

/// Semantic roles for custom widgets.
enum SemanticRole {
  button,
  link,
  header,
  image,
  slider,
  switchControl,
  textField,
  checkbox,
  radio,
}

/// Builder widget that adds appropriate semantics based on role.
class SemanticWrapper extends StatelessWidget {
  final Widget child;
  final SemanticRole role;
  final String label;
  final String? hint;
  final String? value;
  final bool enabled;

  const SemanticWrapper({
    super.key,
    required this.child,
    required this.role,
    required this.label,
    this.hint,
    this.value,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: role == SemanticRole.button,
      link: role == SemanticRole.link,
      header: role == SemanticRole.header,
      image: role == SemanticRole.image,
      slider: role == SemanticRole.slider,
      toggled: role == SemanticRole.switchControl,
      textField: role == SemanticRole.textField,
      checked: role == SemanticRole.checkbox,
      selected: role == SemanticRole.radio,
      enabled: enabled,
      label: label,
      hint: hint,
      value: value,
      child: child,
    );
  }
}
