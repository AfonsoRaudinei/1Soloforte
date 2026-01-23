import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  // Mock State
  bool _johnDeereConnected = false;
  bool _fieldViewConnected = true;
  bool _solinftecConnected = false;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Column(
        children: [
          Text(
            'Conecte suas ferramentas favoritas',
            style: AppTypography.bodyMedium.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _IntegrationCard(
            name: 'John Deere Operations Center',
            iconValues: const [Colors.green, Icons.agriculture],
            isConnected: _johnDeereConnected,
            onToggle: (v) => setState(() => _johnDeereConnected = v),
          ),
          const SizedBox(height: 16),
          _IntegrationCard(
            name: 'Climate FieldView',
            iconValues: const [Colors.red, Icons.cloud_circle],
            isConnected: _fieldViewConnected,
            onToggle: (v) => setState(() => _fieldViewConnected = v),
          ),
          const SizedBox(height: 16),
          _IntegrationCard(
            name: 'Solinftec',
            iconValues: const [Colors.blue, Icons.settings_input_antenna],
            isConnected: _solinftecConnected,
            onToggle: (v) => setState(() => _solinftecConnected = v),
          ),
        ],
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Wrapper({super.key, required this.child, required this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class _IntegrationCard extends StatelessWidget {
  final String name;
  final List<dynamic> iconValues; // [Color, IconData]
  final bool isConnected;
  final ValueChanged<bool> onToggle;

  const _IntegrationCard({
    required this.name,
    required this.iconValues,
    required this.isConnected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (iconValues[0] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                iconValues[1] as IconData,
                color: iconValues[0] as Color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.h4),
                  Text(
                    isConnected ? 'Conectado' : 'Desconectado',
                    style: TextStyle(
                      color: isConnected ? AppColors.success : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isConnected,
              onChanged: onToggle,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
