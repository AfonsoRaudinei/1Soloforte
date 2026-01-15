import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/ndvi/application/ndvi_controller.dart';

// Placeholder for sub-widgets to keep file clean
import 'package:soloforte_app/features/dashboard/presentation/widgets/ndvi_tabs/ndvi_main_tab.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/ndvi_tabs/biomass_tab.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/ndvi_tabs/comparison_tab.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/ndvi_tabs/evolution_tab.dart';

class NdviSidePanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const NdviSidePanel({super.key, required this.onClose});

  @override
  ConsumerState<NdviSidePanel> createState() => _NdviSidePanelState();
}

class _NdviSidePanelState extends ConsumerState<NdviSidePanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ndviState = ref.watch(ndviControllerProvider);

    return Container(
      width: 350,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NDVI Viewer',
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Area Warning (Checklist Task 2)
          if (ndviState.currentArea == null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 48,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma área selecionada.',
                        style: AppTypography.h4.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecione uma área no mapa para visualizar os dados de NDVI.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'NDVI'),
                Tab(text: 'Biomassa'),
                Tab(text: 'Comparação'),
                Tab(text: 'Evolução'),
              ],
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent swipe which might move map
                children: [
                  NdviMainTab(),
                  BiomassTab(),
                  ComparisonTab(),
                  EvolutionTab(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
