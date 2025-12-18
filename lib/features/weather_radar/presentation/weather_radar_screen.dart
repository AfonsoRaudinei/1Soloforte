import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class WeatherRadarScreen extends StatelessWidget {
  const WeatherRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Radar de Chuva'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {}, // Action for Play
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Box
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Container(color: Colors.grey.shade200), // Map placeholder
                  Center(
                    child: Text('[MAPA COM OVERLAY]', style: AppTypography.h4),
                  ),
                  // Mock Overlay Colors Legend on top? No, mockup says Legend is below.
                  // Mock User Location
                  const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timeline
            Text('Timeline:', style: AppTypography.h4),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('[-2h]'),
                Text('[-1h]'),
                Text('[Agora]', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('[+1h]'),
                Text('[+2h]'),
              ],
            ),
            Slider(
              value: 0.5,
              onChanged: (v) {},
              activeColor: AppColors.primary,
            ),

            const SizedBox(height: 16),

            // Legend
            Text('Legenda:', style: AppTypography.h4),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(Colors.blueAccent, '0-2mm'),
                _buildLegendItem(Colors.green, '2-5mm'),
                _buildLegendItem(Colors.orange, '5-10mm'),
                _buildLegendItem(Colors.red, '>10mm'),
              ],
            ),

            const SizedBox(height: 24),

            // Radius
            Row(
              children: [
                Text('Raio:', style: AppTypography.h4),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: '25km',
                    items: ['25km', '50km', '100km']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Text('Animar Previsão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Column(
      children: [
        Container(width: 30, height: 10, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
