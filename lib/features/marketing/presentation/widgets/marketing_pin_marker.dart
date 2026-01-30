import 'package:flutter/material.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';

// Conditional import for dart:io (not available on Web)
import 'marketing_pin_marker_io.dart'
    if (dart.library.html) 'marketing_pin_marker_web.dart'
    as platform;

/// Configures the visual appearance of the marketing marker based on zoom level.
///
/// This class allows future zoom-based adjustments:
/// - At extreme zoom-out, [labelOpacity] can be reduced (0.0-1.0)
/// - [simplifiedMode] can enable compact display mode
class MarkerZoomConfig {
  /// Opacity of the entire card (0.0 to 1.0).
  final double cardOpacity;

  /// Whether to use simplified display mode.
  /// When true, shows only a minimal pin.
  final bool simplifiedMode;

  const MarkerZoomConfig({this.cardOpacity = 1.0, this.simplifiedMode = false});

  /// Default configuration for normal zoom levels.
  static const normal = MarkerZoomConfig();

  /// Configuration for zoomed-out view.
  static const zoomedOut = MarkerZoomConfig(
    cardOpacity: 0.85,
    simplifiedMode: false,
  );

  /// Configuration for extreme zoom-out.
  static const extremeZoomOut = MarkerZoomConfig(
    cardOpacity: 0.7,
    simplifiedMode: true,
  );
}

/// Unified RECTANGULAR card size configuration based on investment level.
///
/// Each level has distinct visual characteristics:
/// - Card size (width, height)
/// - Border width
/// - Border radius
class MarkerSizeConfig {
  /// Width of the entire card
  final double cardWidth;

  /// Height of the entire card
  final double cardHeight;

  /// Border radius for the card corners
  final double borderRadius;

  /// Border width
  final double borderWidth;

  const MarkerSizeConfig({
    required this.cardWidth,
    required this.cardHeight,
    required this.borderRadius,
    this.borderWidth = 0,
  });

  /// Gold level (alcance ampliado) - Largest card (+10-15%)
  static const gold = MarkerSizeConfig(
    cardWidth: 180.0,
    cardHeight: 102.0,
    borderRadius: 12.0,
    borderWidth: 3.0,
  );

  /// Silver level (alcance regional) - Standard card
  static const silver = MarkerSizeConfig(
    cardWidth: 160.0,
    cardHeight: 90.0,
    borderRadius: 10.0,
    borderWidth: 2.0,
  );

  /// Bronze level (alcance local) - Smallest card
  static const bronze = MarkerSizeConfig(
    cardWidth: 140.0,
    cardHeight: 80.0,
    borderRadius: 10.0,
    borderWidth: 1.0,
  );

  /// Get configuration for a given investment level.
  static MarkerSizeConfig forLevel(String level) {
    switch (level) {
      case 'ouro':
      case 'premium':
        return gold;
      case 'prata':
      case 'medio':
        return silver;
      default:
        return bronze;
    }
  }

  /// Calculate total marker height (horizontal layout).
  double get totalHeight => cardHeight;

  /// Calculate total marker width.
  double get totalWidth => cardWidth;
}

/// A unified marketing pin marker displayed as a SINGLE RECTANGULAR card.
///
/// ## Visual Contract
/// - Full-bleed image (no internal padding)
/// - Simple external border only
/// - Level-based size and border weight
/// - No labels or badges
class MarketingPinMarker extends StatelessWidget {
  /// The new standard data source.
  final MarketingPublication? publication;

  /// The legacy data source (kept for compatibility with Dashboard).
  final MarketingMapPost? legacyPost;

  /// Configuration for zoom-based visual adjustments.
  final MarkerZoomConfig zoomConfig;

  /// Optional callback when marker is tapped.
  final VoidCallback? onTap;

  /// Whether this marker is the currently selected publication.
  final bool isSelected;

  /// Canonical Constructor using MarketingPublication
  const MarketingPinMarker({
    super.key,
    required this.publication,
    this.legacyPost,
    this.zoomConfig = const MarkerZoomConfig(),
    this.onTap,
    this.isSelected = false,
  });

  /// Legacy Constructor (Dashboard Compatibility)
  /// DEPRECATED: Migrate Dashboard to use MarketingPublication
  // ignore: non_constant_identifier_names
  factory MarketingPinMarker.fromLegacy({
    required MarketingMapPost post,
    MarkerZoomConfig zoomConfig = const MarkerZoomConfig(),
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return MarketingPinMarker(
      publication: null,
      legacyPost: post,
      zoomConfig: zoomConfig,
      onTap: onTap,
      isSelected: isSelected,
    );
  }

  // --- Data Accessors ---

  String get _investmentLevel =>
      publication?.investmentLevel ?? legacyPost?.investmentLevel ?? 'prata';

  dynamic get _coverPhoto {
    if (publication != null) return publication!.coverPhoto;
    return legacyPost?.coverPhoto;
  }

  String get _coverPhotoPath {
    final photo = _coverPhoto;
    if (photo == null) return '';
    // Handle both MarketingPhoto (legacy) and PublicationPhoto (new)
    // Both have .path property
    return photo.path;
  }

  @override
  Widget build(BuildContext context) {
    final level = _normalizeInvestmentLevel(_investmentLevel);
    final config = MarkerSizeConfig.forLevel(level);

    // For simplified mode at extreme zoom-out, show minimal rectangular marker
    if (zoomConfig.simplifiedMode) {
      return GestureDetector(
        onTap: onTap,
        child: _buildSimplifiedMarker(level, config),
      );
    }

    final levelOpacity = _getLevelOpacity(level);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: isSelected ? 1.04 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: zoomConfig.cardOpacity * levelOpacity,
          child: _buildMarkerCard(level, config),
        ),
      ),
    );
  }

  /// Builds the unified RECTANGULAR marker card with image and text side by side.
  Widget _buildMarkerCard(String level, MarkerSizeConfig config) {
    final borderColor = _getBorderColor(level);
    return SizedBox(
      width: config.cardWidth,
      height: config.cardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(config.borderRadius),
          border: Border.all(color: borderColor, width: config.borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(config.borderRadius - 1),
          child: _buildCoverImage(
            config.cardWidth,
            config.cardHeight,
          ),
        ),
      ),
    );
  }

  /// Builds a simplified RECTANGULAR marker for extreme zoom-out.
  Widget _buildSimplifiedMarker(String level, MarkerSizeConfig config) {
    final borderColor = _getBorderColor(level);
    final smallWidth = config.cardWidth * 0.6;
    final smallHeight = config.cardHeight * 0.6;

    return SizedBox(
      width: smallWidth,
      height: smallHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: config.borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: _buildCoverImage(smallWidth, smallHeight),
        ),
      ),
    );
  }

  /// Builds the cover image widget with rectangular bounds.
  /// Uses platform-specific implementation to handle Web vs Mobile.
  Widget _buildCoverImage(double width, double height) {
    // Dynamic type: can be MarketingPhoto or PublicationPhoto
    final cover = _coverPhoto;

    if (cover == null) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFFF2F2F2),
      );
    }

    final path = _coverPhotoPath;

    // Network images (http/https)
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(width, height),
      );
    }

    // Blob or data URLs (common on Web from file picker)
    if (path.startsWith('blob:') || path.startsWith('data:')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(width, height),
      );
    }

    // Local file path - use platform-specific implementation
    // On Web, this will show fallback; on Mobile, uses Image.file
    return platform.buildLocalImage(
      path: path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: () => _buildImagePlaceholder(width, height),
    );
  }

  /// Builds image placeholder for errors.
  Widget _buildImagePlaceholder(double width, double height) {
    return Container(
      color: const Color(0xFFF2F2F2),
    );
  }

  /// Gets the accent/border color for a given level.
  Color _getBorderColor(String level) {
    switch (level) {
      case 'ouro':
        return const Color(0xFF5E646B); // Neutral dark gray
      case 'prata':
        return const Color(0xFF8E959B); // Neutral medium gray
      default:
        return const Color(0xFFBFC4C9); // Neutral light gray
    }
  }

  double _getLevelOpacity(String level) {
    switch (level) {
      case 'ouro':
        return 1.0;
      case 'prata':
        return 1.0;
      default:
        return 0.85;
    }
  }

  /// Normalizes investment level string to standard values.
  String _normalizeInvestmentLevel(String? raw) {
    switch (raw) {
      case 'premium':
      case 'ouro':
        return 'ouro';
      case 'medio':
      case 'prata':
        return 'prata';
      case 'basico':
      case 'bronze':
        return 'bronze';
      default:
        return 'prata';
    }
  }
}

/// Extension to easily get marker dimensions for flutter_map integration.
extension MarketingPinMarkerSize on MarketingMapPost {
  /// Calculate the marker size based on investment level.
  Size get markerSize {
    final level = _normalizeLevel(investmentLevel);
    final config = MarkerSizeConfig.forLevel(level);
    return Size(config.totalWidth, config.totalHeight);
  }

  String _normalizeLevel(String? raw) {
    switch (raw) {
      case 'premium':
      case 'ouro':
        return 'ouro';
      case 'medio':
      case 'prata':
        return 'prata';
      case 'basico':
      case 'bronze':
        return 'bronze';
      default:
        return 'prata';
    }
  }
}
