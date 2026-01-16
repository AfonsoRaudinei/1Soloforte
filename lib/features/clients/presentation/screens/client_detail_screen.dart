import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/presentation/client_detail_controller.dart';
import 'package:soloforte_app/features/clients/presentation/widgets/client_history_timeline.dart';
import 'package:soloforte_app/features/clients/domain/client_history_model.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  String _selectedFilter = 'all';

  final List<ClientHistory> _allHistory = [];

  List<ClientHistory> get _filteredHistory {
    if (_selectedFilter == 'all') return _allHistory;
    return _allHistory.where((h) => h.actionType == _selectedFilter).toList();
  }

  void _handleHistoryTap(ClientHistory item) {
    if (item.actionType == 'occurrence') {
      // Mock navigation - would use ID in real app
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navegando para Detalhe da Ocorrência...'),
        ),
      );
      // context.push('/occurrences/detail/${item.id}');
    } else if (item.actionType == 'visit') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abrindo Relatório da Visita...')),
      );
    } else if (item.actionType == 'report') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abrindo Visualizador de PDF...')),
      );
    } else if (item.actionType == 'whatsapp') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Abrindo Chat...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientAsync = ref.watch(clientByIdProvider(widget.clientId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(clientAsync.value?.name ?? 'Carregando...'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Edit action
              context.push('/map/clients/${widget.clientId}/edit');
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Editar'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: clientAsync.when(
        data: (client) {
          if (client == null) {
            return const Center(child: Text('Cliente não encontrado'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar Box
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          client.initials,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        client.name.toUpperCase(),
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client.notes ?? '',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Info
                _buildSectionBox(
                  title: 'Informações de Contato',
                  child: Column(
                    children: [
                      _buildInfoRow('📧 Email', client.email),
                      _buildInfoRow('📱 Celular', client.phone),
                      _buildInfoRow('📱 Fixo', ''),
                      _buildInfoRow(
                        '📍 Endereço',
                        '${client.address}, ${client.city} - ${client.state}',
                      ),
                      if (client.cpfCnpj != null)
                        _buildInfoRow('🆔 CPF/CNPJ', client.cpfCnpj!),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Farms
                _buildSectionBox(
                  title: 'Fazendas (${client.farmIds.length})',
                  child: Column(
                    children: [
                      if (client.farmIds.isNotEmpty)
                        ...client.farmIds.map(
                          (farmId) => _buildFarmItem(farmId, '', ''),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics
                _buildSectionBox(
                  title: 'Estatísticas',
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Total de Área',
                        '${client.totalHectares.toStringAsFixed(0)} ha',
                      ),
                      _buildStatRow('Talhões', '${client.totalAreas}'),
                      _buildStatRow('Ocorrências', '0'),
                      _buildStatRow('Relatórios', '0'),
                      _buildStatRow(
                        'Última visita',
                        _formatLastActivity(client.lastActivity),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // History Section
                _buildSectionBox(
                  title: 'Histórico Completo',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('Todos', 'all'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Visitas', 'visit'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Ocorrências', 'occurrence'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Relatórios', 'report'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Chat', 'whatsapp'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Timeline
                      ClientHistoryTimeline(
                        history: _filteredHistory,
                        maxItems: 20, // Show more in detail view
                        onItemTap: _handleHistoryTap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(child: _buildActionBtn(Icons.phone, 'Ligar')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionBtn(Icons.chat, 'WhatsApp')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildActionBtn(Icons.email, 'Email')),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionBtn(
                        Icons.file_copy,
                        'Relatórios',
                        onPressed: () {
                          context.push(
                            '/map/calendar',
                            extra: {'clientId': widget.clientId},
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  Widget _buildSectionBox({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Text(title, style: AppTypography.h4.copyWith(fontSize: 16)),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildFarmItem(String name, String details, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.home, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(details, style: const TextStyle(fontSize: 12)),
                Text(
                  location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/map', extra: {'clientId': widget.clientId});
            },
            child: const Text('Ver no Mapa'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    IconData icon,
    String label, {
    VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatLastActivity(DateTime? date) {
    if (date == null) return '-';
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    if (diff < 7) return '$diff dias';
    return 'Semana';
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
        ),
      ),
      showCheckmark: false,
    );
  }
}
