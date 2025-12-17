import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

class InteractiveResultImage extends StatefulWidget {
  final String imagePath;
  final List<BoundingBox> detections;

  const InteractiveResultImage({
    super.key,
    required this.imagePath,
    required this.detections,
  });

  @override
  State<InteractiveResultImage> createState() => _InteractiveResultImageState();
}

class _InteractiveResultImageState extends State<InteractiveResultImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BoundingBox? _selectedBox;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Base Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(widget.imagePath),
                width: double.infinity,
                height: 300, // Fixed height or dynamic based on aspect ratio
                fit: BoxFit.cover,
              ),
            ),

            // Bounding Boxes Layer
            Positioned.fill(
              child: CustomPaint(
                painter: BoundingBoxPainter(
                  detections: widget.detections,
                  selectedBox: _selectedBox,
                  animationValue: _controller,
                ),
                child: GestureDetector(
                  onTapUp: (details) {
                    _handleTap(details, constraints.maxWidth, 300);
                  },
                ),
              ),
            ),

            // Selected Label Tooltip
            if (_selectedBox != null)
              Positioned(
                left: (_selectedBox!.x * constraints.maxWidth).clamp(
                  0,
                  constraints.maxWidth - 120,
                ),
                top: (_selectedBox!.y * 300) - 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${_selectedBox!.label} ${(_selectedBox!.confidence * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handleTap(TapUpDetails details, double width, double height) {
    final tapX = details.localPosition.dx / width;
    final tapY = details.localPosition.dy / height;

    BoundingBox? tapped;
    // Find if tap is inside any box
    for (var box in widget.detections) {
      if (tapX >= box.x &&
          tapX <= box.x + box.width &&
          tapY >= box.y &&
          tapY <= box.y + box.height) {
        tapped = box;
        break; // Select the first one found (top-most conceptually)
      }
    }

    setState(() {
      _selectedBox = tapped;
    });
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<BoundingBox> detections;
  final BoundingBox? selectedBox;
  final Animation<double> animationValue;

  BoundingBoxPainter({
    required this.detections,
    this.selectedBox,
    required this.animationValue,
  }) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var box in detections) {
      final rect = Rect.fromLTWH(
        box.x * size.width,
        box.y * size.height,
        box.width * size.width,
        box.height * size.height,
      );

      bool isSelected = selectedBox == box;

      // Color logic
      paint.color = isSelected
          ? AppColors.primary
          : Colors.white.withValues(alpha: 0.7);

      // If selected, pulse opacity or width
      if (isSelected) {
        paint.strokeWidth = 3 + (animationValue.value * 1.5);
        paint.color = AppColors.primary.withOpacity(
          0.8 + (animationValue.value * 0.2),
        );
      }

      // Draw dashed corners or full rect? Let's do rounded rect
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
      canvas.drawRRect(rrect, paint);

      // Draw semi-transparent fill for selected
      if (isSelected) {
        final fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = AppColors.primary.withValues(alpha: 0.2);
        canvas.drawRRect(rrect, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) => true;
}
