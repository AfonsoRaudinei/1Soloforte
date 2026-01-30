import 'package:flutter/material.dart';

enum ReachLevel { local, regional, expanded }

ReachLevel reachLevelFromInvestmentLevel(String? level) {
  switch (level?.toLowerCase()) {
    case 'ouro':
    case 'premium':
      return ReachLevel.expanded;
    case 'prata':
    case 'medio':
      return ReachLevel.regional;
    default:
      return ReachLevel.local;
  }
}

class MarketingReachIcon extends StatelessWidget {
  final ReachLevel level;
  final double size;
  final Color color;

  const MarketingReachIcon({
    super.key,
    required this.level,
    this.size = 16,
    this.color = const Color(0xFF757575),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ReachIconPainter(level: level, color: color),
    );
  }
}

class _ReachIconPainter extends CustomPainter {
  final ReachLevel level;
  final Color color;

  const _ReachIconPainter({required this.level, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2;
    final style = _ReachIconStyle.forLevel(level);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.strokeWidth
      ..color = color.withValues(alpha: style.opacity);

    for (var i = 1; i <= style.waves; i++) {
      final radius = maxRadius * (i / style.waves);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReachIconPainter oldDelegate) {
    return oldDelegate.level != level || oldDelegate.color != color;
  }
}

class _ReachIconStyle {
  final int waves;
  final double strokeWidth;
  final double opacity;

  const _ReachIconStyle({
    required this.waves,
    required this.strokeWidth,
    required this.opacity,
  });

  static _ReachIconStyle forLevel(ReachLevel level) {
    switch (level) {
      case ReachLevel.expanded:
        return const _ReachIconStyle(waves: 3, strokeWidth: 1.4, opacity: 1.0);
      case ReachLevel.regional:
        return const _ReachIconStyle(waves: 2, strokeWidth: 1.2, opacity: 0.85);
      case ReachLevel.local:
        return const _ReachIconStyle(waves: 1, strokeWidth: 1.0, opacity: 0.6);
    }
  }
}
