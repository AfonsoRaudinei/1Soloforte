import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';

class MockClientDisplay {
  final Client client;
  final int areas;
  final double ha;
  MockClientDisplay(this.client, this.areas, this.ha);
}

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos'; // Todos, Ativos, Inativos

  // Mock Data
  final List<MockClientDisplay> _clients = [
    MockClientDisplay(
      Client(
        id: '1',
        name: 'João Silva',
        email: 'joao.silva@email.com',
        phone: '(11) 98765-4321',
        cpfCnpj: '123.456.789-00',
        address: 'Fazenda Boa Vista',
        city: 'Piracicaba',
        state: 'SP',
        type: 'producer',
        status: 'active',
        lastActivity: DateTime.now().subtract(const Duration(days: 1)),
        notes: '3 Fazendas | 180 ha',
      ),
      12,
      180,
    ),
    MockClientDisplay(
      Client(
        id: '2',
        name: 'Maria Santos',
        email: 'maria@email.com',
        phone: '(19) 99876-5432',
        cpfCnpj: '987.654.321-00',
        address: 'Ribeirão Preto, SP',
        city: 'Ribeirão Preto',
        state: 'SP',
        type: 'producer',
        status: 'active',
        lastActivity: DateTime.now().subtract(const Duration(days: 3)),
        notes: '1 Fazenda | 240 ha',
      ),
      8,
      240,
    ),
    MockClientDisplay(
      Client(
        id: '3',
        name: 'Pedro Oliveira',
        email: 'pedro@email.com',
        phone: '(16) 98888-9999',
        cpfCnpj: '456.789.123-00',
        address: 'Franca, SP',
        city: 'Franca',
        state: 'SP',
        type: 'producer',
        status: 'inactive',
        lastActivity: DateTime.now().subtract(const Duration(days: 7)),
        notes: '2 Fazendas | 95 ha',
      ),
      5,
      95,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              context.push('/dashboard/clients/new');
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
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _clients.length + 1, // +1 for "Load more"
              separatorBuilder: (c, i) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == _clients.length) {
                  return Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Carregar mais...'),
                    ),
                  );
                }
                return _buildProducerCard(_clients[index]);
              },
            ),
          ),
        ],
      ),
    );
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

  Widget _buildProducerCard(MockClientDisplay item) {
    final client = item.client;
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
            '📊 ${item.areas} Áreas monitoradas',
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
                context.push('/dashboard/clients/${client.id}');
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
