import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

class PestLibraryScreen extends StatefulWidget {
  const PestLibraryScreen({super.key});

  @override
  State<PestLibraryScreen> createState() => _PestLibraryScreenState();
}

class _PestLibraryScreenState extends State<PestLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Knowledge Base
  final List<ScanResult> _allPests = [
    ScanResult(
      id: 'L001',
      imagePath: 'assets/images/library/spodoptera.jpg',
      scientificName: 'Spodoptera frugiperda',
      commonName: 'Lagarta-do-cartucho',
      confidence: 1.0,
      severity: 0,
      description:
          'Principal praga do milho no Brasil, ataca desde a emergência.',
      symptoms: ['Cartucho destruído', 'Folhas raspadas'],
      scanDate: DateTime.now(),
      type: ScanType.pest,
      detections: [],
      recommendation: '',
    ),
    ScanResult(
      id: 'L002',
      imagePath: 'assets/images/library/ferrugem.jpg',
      scientificName: 'Phakopsora pachyrhizi',
      commonName: 'Ferrugem Asiática',
      confidence: 1.0,
      severity: 0,
      description: 'Doença fúngica severa na cultura da soja.',
      symptoms: ['Pústulas', 'Desfolha precoce'],
      scanDate: DateTime.now(),
      type: ScanType.disease,
      detections: [],
      recommendation: '',
    ),
    ScanResult(
      id: 'L003',
      imagePath: 'assets/images/library/mold.jpg',
      scientificName: 'Sclerotinia sclerotiorum',
      commonName: 'Mofo Branco',
      confidence: 1.0,
      severity: 0,
      description: 'Fungo polífago que causa podridão úmida.',
      symptoms: ['Micélio branco', 'Escleródios pretos'],
      scanDate: DateTime.now(),
      type: ScanType.disease,
      detections: [],
      recommendation: '',
    ),
    ScanResult(
      id: 'L004',
      imagePath: 'assets/images/library/percevejo.jpg',
      scientificName: 'Euschistus heros',
      commonName: 'Percevejo Marrom',
      confidence: 1.0,
      severity: 0,
      description: 'Praga sugadora importante na soja.',
      symptoms: ['Retenção foliar', 'Grãos deformados'],
      scanDate: DateTime.now(),
      type: ScanType.pest,
      detections: [],
      recommendation: '',
    ),
  ];

  late List<ScanResult> _filteredPests;

  @override
  void initState() {
    super.initState();
    _filteredPests = _allPests;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPests = _allPests.where((p) {
        return p.commonName.toLowerCase().contains(query) ||
            p.scientificName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Biblioteca de Pragas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar praga, doença ou sintoma...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filters (Mock Tabs)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(label: 'Todos', isSelected: true),
                const SizedBox(width: 8),
                _FilterChip(label: 'Pragas', isSelected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Doenças', isSelected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Deficiências', isSelected: false),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredPests.length,
              itemBuilder: (context, index) {
                final pest = _filteredPests[index];
                return _PestCard(pest: pest);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _PestCard extends StatelessWidget {
  final ScanResult pest;

  const _PestCard({required this.pest});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Open detail (mocked via generic Result Screen or dedicated Detail Screen)
          // Here simply showing the scan result view as a library detail
          context.push(
            '/dashboard/scanner/results',
            extra: {'imagePath': pest.imagePath, 'result': pest},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: Colors.grey[200],
                  // Mock Image
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pest.commonName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pest.scientificName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pest.type.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
