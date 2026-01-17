import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';

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
/// Each level (Bronze, Prata, Ouro) has distinct visual characteristics:
/// - Card size (width, height)
/// - Image size (rectangular, NOT circular)
/// - Font sizes
/// - Shadow intensity
class MarkerSizeConfig {
  /// Size of the rectangular image area (square, but with rounded corners)
  final double imageSize;

  /// Width of the entire card
  final double cardWidth;

  /// Padding inside the card
  final double cardPadding;

  /// Font size for the main text (e.g., "65 sc/ha")
  final double titleFontSize;

  /// Font size for the secondary text (e.g., "Produto: X")
  final double subtitleFontSize;

  /// Border radius for the card corners
  final double borderRadius;

  /// Border radius for the image corners
  final double imageBorderRadius;

  /// Border width (for gold level)
  final double borderWidth;

  const MarkerSizeConfig({
    required this.imageSize,
    required this.cardWidth,
    required this.cardPadding,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.borderRadius,
    required this.imageBorderRadius,
    this.borderWidth = 0,
  });

  /// Gold level - Largest card with premium appearance (~92-100px height)
  static const gold = MarkerSizeConfig(
    imageSize: 72.0,
    cardWidth: 220.0,
    cardPadding: 12.0,
    titleFontSize: 15.0,
    subtitleFontSize: 12.0,
    borderRadius: 14.0,
    imageBorderRadius: 10.0,
    borderWidth: 3.5,
  );

  /// Silver level - Medium card (~72-76px height)
  static const silver = MarkerSizeConfig(
    imageSize: 52.0,
    cardWidth: 180.0,
    cardPadding: 10.0,
    titleFontSize: 13.0,
    subtitleFontSize: 10.0,
    borderRadius: 12.0,
    imageBorderRadius: 8.0,
    borderWidth: 2.5,
  );

  /// Bronze level - Smallest card (~56-60px height)
  static const bronze = MarkerSizeConfig(
    imageSize: 40.0,
    cardWidth: 150.0,
    cardPadding: 8.0,
    titleFontSize: 11.0,
    subtitleFontSize: 9.0,
    borderRadius: 10.0,
    imageBorderRadius: 6.0,
    borderWidth: 2.0,
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
  /// Height is: imageSize + 2 * cardPadding + extra space for badge
  /// This ensures text + badge fits within the row
  double get totalHeight {
    // Image size + padding + extra 8px for badge area
    return imageSize + cardPadding * 2 + 10;
  }

  /// Calculate total marker width.
  double get totalWidth => cardWidth;
}

/// A unified marketing pin marker displayed as a SINGLE RECTANGULAR card.
///
/// ## Design Architecture (HORIZONTAL Marker Card)
///
/// ```
/// ┌─────────────────────────────────────────────┐
/// │ ┌─────────┐  │  80 sc/ha                   │
/// │ │  LOGO/  │  │  Produto: Coach             │ ← Card container (single shadow)
/// │ │  FOTO   │  │  [Ouro] badge               │
/// │ └─────────┘  │                              │
/// └─────────────────────────────────────────────┘
/// ```
///
/// ## Visual Hierarchy
/// - Bronze: Smaller card, lighter shadow, subtle appearance
/// - Prata: Medium card, medium shadow
/// - Ouro: Larger card, stronger shadow, gold border accent
///
/// ## Key Features
/// - SINGLE RECTANGULAR card container
/// - Image with ROUNDED CORNERS (NOT circular)
/// - Image and text side by side (horizontal layout)
/// - Single unified shadow for entire card
/// - No overflow issues
/// - NO CircleAvatar, NO BoxShape.circle, NO ClipOval
class MarketingPinMarker extends StatelessWidget {
  /// The marketing post data to display.
  final MarketingMapPost post;

  /// Configuration for zoom-based visual adjustments.
  final MarkerZoomConfig zoomConfig;

  /// Optional callback when marker is tapped.
  final VoidCallback? onTap;

  const MarketingPinMarker({
    super.key,
    required this.post,
    this.zoomConfig = const MarkerZoomConfig(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final level = _normalizeInvestmentLevel(post.investmentLevel);
    final config = MarkerSizeConfig.forLevel(level);

    // For simplified mode at extreme zoom-out, show minimal rectangular marker
    if (zoomConfig.simplifiedMode) {
      return GestureDetector(
        onTap: onTap,
        child: _buildSimplifiedMarker(level, config),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: zoomConfig.cardOpacity,
        child: _buildMarkerCard(level, config),
      ),
    );
  }

  /// Builds the unified RECTANGULAR marker card with image and text side by side.
  Widget _buildMarkerCard(String level, MarkerSizeConfig config) {
    final borderColor = _getBorderColor(level);
    final shadow = _getCardShadow(level);

    // Content data with safe defaults
    final productivity = (post.productivity ?? '').trim();
    final product = (post.product ?? '').trim();
    final line1 = productivity.isEmpty ? 'Resultado' : productivity;
    final line2 = product.isEmpty ? '' : product;

    return Container(
      width: config.cardWidth,
      constraints: BoxConstraints(
        minHeight: config.imageSize + config.cardPadding * 2,
      ),
      padding: EdgeInsets.all(config.cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC), // Off-white background
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(color: borderColor, width: config.borderWidth),
        boxShadow: shadow, // Single unified shadow
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ══════════════════════════════════════════
          // LEFT SECTION: Rectangular Image with rounded corners
          // ══════════════════════════════════════════
          Container(
            width: config.imageSize,
            height: config.imageSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(config.imageBorderRadius),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(config.imageBorderRadius - 1),
              child: _buildCoverImage(config.imageSize),
            ),
          ),

          SizedBox(width: config.cardPadding),

          // ══════════════════════════════════════════
          // RIGHT SECTION: Text Content + Badge (compact layout)
          // ══════════════════════════════════════════
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line 1: Productivity (bold) - always shown
                Text(
                  line1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: config.titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D1D1F),
                    height: 1.1,
                  ),
                ),
                // Line 2: Product - only show if not empty
                if (line2.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    line2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: config.subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      height: 1.1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a simplified RECTANGULAR marker for extreme zoom-out.
  Widget _buildSimplifiedMarker(String level, MarkerSizeConfig config) {
    final borderColor = _getBorderColor(level);
    final smallSize = config.imageSize * 0.6;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign, color: borderColor, size: smallSize * 0.5),
          const SizedBox(width: 4),
          Text(
            'Case',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: borderColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the cover image widget with rectangular bounds.
  /// Uses platform-specific implementation to handle Web vs Mobile.
  Widget _buildCoverImage(double size) {
    final cover = post.coverPhoto;

    if (cover == null) {
      return Container(
        width: size,
        height: size,
        color: const Color(0xFFF5F5F5),
        child: Icon(
          Icons.campaign,
          color: AppColors.primary.withValues(alpha: 0.6),
          size: size * 0.5,
        ),
      );
    }

    final path = cover.path;

    // Network images (http/https)
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(size),
      );
    }

    // Blob or data URLs (common on Web from file picker)
    if (path.startsWith('blob:') || path.startsWith('data:')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(size),
      );
    }

    // Local file path - use platform-specific implementation
    // On Web, this will show fallback; on Mobile, uses Image.file
    return platform.buildLocalImage(
      path: path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: () => _buildImagePlaceholder(size),
    );
  }

  /// Builds image placeholder for errors.
  Widget _buildImagePlaceholder(double size) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.withValues(alpha: 0.5),
        size: size * 0.4,
      ),
    );
  }

  /// Gets the accent/border color for a given level.
  Color _getBorderColor(String level) {
    return level == 'ouro'
        ? const Color(0xFFD4AF37) // Gold
        : level == 'prata'
        ? const Color(0xFFB0B0B0) // Silver
        : const Color(0xFFCD7F32); // Bronze
  }

  /// Gets the unified card shadow for a given level.
  /// Single shadow for the entire card.
  List<BoxShadow> _getCardShadow(String level) {
    switch (level) {
      case 'ouro':
        // Premium gold shadow - stronger and with golden tint
        return [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case 'prata':
        // Medium shadow
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ];
      default:
        // Bronze - subtle shadow
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ];
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
