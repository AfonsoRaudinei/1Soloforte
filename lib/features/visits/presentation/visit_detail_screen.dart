import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/visits/presentation/visit_providers.dart';

class VisitDetailScreen extends ConsumerWidget {
  final String visitId;

  const VisitDetailScreen({super.key, required this.visitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitAsync = ref.watch(visitByIdProvider(visitId));

    return visitAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Erro ao carregar visita: $error')),
      ),
      data: (visit) {
        if (visit == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Visita não encontrada.')),
          );
        }

        final dateFormat = DateFormat('dd/MMMM/yyyy', 'pt_BR');
        final timeFormat = DateFormat('HH:mm');

        final duration = visit.checkOutTime != null
            ? visit.checkOutTime!.difference(visit.checkInTime)
            : Duration.zero;

        final durationStr =
            "${duration.inHours}h ${duration.inMinutes.remainder(60)}min";

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Visita - ${DateFormat('dd/MMM').format(visit.checkInTime)}',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Informações da Visita',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.calendar_today,
                              dateFormat.format(visit.checkInTime),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.access_time,
                              '${timeFormat.format(visit.checkInTime)} - ${visit.checkOutTime != null ? timeFormat.format(visit.checkOutTime!) : 'Em andamento'}',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.timer, 'Duração: $durationStr'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.person, visit.client.name),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.label, 'Visita técnica'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Map Placeholder
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              visit.latitude,
                              visit.longitude,
                            ),
                            initialZoom: 14,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    visit.latitude,
                                    visit.longitude,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Trajeto registrado',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Summary Stats
                Text('📊 Resumo', style: AppTypography.h3),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Ocorrências',
                      '${visit.occurrenceIds.length}',
                    ),
                    _buildStatItem('Fotos', '${visit.photos.length}'),
                    _buildStatItem('Amostras', '0'), // Placeholder
                  ],
                ),
                const SizedBox(height: 24),

                // Observations
                Text('📝 Observações', style: AppTypography.h3),
                const Divider(),
                if (visit.checkOutNotes != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(visit.checkOutNotes!),
                  )
                else
                  const Text(
                    'Nenhuma observação registrada.',
                    style: TextStyle(color: Colors.grey),
                  ),

                const SizedBox(height: 24),

                // Photos
                Text('🖼️ Fotos da Visita', style: AppTypography.h3),
                const SizedBox(height: 12),
                if (visit.photos.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visit.photos
                        .map(
                          (path) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                else
                  const Text(
                    'Nenhuma foto.',
                    style: TextStyle(color: Colors.grey),
                  ),

                const SizedBox(height: 32),

                // Actions
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.description),
                  label: const Text('Ver Relatório Gerado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Compartilhar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
