import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/dashboard/presentation/executive_dashboard_controller.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/kpi_stats_card.dart';
import 'package:soloforte_app/features/dashboard/presentation/widgets/dashboard_charts.dart';
import 'package:soloforte_app/shared/widgets/touch_scale_wrapper.dart';
import 'package:soloforte_app/shared/widgets/modal_handle_bar.dart';

class ExecutiveDashboardScreen extends ConsumerStatefulWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  ConsumerState<ExecutiveDashboardScreen> createState() =>
      _ExecutiveDashboardScreenState();
}

class _ExecutiveDashboardScreenState
    extends ConsumerState<ExecutiveDashboardScreen> {
  String _selectedPeriod = 'Safra Atual';
  String? _selectedCrop; // Null = All
  String? _selectedField; // Null = All

  // Visibility Toggles
  bool _showFinancial = true;
  bool _showOperational = true;
  bool _showAttention = true;
  bool _showCharts = true;

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(executiveDashboardControllerProvider);
    final controller = ref.read(executiveDashboardControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Dashboard Executivo'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
            ), // [☰] Mock menu or use Scaffold drawer
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_selectedCrop != null || _selectedField != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Filtros Globais',
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showCustomizeLayoutSheet,
            tooltip: 'Personalizar Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month), // [📅]
            onPressed: _showDateFilterModal,
            tooltip: 'Selecionar Período',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Period Segmented Control [Hoje] [Semana] [Mês] [Safra]
              _buildPeriodSegmentedControl(controller),
              const SizedBox(height: 24),

              // 2. Visão Geral Summary Box
              _buildSummaryBox(dashboardState.summaryData),
              const SizedBox(height: 24),

              // 3. KPIs Principais (2 rows of 2)
              if (_showFinancial) ...[
                Text('KPIs Principais', style: AppTypography.label),
                const SizedBox(height: 12),
                _buildMainKPIs(dashboardState),
                const SizedBox(height: 24),
              ],

              // 4. Produtividade Section
              if (_showOperational) ...[
                _buildProductivitySection(),
                const SizedBox(height: 24),
              ],

              // 5. Gráfico Evolução NDVI
              if (_showCharts) ...[
                DashboardChartCard(
                  title: 'Evolução NDVI',
                  subtitle: 'Comparativo Safra Atual vs Anterior',
                  child: const NdviLineChart(),
                ),
                const SizedBox(height: 24),
              ],

              // 6. Alertas e Atenções (Grouped)
              if (_showAttention) ...[
                _buildGroupedAlerts(dashboardState.alerts),
                const SizedBox(height: 24),
              ],

              // 7. Distribuição Culturas
              if (_showCharts) ...[
                DashboardChartCard(
                  title: 'Distribuição Culturas',
                  subtitle: 'Área plantada por cultura',
                  child: const CropPieChart(), // Using existing widget
                ),
                const SizedBox(height: 24),
              ],

              // 8. Ocorrências por Tipo
              if (_showCharts) ...[
                DashboardChartCard(
                  title: 'Ocorrências por Tipo',
                  subtitle: 'Classificação de problemas',
                  child: const OccurrencesBarChart(),
                ),
                const SizedBox(height: 24),
              ],

              // 9. Custos e Investimentos
              if (_showFinancial) ...[
                _buildCostSection(),
                const SizedBox(height: 24),
              ],

              // 10. Equipe - Produtividade
              if (_showOperational) ...[
                _buildTeamSection(dashboardState.teamProductivity),
                const SizedBox(height: 24),
              ],

              // 11. Próximas Atividades (Agenda)
              DashboardChartCard(
                title: 'Próximas Atividades',
                subtitle: 'Agenda da semana',
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 4,
                      ),
                      title: const Text('Visita Técnica T5'),
                      subtitle: const Text('Hoje, 14:00 - Carlos Silva'),
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 4,
                      ),
                      title: const Text('Aplicação Defensivo T2'),
                      subtitle: const Text('Amanhã, 08:00 - Equipe A'),
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver Agenda Completa'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 12. Metas da Safra
              _buildGoalsSection(dashboardState.goals),
              const SizedBox(height: 32),

              // 13. Bottom Buttons
              _buildBottomButtons(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildPeriodSegmentedControl(ExecutiveDashboardController controller) {
    final periods = ['Hoje', 'Semana', 'Mês', 'Safra'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: periods.map((p) {
          final isSelected =
              _selectedPeriod == p ||
              (_selectedPeriod == 'Safra Atual' && p == 'Safra');
          return Expanded(
            child: TouchScaleWrapper(
              onTap: () {
                setState(() {
                  _selectedPeriod = p == 'Safra' ? 'Safra Atual' : p;
                  controller.updatePeriod(_selectedPeriod);
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryBox(Map<String, dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ), // Double border effect simulation
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'VISÃO GERAL',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, height: 24),
          _buildSummaryRow('Área Total', data['totalArea'] ?? '-'),
          const SizedBox(height: 8),
          _buildSummaryRow('Talhões', data['fields'] ?? '-'),
          const SizedBox(height: 8),
          _buildSummaryRow('Produtores', data['producers'] ?? '-'),
          const SizedBox(height: 8),
          _buildSummaryRow('Safra', data['harvest'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMainKPIs(ExecutiveDashboardState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: KPIStatsCard(
                title: 'NDVI Médio',
                value: state.averageNdvi.toStringAsFixed(2),
                subValue: '+0.05',
                icon: Icons.grass,
                color: AppColors.success,
                trend: '↗️',
                isTrendPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KPIStatsCard(
                title: 'Áreas Ativas',
                value: '${state.criticalAreasCount}',
                subValue: '/42',
                icon: Icons.map,
                color: AppColors.info,
                trend: '90%',
                isTrendPositive: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KPIStatsCard(
                title: 'Ocorrências',
                value: '${state.overdueOccurrencesCount}',
                subValue: '+3',
                icon: Icons.warning_amber,
                color: AppColors.warning,
                trend: '⚠️',
                isTrendPositive: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KPIStatsCard(
                title: 'Visitas Campo',
                value: '${state.todayEventsCount}',
                subValue: '+5',
                icon: Icons.directions_walk,
                color: AppColors.primary,
                trend: '📈',
                isTrendPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductivitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'PRODUTIVIDADE',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Estimada', '58 sc/ha'),
          _buildSummaryRow('Meta', '55 sc/ha'),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1.0, // > 100% logic
              minHeight: 12,
              backgroundColor: Color(0xFFE0E0E0),
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '105%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Projeção safra: 72.500 sc',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedAlerts(List<DashboardAlert> alerts) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    final critical = alerts
        .where((a) => a.severity == AlertSeverity.critical)
        .toList();
    final warning = alerts
        .where((a) => a.severity == AlertSeverity.warning)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notification_important, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'ALERTAS E ATENÇÕES',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          // Critical
          if (critical.isNotEmpty) ...[
            Text(
              '🔴 ${critical.length} Áreas críticas',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            ...critical.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text('• ${a.message}', style: AppTypography.bodySmall),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Warnings
          if (warning.isNotEmpty) ...[
            Text(
              '🟡 ${warning.length} Áreas atenção',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 8),
            ...warning.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text(
                  '• ${a.title}: ${a.message}',
                  style: AppTypography.bodySmall,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Center(
            child: TextButton(onPressed: () {}, child: const Text('Ver Todas')),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'CUSTOS E INVESTIMENTOS',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSummaryRow('Total Safra', 'R\$ 2.8M'),
          _buildSummaryRow('Custo/ha', 'R\$ 2.240'),
          const SizedBox(height: 12),
          // Simple visual dist
          _buildStatRow('Insumos', '65%'),
          _buildStatRow('Mão de obra', '20%'),
          _buildStatRow('Maquinário', '15%'),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver Detalhamento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(List<Map<String, dynamic>> team) {
    final topPerformer = team.firstWhere(
      (t) => t['isTop'] == true,
      orElse: () => team.first,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'EQUIPE - PRODUTIVIDADE',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSummaryRow('Técnicos', '8 ativos'),
          _buildSummaryRow('Visitas/dia', '3.5 média'),
          const SizedBox(height: 16),
          const Text(
            'Top Performer:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  '${topPerformer['name']} - ${topPerformer['visits']} visitas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver Ranking Completo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(List<Map<String, dynamic>> goals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                'METAS DA SAFRA',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          if (goals.isEmpty) const Text('Carregando metas...'),
          ...goals.map((g) {
            final val = g['value'] as double;
            final color = Color(g['color'] as int);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(g['title'] as String),
                      Text(
                        '${g['value'].toInt()}% (${g['label']})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: val / 100.0,
                    backgroundColor: Colors.grey[200],
                    color: color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showExportModal,
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('EXPORTAR RELATÓRIO'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Future share logic
            },
            icon: const Icon(Icons.share),
            label: const Text('COMPARTILHAR COM EQUIPE'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  void _showDateFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ModalHandleBar(),
              Text('Selecionar Período', style: AppTypography.h3),
              const Divider(),
              const SizedBox(height: 16),

              Text('Períodos Rápidos:', style: AppTypography.label),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          'Hoje',
                          'Últimos 7 dias',
                          'Últimos 30 dias',
                          'Este mês',
                          'Mês passado',
                          'Esta safra (Set-Abr)',
                          'Safra passada',
                          'Últimos 12 meses',
                          'Personalizado',
                        ]
                        .map(
                          (p) => ChoiceChip(
                            label: Text(p),
                            selected: _selectedPeriod == p,
                            onSelected: (val) {},
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 24),

              Text('Período Personalizado:', style: AppTypography.label),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDateInput('De:', '01/Set/2024')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateInput('Até:', '28/Out/2025')),
                ],
              ),
              const SizedBox(height: 24),

              Text('Comparar com:', style: AppTypography.label),
              CheckboxListTile(
                title: const Text('Período anterior'),
                value: true,
                onChanged: (v) {},
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Apply logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateInput(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar Dashboard', style: AppTypography.h3),
                  const SizedBox(height: 24),

                  Text('Cultura', style: AppTypography.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Todas', 'Soja', 'Milho', 'Trigo'].map((crop) {
                      final isSelected =
                          (crop == 'Todas' && _selectedCrop == null) ||
                          _selectedCrop == crop;
                      return ChoiceChip(
                        label: Text(crop),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            _selectedCrop = crop == 'Todas' ? null : crop;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  Text('Talhão / Área', style: AppTypography.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', 'T1 Norte', 'T2 Sul', 'T3 Leste'].map((
                      field,
                    ) {
                      final isSelected =
                          (field == 'Todos' && _selectedField == null) ||
                          _selectedField == field;
                      return ChoiceChip(
                        label: Text(field),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            _selectedField = field == 'Todos' ? null : field;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Update main screen state
                        Navigator.pop(context);
                        // Trigger controller update if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Aplicar Filtros'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomizeLayoutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personalizar Visualização', style: AppTypography.h3),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha quais seções exibir no dashboard.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),

                  SwitchListTile(
                    title: const Text('Financeiro'),
                    value: _showFinancial,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => _showFinancial = val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Operacional & Agronômico'),
                    value: _showOperational,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => _showOperational = val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Atenções e Alertas'),
                    value: _showAttention,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => _showAttention = val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Gráficos Detalhados'),
                    value: _showCharts,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() => _showCharts = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showExportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.ios_share, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text('Exportar Relatório', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione o formato e o método de envio.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),

                  Text('Formato do Arquivo', style: AppTypography.label),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildExportOption(
                        icon: Icons.picture_as_pdf,
                        label: 'PDF',
                        color: Colors.red,
                        onTap: () {
                          _simulateExportProcess(context, 'PDF');
                        },
                      ),
                      _buildExportOption(
                        icon: Icons.table_chart,
                        label: 'Excel',
                        color: Colors.green,
                        onTap: () {
                          _simulateExportProcess(context, 'Excel');
                        },
                      ),
                      _buildExportOption(
                        icon: Icons.slideshow,
                        label: 'PPT',
                        color: Colors.orange,
                        onTap: () {
                          _simulateExportProcess(context, 'PowerPoint');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text('Enviar por E-mail'),
                    subtitle: const Text('Para a equipe cadastrada'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'E-mail enviado para equipe@soloforte.com.br',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: AppColors.secondary,
                      ),
                    ),
                    title: const Text('Agendar Envio'),
                    subtitle: const Text('Receber semanalmente'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Agendamento semanal criado com sucesso!',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _simulateExportProcess(BuildContext context, String format) async {
    Navigator.pop(context); // Close sheet

    // Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Gerando $format...', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ),
    );

    // Simulate Delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close Loading

      // Success Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relatório ($format) gerado com sucesso!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'ABRIR',
            textColor: Colors.white,
            onPressed: () {
              // Open file logic
            },
          ),
        ),
      );
    }
  }
}
