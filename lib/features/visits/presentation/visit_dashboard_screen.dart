import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/visits/domain/visit_model.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:intl/intl.dart';

class VisitDashboardScreen extends ConsumerWidget {
  const VisitDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitState = ref.watch(visitControllerProvider);
    final activeVisit = visitState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in/out'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status Atual', style: AppTypography.h3),
            const Divider(thickness: 1, height: 24),
            _buildStatusCard(context, activeVisit),
            const SizedBox(height: 24),

            Text('📊 Resumo de Hoje', style: AppTypography.h3),
            const Divider(thickness: 1, height: 24),
            _buildDailySummary(),
            const SizedBox(height: 24),

            Text('Histórico Recente', style: AppTypography.h3),
            const Divider(thickness: 1, height: 24),
            _buildRecentHistory(context),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to full history
                },
                child: const Text('Ver Histórico Completo'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: activeVisit == null
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/check-in'),
              label: const Text('Novo Check-in'),
              icon: const Icon(Icons.add_location_alt),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildStatusCard(BuildContext context, dynamic activeVisit) {
    if (activeVisit != null && activeVisit.status.name == 'ongoing') {
      final startTime = activeVisit.checkInTime;
      final duration = DateTime.now().difference(startTime);
      final durationStr =
          "${duration.inHours}h ${duration.inMinutes.remainder(60)}min";

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'VOCÊ ESTÁ EM CAMPO',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              activeVisit.client.name, // Assuming client object has name
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Assuming location/talhão is available or mock it
            const Text('Talhão Norte', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Check-in: ${DateFormat('HH:mm').format(startTime)}'),
                Text('Tempo: $durationStr'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/visit/checkout'),
                icon: const Icon(Icons.check),
                label: const Text('FAZER CHECK-OUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            const Icon(Icons.location_off, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'Você não está em campo no momento.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/check-in'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('INICIAR VISITA (CHECK-IN)'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDailySummary() {
    return Column(
      children: [
        _buildSummaryItem('Visitas', '2'),
        _buildSummaryItem('Tempo total', '3h 20min'),
        _buildSummaryItem('Distância', '45 km'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '• $label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentHistory(BuildContext context) {
    return Column(
      children: [
        _buildHistoryCard(
          context,
          client: 'João Silva',
          location: 'Talhão Norte',
          timeInOut: 'In: 09:15 | Out: Agora',
          duration: '1h 45min',
          activity: 'Visita técnica',
          isFinished: false,
        ),
        const SizedBox(height: 16),
        _buildHistoryCard(
          context,
          client: 'Maria Santos',
          location: 'Lavoura Sul',
          timeInOut: 'In: 07:30 | Out: 08:55',
          duration: '1h 25min',
          activity: 'Aplicação',
          isFinished: true,
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String client,
    required String location,
    required String timeInOut,
    required String duration,
    required String activity,
    required bool isFinished,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check,
                size: 16,
                color: isFinished ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                location,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
          Text(client, style: TextStyle(color: Colors.grey.shade600)),
          const Divider(height: 16),
          Text(timeInOut, style: const TextStyle(fontSize: 12)),
          Text('Duração: $duration', style: const TextStyle(fontSize: 12)),
          Text(
            'Atividade: $activity',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Mock Visit for verification
                final mockVisit = Visit(
                  id: 'mock-1',
                  client: Client(
                    id: 'c1',
                    name: 'João Silva',
                    email: '',
                    phone: '',
                    address: '',
                    city: 'Sinop',
                    state: 'MT',
                    type: 'producer',
                    status: 'active',
                    lastActivity: DateTime.now(),
                  ),
                  checkInTime: DateTime.now().subtract(
                    const Duration(hours: 2),
                  ),
                  checkOutTime: DateTime.now(),
                  latitude: -14.2350,
                  longitude: -51.9253,
                  status: VisitStatus.completed,
                  checkOutNotes:
                      'Visita produtiva. Recomenda-se aplicação preventiva.',
                  photos: [],
                  occurrenceIds: ['occ-1', 'occ-2'],
                );
                context.push('/visit/detail', extra: mockVisit);
              },
              child: const Text('Ver Detalhes'),
            ),
          ),
        ],
      ),
    );
  }
}
