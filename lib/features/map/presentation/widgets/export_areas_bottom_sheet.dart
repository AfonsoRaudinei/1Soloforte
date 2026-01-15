import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/export_service.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:intl/intl.dart';

enum ExportFormat { geojson, kml }

class ExportAreasBottomSheet extends ConsumerStatefulWidget {
  final List<GeoArea> allAreas;
  final GeoArea? selectedArea;

  const ExportAreasBottomSheet({
    super.key,
    required this.allAreas,
    this.selectedArea,
  });

  @override
  ConsumerState<ExportAreasBottomSheet> createState() =>
      _ExportAreasBottomSheetState();
}

class _ExportAreasBottomSheetState
    extends ConsumerState<ExportAreasBottomSheet> {
  ExportFormat _format = ExportFormat.geojson;
  bool _onlySelected = false;
  final ExportService _exportService = ExportService();
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // If there is a selected area, default to it? Or maybe keep 'all' as default.
    // User requested "Todas as áreas (padrão)".
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      final areasToExport = (_onlySelected && widget.selectedArea != null)
          ? [widget.selectedArea!]
          : widget.allAreas;

      if (areasToExport.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhuma área para exportar.')),
          );
        }
        setState(() => _isExporting = false);
        return;
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String data = '';
      String ext = '';
      String mime = '';

      if (_format == ExportFormat.geojson) {
        data = _exportService.generateGeoJson(areasToExport);
        ext = 'geojson';
        mime = 'application/geo+json';
      } else {
        data = _exportService.generateKml(areasToExport);
        ext = 'kml';
        mime = 'application/vnd.google-earth.kml+xml';
      }

      final filename = 'soloforte_areas_$dateStr.$ext';

      await _exportService.exportAndShare(
        data: data,
        filename: filename,
        mimeType: mime,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exportação concluída: $filename')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao exportar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only enable "Selected" option if we actually have one
    final canSelectSpecific = widget.selectedArea != null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Exportar Áreas', style: AppTypography.h3),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Format Selection
          Text('Formato do Arquivo', style: AppTypography.subtitle1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFormatOption(
                  ExportFormat.geojson,
                  'GeoJSON',
                  'Padrão web/GIS',
                  Icons.code,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormatOption(
                  ExportFormat.kml,
                  'KML',
                  'Google Earth',
                  Icons.public,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Scope Selection
          if (canSelectSpecific) ...[
            Text('Escopo', style: AppTypography.subtitle1),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Exportar apenas área selecionada'),
              subtitle: Text(
                _onlySelected
                    ? 'Área: "${widget.selectedArea!.name}"'
                    : 'Todas as ${widget.allAreas.length} áreas salvas',
              ),
              value: _onlySelected,
              onChanged: (val) => setState(() => _onlySelected = val),
              activeThumbColor: AppColors.primary,
            ),
            const SizedBox(height: 24),
          ],

          if (!canSelectSpecific) ...[
            Text(
              'Serão exportadas todas as ${widget.allAreas.length} áreas salvas.',
              style: AppTypography.body2.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
          ],

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isExporting ? null : _handleExport,
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(
                _isExporting ? 'Exportando...' : 'Gerar e Compartilhar',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFormatOption(
    ExportFormat fmt,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _format == fmt;
    return GestureDetector(
      onTap: () => setState(() => _format = fmt),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
