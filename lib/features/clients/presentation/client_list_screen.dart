import 'package:flutter/material.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Data
  final List<Client> _clients = [
    Client(
      id: '1',
      name: 'Fazenda Santa Rita',
      email: 'contato@santarita.com.br',
      phone: '(16) 99999-8888',
      cpfCnpj: '12.345.678/0001-90',
      address: 'Rod. SP-330, km 300, Ribeirão Preto - SP',
      city: 'Ribeirão Preto',
      state: 'SP',
      type: 'producer',
      status: 'active',
      lastActivity: DateTime.now().subtract(const Duration(days: 2)),
      farmIds: ['1', '2'],
      avatarUrl:
          'https://images.unsplash.com/photo-1595433707802-6b2626ef1c91?q=80&w=200&auto=format&fit=crop',
      notes: 'Grande produtor de soja e milho',
    ),
    Client(
      id: '2',
      name: 'Agropecuária Boa Vista',
      email: 'financeiro@boavista.agr.br',
      phone: '(62) 98888-7777',
      cpfCnpj: '98.765.432/0001-10',
      address: 'Zona Rural, Rio Verde - GO',
      city: 'Rio Verde',
      state: 'GO',
      type: 'producer',
      status: 'active',
      lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      farmIds: ['3'],
      avatarUrl:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
    ),
    Client(
      id: '3',
      name: 'Consultoria Solo Fértil',
      email: 'admin@solofertil.com',
      phone: '(34) 3333-2222',
      cpfCnpj: '123.456.789-00',
      address: 'Uberaba - MG',
      city: 'Uberaba',
      state: 'MG',
      type: 'consultant',
      status: 'inactive',
      lastActivity: DateTime.now().subtract(const Duration(days: 45)),
      farmIds: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Clientes / Produtores'),
        actions: [
          PrimaryButton(
            text: 'Novo Cliente',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Novo Cliente (Mock)')),
              );
            },
            isFullWidth: false,
            icon: Icons.add,
            // Using default primary color
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextInput(
              controller: _searchController,
              label: '',
              hint: 'Buscar por nome, fazenda ou cidade...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  return _ClientCard(client: _clients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Client client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // Detail navigation (Mock)
        // context.go('/dashboard/clients/${client.id}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detalhes do Cliente (Mock)')),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: client.avatarUrl != null
                ? NetworkImage(client.avatarUrl!)
                : null,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: client.avatarUrl == null
                ? Text(
                    client.initials,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      client.name,
                      style: AppTypography.h4.copyWith(fontSize: 16),
                    ),
                    _StatusBadge(status: client.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(client.address, style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.map_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${client.totalAreas} áreas',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.grass_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${client.totalHectares} ha',
                      style: AppTypography.caption,
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
