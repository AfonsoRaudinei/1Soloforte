import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import 'package:soloforte_app/core/theme/app_typography.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // Center of Brazil roughly
  static const _initialCenter = LatLng(-14.2350, -51.9253);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fullscreen Map with NatGeo Style
          FlutterMap(
            options: const MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 4.0,
            ),
            children: [
              TileLayer(
                // Esri National Geographic World Map
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.soloforte.app',
                maxZoom:
                    16, // NatGeo tiles often have a slightly lower max zoom availability
              ),
            ],
          ),

          // 2. Gradient Overlay for readability at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Layout: Logo + Text
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: GestureDetector(
              onTap: () => context.go('/login'),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 24),

                  // Text Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Acessar Soloforte',
                          style: AppTypography.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestão Agrícola Inteligente',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron icon effectively acting as a "Do it" indicator
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
