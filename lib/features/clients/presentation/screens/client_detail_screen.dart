import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/presentation/client_detail_controller.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_stats_card.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_history_timeline.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_quick_actions.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_farms_list.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen>
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
    final clientAsync = ref.watch(clientByIdProvider(widget.clientId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: clientAsync.when(
        data: (client) {
          if (client == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Cliente não encontrado', style: AppTypography.h3),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        // TODO: Navegar para edição
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Editar cliente (em desenvolvimento)',
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () => _showMoreOptions(context, client.id),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Avatar
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: client.avatarUrl != null
                                    ? Image.network(
                                        client.avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) =>
                                            _buildInitialsAvatar(
                                              client.initials,
                                            ),
                                      )
                                    : _buildInitialsAvatar(client.initials),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Nome
                            Text(
                              client.name,
                              style: AppTypography.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            // Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: client.isActive
                                    ? AppColors.success.withValues(alpha: 0.2)
                                    : Colors.grey.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                client.isActive ? 'Ativo' : 'Inativo',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Info'),
                        Tab(text: 'Fazendas'),
                        Tab(text: 'Histórico'),
                        Tab(text: 'Stats'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(client),
                _buildFarmsTab(),
                _buildHistoryTab(),
                _buildStatsTab(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Erro ao carregar cliente', style: AppTypography.h3),
              const SizedBox(height: 8),
              Text(error.toString(), style: AppTypography.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab(client) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ações Rápidas
          ClientQuickActions(
            phone: client.phone,
            email: client.email,
            clientId: client.id,
          ),
          const SizedBox(height: 24),

          // Informações de Contato
          _buildSection(
            title: 'Informações de Contato',
            icon: Icons.contact_phone,
            child: Column(
              children: [
                _buildInfoRow(Icons.phone, 'Telefone', client.phone),
                _buildInfoRow(Icons.email, 'Email', client.email),
                if (client.cpfCnpj != null)
                  _buildInfoRow(Icons.badge, 'CPF/CNPJ', client.cpfCnpj!),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Localização
          _buildSection(
            title: 'Localização',
            icon: Icons.location_on,
            child: Column(
              children: [
                _buildInfoRow(Icons.home, 'Endereço', client.address),
                _buildInfoRow(
                  Icons.location_city,
                  'Cidade/Estado',
                  '${client.city}/${client.state}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notas
          if (client.notes != null && client.notes!.isNotEmpty)
            _buildSection(
              title: 'Notas',
              icon: Icons.note,
              child: Text(client.notes!, style: AppTypography.bodyMedium),
            ),
        ],
      ),
    );
  }

  Widget _buildFarmsTab() {
    final farmsAsync = ref.watch(clientFarmsProvider(widget.clientId));

    return farmsAsync.when(
      data: (farms) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ClientFarmsList(
          farms: farms,
          onAddFarm: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Adicionar fazenda (em desenvolvimento)'),
              ),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }

  Widget _buildHistoryTab() {
    final historyAsync = ref.watch(clientHistoryProvider(widget.clientId));

    return historyAsync.when(
      data: (history) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ClientHistoryTimeline(history: history),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }

  Widget _buildStatsTab() {
    final statsAsync = ref.watch(clientStatsProvider(widget.clientId));

    return statsAsync.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estatísticas Gerais', style: AppTypography.h3),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                ClientStatsCard(
                  title: 'Fazendas',
                  value: stats.totalFarms.toString(),
                  icon: Icons.agriculture,
                  color: AppColors.success,
                ),
                ClientStatsCard(
                  title: 'Área Total',
                  value: '${stats.totalAreaHa.toStringAsFixed(1)} ha',
                  icon: Icons.landscape,
                  color: AppColors.primary,
                ),
                ClientStatsCard(
                  title: 'Talhões',
                  value: stats.totalAreas.toString(),
                  icon: Icons.grid_on,
                  color: AppColors.info,
                ),
                ClientStatsCard(
                  title: 'Visitas',
                  value: stats.totalVisits.toString(),
                  icon: Icons.location_on,
                  color: Colors.orange,
                ),
                ClientStatsCard(
                  title: 'Ocorrências',
                  value: stats.totalOccurrences.toString(),
                  icon: Icons.warning,
                  color: AppColors.warning,
                ),
                ClientStatsCard(
                  title: 'Relatórios',
                  value: stats.totalReports.toString(),
                  icon: Icons.description,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Comunicação', style: AppTypography.h3),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                ClientStatsCard(
                  title: 'Ligações',
                  value: stats.totalCalls.toString(),
                  icon: Icons.phone,
                  color: Colors.green,
                ),
                ClientStatsCard(
                  title: 'WhatsApp',
                  value: stats.totalWhatsappMessages.toString(),
                  icon: Icons.chat,
                  color: const Color(0xFF25D366),
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, String clientId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive, color: AppColors.warning),
              title: const Text('Arquivar cliente'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar arquivamento
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Excluir cliente'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar exclusão
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
