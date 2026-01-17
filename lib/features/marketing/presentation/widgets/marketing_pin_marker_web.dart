// Platform-specific implementation for Web
// dart:io is NOT available on web, so we use a network-based fallback
import 'package:flutter/material.dart';

/// Builds an image widget from a local file path.
/// On Web, local file paths are not directly usable.
/// We attempt to load as network image or show fallback.
Widget buildLocalImage({
  required String path,
  required double width,
  required double height,
  required BoxFit fit,
  required Widget Function() errorBuilder,
}) {
  // On web, file paths might be blob URLs or data URLs from file picker
  // Try to handle them as network images
  if (path.startsWith('blob:') || path.startsWith('data:')) {
    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => errorBuilder(),
    );
  }

  // If it's a regular path, we can't use File on web
  // Return the fallback placeholder
  return errorBuilder();
}
