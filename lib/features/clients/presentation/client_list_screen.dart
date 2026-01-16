import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/shared/widgets/empty_state_widget.dart';

class ClientListScreen extends ConsumerStatefulWidget {
  const ClientListScreen({super.key});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos'; // Todos, Ativos, Inativos

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open Drawer if exists
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Produtores'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              context.push('/map/clients/new');
            },
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: Text(
              'Novo',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Buscar produtor...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                _buildFilterChip('Todos'),
                const SizedBox(width: 8),
                _buildFilterChip('Ativos'),
                const SizedBox(width: 8),
                _buildFilterChip('Inativos'),
              ],
            ),
          ),

          // List
          Expanded(
            child: clientsAsync.when(
              data: (clients) {
                final filteredClients = _applyFilters(clients);
                if (filteredClients.isEmpty) {
                  return EmptyStateWidget(
                    title: 'Nenhum produtor encontrado',
                    message:
                        'Tente ajustar os filtros ou cadastre um novo produtor.',
                    icon: Icons.person_off_outlined,
                    actionLabel: 'Cadastrar Produtor',
                    onAction: () => context.push('/map/clients/new'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredClients.length + 1, // +1 for "Load more"
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == filteredClients.length) {
                      return Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Carregar mais...'),
                        ),
                      );
                    }
                    return _buildProducerCard(filteredClients[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Erro ao carregar clientes: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Client> _applyFilters(List<Client> clients) {
    var filtered = clients;
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((client) {
        return client.name.toLowerCase().contains(query) ||
            client.city.toLowerCase().contains(query) ||
            client.phone.contains(query);
      }).toList();
    }

    if (_selectedFilter == 'Ativos') {
      filtered = filtered.where((c) => c.status == 'active').toList();
    } else if (_selectedFilter == 'Inativos') {
      filtered = filtered.where((c) => c.status == 'inactive').toList();
    }

    return filtered;
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProducerCard(Client client) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.grey),
              const SizedBox(width: 8),
              Text(client.name, style: AppTypography.h4),
            ],
          ),
          const Divider(),
          _buildInfoLine(Icons.phone_android, client.phone),
          const SizedBox(height: 4),
          _buildInfoLine(Icons.location_on, '${client.city}, ${client.state}'),
          const SizedBox(height: 12),

          Text(
            client.notes ?? 'Sem dados',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '📊 ${client.totalAreas} Áreas monitoradas',
            style: AppTypography.bodySmall,
          ),

          const SizedBox(height: 12),
          Text(
            _getLastVisitText(client.lastActivity),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.push('/map/clients/${client.id}');
              },
              child: const Text('Ver Detalhes'),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastVisitText(DateTime? date) {
    if (date == null) return 'Última visita: -';
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Última visita: Hoje';
    if (diff == 1) return 'Última visita: Ontem';
    if (diff < 7) return 'Última visita: $diff dias';
    return 'Última visita: Semana'; // Simplified
  }

  Widget _buildInfoLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: AppTypography.bodyMedium),
      ],
    );
  }
}
