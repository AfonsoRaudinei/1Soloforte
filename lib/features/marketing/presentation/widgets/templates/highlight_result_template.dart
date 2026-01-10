import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class HighlightResultTemplate extends StatelessWidget {
  const HighlightResultTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            // Background Pattern or Image
            Positioned(
              right: -50,
              top: -50,
              child: Icon(
                Icons.show_chart,
                size: 300,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRODUTIVIDADE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '+25%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(width: 60, height: 5, color: AppColors.secondary),
                  const SizedBox(height: 20),
                  const Text(
                    'Aumento registrado na Safra 2024/25 comparado ao ano anterior.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                children: [
                  Icon(Icons.agriculture, color: Colors.white.withValues(alpha: 0.8)),
                  const SizedBox(width: 8),
                  const Text(
                    'SoloForte',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
