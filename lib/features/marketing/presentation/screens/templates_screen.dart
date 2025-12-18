import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/marketing/presentation/screens/template_builder_screen.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Templates'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todos'),
              Tab(text: 'Populares'),
              Tab(text: 'Novos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTemplatesList(context),
            _buildTemplatesList(context),
            _buildTemplatesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              _buildSectionTitle('Dados e Resultados'),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTemplateItem(
                    context,
                    'NDVI Graph',
                    Icons.show_chart,
                    TemplateType.ndviEvolution,
                  ),
                  _buildTemplateItem(
                    context,
                    'Antes/Depois',
                    Icons.compare,
                    TemplateType.beforeAfter,
                  ),
                  _buildTemplateItem(
                    context,
                    'Produtividade',
                    Icons.trending_up,
                    TemplateType.highlightResult,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('Safra e Plantio'),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTemplateItem(
                    context,
                    'Início Safra',
                    Icons.grass,
                    TemplateType.generic,
                  ),
                  _buildTemplateItem(
                    context,
                    'Colheita',
                    Icons.agriculture,
                    TemplateType.generic,
                  ),
                  _buildTemplateItem(
                    context,
                    'Chuva',
                    Icons.water_drop,
                    TemplateType.generic,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('Stories'),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTemplateItem(
                    context,
                    'Dica Rápida',
                    Icons.lightbulb,
                    TemplateType.story,
                  ),
                  _buildTemplateItem(
                    context,
                    'Alerta Clima',
                    Icons.warning,
                    TemplateType.story,
                  ),
                  _buildTemplateItem(
                    context,
                    'Cotação',
                    Icons.attach_money,
                    TemplateType.story,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('Personalizados'),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Placeholder for custom templates
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Nenhum template salvo.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to template creator
              },
              icon: const Icon(Icons.add),
              label: const Text('Criar Meu Template'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTemplateItem(
    BuildContext context,
    String label,
    IconData icon,
    TemplateType type,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TemplateBuilderScreen(templateType: type),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: AppColors.primary),
                SizedBox(height: 8),
                Container(width: 40, height: 4, color: AppColors.gray200),
                SizedBox(height: 4),
                Container(width: 60, height: 4, color: AppColors.gray200),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
