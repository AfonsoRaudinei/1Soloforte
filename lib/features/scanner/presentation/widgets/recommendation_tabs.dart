import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

class RecommendationTabs extends StatefulWidget {
  final ScanResult result;

  const RecommendationTabs({super.key, required this.result});

  @override
  State<RecommendationTabs> createState() => _RecommendationTabsState();
}

class _RecommendationTabsState extends State<RecommendationTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(22.5),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22.5),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "Controle Químico"),
              Tab(text: "Biológico / Cultural"),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300, // Fixed height for content
          child: TabBarView(
            controller: _tabController,
            children: [
              // 1. Quimico
              _buildChemicalTab(),
              // 2. Biologico
              _buildBioTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChemicalTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductRecommendationCard(
            name: "Belt (Flubendiamida)",
            dose: "100-150 ml/ha",
            group: "Diamidas (Grupo 28)",
            isEfficient: true,
          ),
          const SizedBox(height: 12),
          ProductRecommendationCard(
            name: "Premio (Clorantraniliprole)",
            dose: "100 ml/ha",
            group: "Diamidas (Grupo 28)",
            isEfficient: true,
          ),
          const SizedBox(height: 12),
          ProductRecommendationCard(
            name: "Methomyl 215 SL",
            dose: "1.5 L/ha",
            group: "Carbamato (Grupo 1A)",
            description: "Alternativa para rotação. Usar com cautela.",
          ),
        ],
      ),
    );
  }

  Widget _buildBioTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.eco, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trichogramma pretiosum",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Liberar 100.000 vespas/ha no início da infestação.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              "Práticas Culturais",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _buildBulletPoint("Eliminação de plantas hospedeiras (tigüeras)."),
          _buildBulletPoint("Rotação de culturas com plantas não hospedeiras."),
          _buildBulletPoint("Tratamento de sementes adequado."),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

class ProductRecommendationCard extends StatelessWidget {
  final String name;
  final String dose;
  final String group;
  final String? description;
  final bool isEfficient;

  const ProductRecommendationCard({
    super.key,
    required this.name,
    required this.dose,
    required this.group,
    this.description,
    this.isEfficient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (isEfficient)
                const Icon(Icons.star, color: Colors.amber, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTag(Icons.science, group),
              const SizedBox(width: 8),
              _buildTag(Icons.water_drop, dose),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
