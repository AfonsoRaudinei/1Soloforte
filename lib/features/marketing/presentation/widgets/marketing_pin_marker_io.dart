// Platform-specific implementation for mobile (IO) platforms
import 'dart:io';
import 'package:flutter/material.dart';

/// Builds an image widget from a local file path.
/// This implementation uses dart:io File which is available on mobile.
Widget buildLocalImage({
  required String path,
  required double width,
  required double height,
  required BoxFit fit,
  required Widget Function() errorBuilder,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, __, ___) => errorBuilder(),
  );
}
