import 'package:flutter/material.dart';

/// Responsive breakpoints for the application.
///
/// Use these constants and utilities to build responsive layouts
/// that adapt to different screen sizes (mobile, tablet, desktop).
class AppBreakpoints {
  AppBreakpoints._();

  /// Mobile: max 600px
  static const double mobileMax = 600;

  /// Tablet: 601px - 1024px
  static const double tabletMin = 601;
  static const double tabletMax = 1024;

  /// Desktop: 1025px+
  static const double desktopMin = 1025;

  /// Common breakpoint values
  static const double smallPhone = 320;
  static const double phone = 375;
  static const double largePhone = 414;
  static const double smallTablet = 768;
  static const double tablet = 834;
  static const double largeTablet = 1024;
  static const double desktop = 1280;
  static const double largeDesktop = 1920;
}

/// Extension for easy responsive checks on BuildContext.
extension ResponsiveExtension on BuildContext {
  /// Get the current screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get the current screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Check if the current device is a mobile phone.
  bool get isMobile => screenWidth <= AppBreakpoints.mobileMax;

  /// Check if the current device is a tablet.
  bool get isTablet =>
      screenWidth > AppBreakpoints.mobileMax &&
      screenWidth <= AppBreakpoints.tabletMax;

  /// Check if the current device is a desktop.
  bool get isDesktop => screenWidth > AppBreakpoints.tabletMax;

  /// Check if running on a large screen (tablet or desktop).
  bool get isLargeScreen => screenWidth > AppBreakpoints.mobileMax;

  /// Get the current device type.
  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Get responsive value based on device type.
  ///
  /// Example:
  /// ```dart
  /// final padding = context.responsive(
  ///   mobile: 16.0,
  ///   tablet: 24.0,
  ///   desktop: 32.0,
  /// );
  /// ```
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive grid column count.
  int get gridColumns => responsive(mobile: 1, tablet: 2, desktop: 3);

  /// Get responsive horizontal padding.
  double get horizontalPadding =>
      responsive(mobile: 16, tablet: 24, desktop: 32);

  /// Get responsive card width for grids.
  double get cardWidth =>
      responsive(mobile: screenWidth - 32, tablet: 300, desktop: 350);
}

/// Device type enum.
enum DeviceType { mobile, tablet, desktop }

/// Responsive builder widget.
///
/// Use this widget to build different layouts for different screen sizes.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppBreakpoints.tabletMax &&
            desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth > AppBreakpoints.mobileMax && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}

/// Responsive row widget that changes between Row and Column based on screen size.
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, isVertical: true),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addSpacing(children, isVertical: false),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, {required bool isVertical}) {
    if (widgets.isEmpty) return widgets;

    final spacedWidgets = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i < widgets.length - 1) {
        spacedWidgets.add(
          isVertical ? SizedBox(height: spacing) : SizedBox(width: spacing),
        );
      }
    }
    return spacedWidgets;
  }
}

/// Responsive padding widget.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive(
      mobile: mobile ?? const EdgeInsets.all(16),
      tablet: tablet ?? mobile ?? const EdgeInsets.all(24),
      desktop: desktop ?? tablet ?? mobile ?? const EdgeInsets.all(32),
    );

    return Padding(padding: padding, child: child);
  }
}

/// Responsive container that limits maximum width on large screens.
class ResponsiveMaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveMaxWidth({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}
