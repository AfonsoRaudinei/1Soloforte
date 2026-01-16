import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_filter_sheet.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_sort_sheet.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';

class ClientListScreenEnhanced extends ConsumerStatefulWidget {
  const ClientListScreenEnhanced({super.key});

  @override
  ConsumerState<ClientListScreenEnhanced> createState() =>
      _ClientListScreenEnhancedState();
}

class _ClientListScreenEnhancedState
    extends ConsumerState<ClientListScreenEnhanced> {
  final TextEditingController _searchController = TextEditingController();
  ClientFilters _filters = ClientFilters();
  ClientSortOptions _sortOptions = const ClientSortOptions(
    field: SortField.name,
    direction: SortDirection.ascending,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Clientes / Produtores'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _filters.hasActiveFilters,
              label: Text(_filters.activeFilterCount.toString()),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilters,
          ),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSort),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar para formulário
          context.push('/map/clients/new');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Novo Cliente'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(clientsControllerProvider);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Barra de busca
              CustomTextInput(
                controller: _searchController,
                label: '',
                hint: 'Buscar por nome, cidade ou telefone...',
                prefixIcon: Icons.search,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Lista de clientes
              Expanded(
                child: clientsAsync.when(
                  data: (clients) {
                    final filteredClients = _applyFiltersAndSort(clients);

                    if (filteredClients.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        return _ClientCard(
                          client: filteredClients[index],
                          onTap: () {
                            context.push(
                              '/map/clients/${filteredClients[index].id}',
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar clientes',
                          style: AppTypography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: AppTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(clientsControllerProvider);
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Client> _applyFiltersAndSort(List<Client> clients) {
    var filtered = clients;

    // Aplicar busca
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((client) {
        return client.name.toLowerCase().contains(query) ||
            client.city.toLowerCase().contains(query) ||
            client.phone.contains(query);
      }).toList();
    }

    // Aplicar filtros
    if (_filters.status != null) {
      filtered = filtered.where((c) => c.status == _filters.status).toList();
    }

    if (_filters.type != null) {
      filtered = filtered.where((c) => c.type == _filters.type).toList();
    }

    if (_filters.state != null) {
      filtered = filtered.where((c) => c.state == _filters.state).toList();
    }

    if (_filters.city != null) {
      filtered = filtered.where((c) => c.city == _filters.city).toList();
    }

    // TODO: Aplicar filtro de área quando tivermos dados reais

    // Aplicar ordenação
    filtered.sort((a, b) {
      int comparison = 0;

      switch (_sortOptions.field) {
        case SortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortField.lastActivity:
          comparison = a.lastActivity.compareTo(b.lastActivity);
          break;
        case SortField.city:
          comparison = a.city.compareTo(b.city);
          break;
        case SortField.totalArea:
          // TODO: Usar dados reais de área
          comparison = 0;
          break;
        case SortField.createdDate:
          // TODO: Adicionar campo createdAt no modelo
          comparison = 0;
          break;
      }

      return _sortOptions.direction == SortDirection.ascending
          ? comparison
          : -comparison;
    });

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty || _filters.hasActiveFilters
                ? 'Nenhum cliente encontrado'
                : 'Nenhum cliente cadastrado',
            style: AppTypography.h4.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty || _filters.hasActiveFilters
                ? 'Tente ajustar os filtros ou busca'
                : 'Adicione seu primeiro cliente',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
          ),
          if (!_filters.hasActiveFilters && _searchController.text.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/map/clients/new');
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ClientFilterSheet(
        initialFilters: _filters,
        onApply: (filters) {
          setState(() {
            _filters = filters;
          });
        },
      ),
    );
  }

  void _showSort() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ClientSortSheet(
        initialSort: _sortOptions,
        onApply: (sortOptions) {
          setState(() {
            _sortOptions = sortOptions;
          });
        },
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onTap;

  const _ClientCard({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: client.avatarUrl != null
                  ? Image.network(
                      client.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _buildInitials(),
                    )
                  : _buildInitials(),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        client.name,
                        style: AppTypography.h4.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusBadge(status: client.status),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${client.city}/${client.state}',
                        style: AppTypography.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.agriculture, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${client.totalFarms} fazendas',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        client.phone,
                        style: AppTypography.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        client.initials,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isActive ? 'Ativo' : 'Inativo',
        style: AppTypography.caption.copyWith(
          color: isActive ? AppColors.success : Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
