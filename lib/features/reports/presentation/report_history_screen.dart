import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/domain/report_history.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/features/reports/application/report_history_provider.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:intl/intl.dart';

/// Tela de histórico de relatórios
class ReportHistoryScreen extends ConsumerStatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  ConsumerState<ReportHistoryScreen> createState() =>
      _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends ConsumerState<ReportHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Relatórios'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.history), text: 'Todos'),
            Tab(icon: Icon(Icons.star), text: 'Favoritos'),
            Tab(icon: Icon(Icons.schedule), text: 'Agendados'),
          ],
        ),
      ),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
        data: (_) {
          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllReportsTab(),
                    _buildFavoritesTab(),
                    _buildScheduledTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar para wizard de criação
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abrindo wizard de criação...')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Relatório'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar relatórios...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildAllReportsTab() {
    final history = ref.watch(reportHistoryProvider);
    final reports = _searchQuery.isEmpty
        ? history.reports
        : history.searchReports(_searchQuery);

    if (reports.isEmpty) {
      return _buildEmptyState(
        icon: Icons.description,
        title: 'Nenhum relatório',
        message: _searchQuery.isEmpty
            ? 'Você ainda não criou nenhum relatório.\nClique no botão + para começar!'
            : 'Nenhum relatório encontrado para "$_searchQuery"',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildReportCard(reports[index]);
      },
    );
  }

  Widget _buildFavoritesTab() {
    final history = ref.watch(reportHistoryProvider);
    final favorites = history.favorites;

    if (favorites.isEmpty) {
      return _buildEmptyState(
        icon: Icons.star_border,
        title: 'Nenhum favorito',
        message: 'Marque relatórios como favoritos\npara acesso rápido!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildReportCard(favorites[index]);
      },
    );
  }

  Widget _buildScheduledTab() {
    final history = ref.watch(reportHistoryProvider);
    final schedules = history.schedules;

    if (schedules.isEmpty) {
      return _buildEmptyState(
        icon: Icons.schedule,
        title: 'Nenhum agendamento',
        message: 'Agende relatórios para geração\nautomática periódica!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: schedules.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildScheduleCard(schedules[index]);
      },
    );
  }

  Widget _buildReportCard(SavedReport report) {
    return Slidable(
      key: ValueKey(report.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _shareReport(report),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Compartilhar',
          ),
          SlidableAction(
            onPressed: (context) => _duplicateReport(report),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.copy,
            label: 'Duplicar',
          ),
          SlidableAction(
            onPressed: (context) => _deleteReport(report),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Excluir',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _viewReport(report),
        child: AppCard(
          child: Row(
            children: [
              // Ícone do template
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: report.template.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  report.template.icon,
                  color: report.template.color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (report.isFavorite)
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.template.name,
                      style: AppTypography.caption.copyWith(
                        color: report.template.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(report.createdAt),
                          style: AppTypography.caption.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (report.viewCount > 0) ...[
                          Icon(
                            Icons.visibility,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${report.viewCount}',
                            style: AppTypography.caption.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Botão de ações
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showReportActions(report),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ReportSchedule schedule) {
    return AppCard(
      child: Row(
        children: [
          // Ícone
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: schedule.isActive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              schedule.frequency.icon,
              color: schedule.isActive ? Colors.green : Colors.grey,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schedule.frequency.name,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Próxima execução: ${DateFormat('dd/MM HH:mm').format(schedule.nextRunAt)}',
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Switch ativo/inativo
          Switch(
            value: schedule.isActive,
            onChanged: (value) {
              ref.read(reportHistoryProvider).toggleScheduleActive(schedule.id);
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.h2.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Ações
  void _viewReport(SavedReport report) {
    ref.read(reportHistoryProvider).updateViewCount(report.id);
    // TODO: Abrir PDF viewer
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Visualizando: ${report.title}')));
  }

  void _shareReport(SavedReport report) {
    // TODO: Implementar compartilhamento
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Compartilhando: ${report.title}')));
  }

  Future<void> _duplicateReport(SavedReport report) async {
    final duplicate = await ref
        .read(reportHistoryProvider)
        .duplicateReport(report.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relatório duplicado: ${duplicate.title}')),
      );
    }
  }

  Future<void> _deleteReport(SavedReport report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Relatório'),
        content: Text('Deseja realmente excluir "${report.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(reportHistoryProvider).deleteReport(report.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Relatório excluído')));
      }
    }
  }

  void _showReportActions(SavedReport report) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(report.isFavorite ? Icons.star : Icons.star_border),
              title: Text(
                report.isFavorite
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
              ),
              onTap: () {
                ref.read(reportHistoryProvider).toggleFavorite(report.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                _shareReport(report);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicar'),
              onTap: () {
                Navigator.pop(context);
                _duplicateReport(report);
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Imprimir'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Função de impressão em desenvolvimento'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteReport(report);
              },
            ),
          ],
        ),
      ),
    );
  }
}
