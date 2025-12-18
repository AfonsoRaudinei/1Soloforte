import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/presentation/client_detail_controller.dart';
// Note: Keeping existing imports if they are useful, but likely will replace widget usages.

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // For now, we mock the data loading since providers layout might differ,
    // or we can try to use the existing provider if it works.
    final clientAsync = ref.watch(clientByIdProvider(widget.clientId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(clientAsync.value?.name ?? 'Carregando...'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Edit action
              context.push('/dashboard/clients/${widget.clientId}/edit');
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Editar'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: clientAsync.when(
        data: (client) {
          if (client == null)
            return const Center(child: Text('Cliente não encontrado'));
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
                        backgroundColor: AppColors.primary.withOpacity(0.1),
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
                        'Produtor desde 2020',
                        style: AppTypography.bodySmall,
                      ), // Mock date
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
                      _buildInfoRow('📱 Fixo', '(XX) XXXX-XXXX'), // Mock
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
                      // Mock Farms List
                      _buildFarmItem(
                        'Fazenda Boa Vista',
                        '120 ha | 8 talhões',
                        'Piracicaba, SP',
                      ),
                      const Divider(),
                      _buildFarmItem(
                        'Fazenda Santa Maria',
                        '45 ha | 3 talhões',
                        'Limeira, SP',
                      ),
                      // Add real logic to iterate farms if available
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics
                _buildSectionBox(
                  title: 'Estatísticas',
                  child: Column(
                    children: [
                      _buildStatRow('Total de Área', '180 ha'),
                      _buildStatRow('Talhões', '12'),
                      _buildStatRow('Ocorrências', '23'),
                      _buildStatRow('Relatórios', '8'),
                      _buildStatRow('Última visita', 'Ontem'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent History
                _buildSectionBox(
                  title: 'Histórico Recente (5)',
                  child: Column(
                    children: [
                      _buildHistoryItem(
                        '28/Out',
                        'Visita técnica',
                        'Talhão Norte',
                      ),
                      const SizedBox(height: 12),
                      _buildHistoryItem(
                        '25/Out',
                        'Ocorrência',
                        'Lagarta na soja',
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Ver Histórico Completo'),
                        ),
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
                      child: _buildActionBtn(Icons.file_copy, 'Relatórios'),
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
          TextButton(onPressed: () {}, child: const Text('Ver no Mapa')),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String date, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 10, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$date - $title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
