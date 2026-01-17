import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/map/application/drawing_controller.dart';
import 'package:soloforte_app/features/map/presentation/widgets/premium_glass_container.dart';
import 'package:soloforte_app/features/ndvi/presentation/ndvi_comparison_screen.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';

class SavedAreasListSheet extends ConsumerStatefulWidget {
  final Function(GeoArea) onAreaSelected;

  const SavedAreasListSheet({super.key, required this.onAreaSelected});

  @override
  ConsumerState<SavedAreasListSheet> createState() =>
      _SavedAreasListSheetState();
}

class _SavedAreasListSheetState extends ConsumerState<SavedAreasListSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelectionMode = false;
  final Set<String> _selectedAreaIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedAreaIds.clear();
    });
  }

  void _onAreaTap(GeoArea area) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedAreaIds.contains(area.id)) {
          _selectedAreaIds.remove(area.id);
        } else {
          _selectedAreaIds.add(area.id);
        }
      });
    } else {
      widget.onAreaSelected(area);
    }
  }

  void _compareSelected() {
    final selectedAreas = ref
        .read(drawingControllerProvider)
        .savedAreas
        .where((a) => _selectedAreaIds.contains(a.id))
        .toList();
    if (selectedAreas.isEmpty) return;
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NDVIComparisonScreen(areas: selectedAreas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawingState = ref.watch(drawingControllerProvider);
    final areas = drawingState.savedAreas;

    final filteredAreas = areas.where((area) {
      return area.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return PremiumGlassContainer(
      height: MediaQuery.of(context).size.height * 0.6,
      borderRadius: 24,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Áreas Salvas (${areas.length})', style: AppTypography.h3),
                // Compare Action
                if (_isSelectionMode) ...[
                  TextButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _compareSelected();
                    },
                    child: Text('Comparar (${_selectedAreaIds.length})'),
                  ),
                ],
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _toggleSelectionMode();
                  },
                  icon: Icon(
                    _isSelectionMode ? Icons.close : Icons.compare_arrows,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar área...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: filteredAreas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma área encontrada',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAreas.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final area = filteredAreas[index];

                      return _AreaListItem(
                        area: area,
                        isSelected:
                            _isSelectionMode &&
                            _selectedAreaIds.contains(area.id),
                        isSelectionMode: _isSelectionMode,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _onAreaTap(area);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AreaListItem extends StatelessWidget {
  final GeoArea area;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isSelectionMode;

  const _AreaListItem({
    required this.area,
    required this.onTap,
    this.isSelected = false,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = area.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(area.createdAt!)
        : '-';

    IconData icon;
    if (area.type == 'circle') {
      icon = Icons.circle_outlined;
    } else if (area.type == 'rectangle')
      icon = Icons.crop_square;
    else
      icon = Icons.polyline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: isSelectionMode
                  ? Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 20,
                    )
                  : Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${area.areaHectares.toStringAsFixed(2)} ha',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: AppTypography.caption),
                      const SizedBox(width: 8),
                      Text(
                        dateStr,
                        style: AppTypography.caption.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
