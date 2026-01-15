import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_detail_provider.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/reports/application/pdf_generator_service.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class OccurrenceDetailScreen extends ConsumerWidget {
  final String occurrenceId;
  const OccurrenceDetailScreen({super.key, required this.occurrenceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occurrenceAsync = ref.watch(occurrenceDetailProvider(occurrenceId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          if (occurrenceAsync.asData?.value != null)
            PopupMenuButton<String>(
              onSelected: (value) => _handleAction(
                context,
                ref,
                value,
                occurrenceAsync.asData!.value!,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 8),
                      Text('Compartilhar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: occurrenceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Erro: $err', style: AppTypography.bodyMedium)),
        data: (occurrence) {
          if (occurrence == null) {
            return const Center(child: Text('Ocorrência não encontrada'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              occurrence.type.toUpperCase(),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Severidade: ${(occurrence.severity * 100).toInt()}%',
                            style: AppTypography.h4.copyWith(
                              color: _getSeverityColor(occurrence.severity),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(occurrence.title, style: AppTypography.h2),
                    ],
                  ),
                ),

                // Image Gallery
                if (occurrence.images.isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        ...occurrence.images.map(
                          (url) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _ImageCard(url),
                          ),
                        ),
                        // Only show Add Photo if needed
                        // _AddPhotoCard(),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sem fotos registradas',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Info Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Status',
                            value: occurrence.status.toUpperCase(),
                            valueColor: _getStatusColor(occurrence.status),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(label: 'Área', value: occurrence.areaName),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Localização',
                            value:
                                '${occurrence.latitude.toStringAsFixed(4)}, ${occurrence.longitude.toStringAsFixed(4)}',
                          ),
                          if (occurrence.assignedTo != null &&
                              occurrence.assignedTo!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _InfoRow(
                              label: 'Atribuído a',
                              value: occurrence.assignedTo!,
                            ),
                          ],
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Estádio',
                            value: occurrence.phenologicalStage,
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Tipo Temporal',
                            value: occurrence.temporalType,
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Amostra de Solo',
                            value: occurrence.hasSoilSample
                                ? 'Coletada'
                                : 'Não coletada',
                            valueColor: occurrence.hasSoilSample
                                ? AppColors.success
                                : null,
                          ),
                          if (occurrence.technicalResponsible.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _InfoRow(
                              label: 'Responsável',
                              value: occurrence.technicalResponsible,
                            ),
                          ],
                          if (occurrence.categorySeverities.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Categorias & Severidade',
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...occurrence.categorySeverities.entries.map((e) {
                              final category = e.key;
                              final severity = e.value;
                              final images =
                                  occurrence.categoryImages[category] ?? [];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category,
                                          style: AppTypography.bodyMedium,
                                        ),
                                        Text(
                                          '${(severity * 100).toInt()}%',
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: _getSeverityColor(
                                                  severity,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                    if (images.isNotEmpty)
                                      Container(
                                        height: 60,
                                        margin: const EdgeInsets.only(top: 4),
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: images
                                              .map(
                                                (url) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 4,
                                                      ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    child: _ImageCard(
                                                      url,
                                                    ), // Reusing existing card, will adjust size via constraints if needed or use simple image
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Technical Recommendation
                if (occurrence.technicalRecommendation.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recomendação Técnica', style: AppTypography.h4),
                        const SizedBox(height: 8),
                        Text(
                          occurrence.technicalRecommendation,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Descrição', style: AppTypography.h4),
                      const SizedBox(height: 8),
                      Text(
                        occurrence.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Timeline
                if (occurrence.timeline.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Histórico (${occurrence.timeline.length})',
                          style: AppTypography.h4,
                        ),
                        const SizedBox(height: 16),
                        ...occurrence.timeline.asMap().entries.map((entry) {
                          final index = entry.key;
                          final event = entry.value;
                          return _TimelineItem(
                            date:
                                '${event.date.day}/${event.date.month} ${event.date.hour}:${event.date.minute}',
                            title: event.title,
                            subtitle: event.description,
                            isLast: index == occurrence.timeline.length - 1,
                          );
                        }),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Temporal Analysis Section
                _TemporalAnalysisSection(
                  currentOccurrence: occurrence,
                  allOccurrences:
                      ref.watch(occurrenceControllerProvider).asData?.value ??
                      [],
                ),

                const SizedBox(height: 32),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Relatório Técnico',
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gerando relatório...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          await ref
                              .read(pdfGeneratorServiceProvider)
                              .generateOccurrenceTechnicalReport(occurrence);
                        },
                        icon: Icons.picture_as_pdf,
                        backgroundColor: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Ver no Mapa',
                        onPressed: () {
                          context.push(
                            '/map',
                            extra: LatLng(
                              occurrence.latitude,
                              occurrence.longitude,
                            ),
                          );
                        },
                        icon: Icons.map,
                        backgroundColor: Colors.white,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      if (occurrence.status != 'resolved')
                        PrimaryButton(
                          text: 'Marcar como Resolvida',
                          onPressed: () async {
                            final newEvent = TimelineEvent(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              title: 'Status Alterado',
                              description: 'Ocorrência marcada como resolvida.',
                              date: DateTime.now(),
                              type: 'status_change',
                              authorName: 'Usuário',
                            );
                            final updated = occurrence.copyWith(
                              status: 'resolved',
                              timeline: [...occurrence.timeline, newEvent],
                            );
                            await ref
                                .read(occurrenceControllerProvider.notifier)
                                .updateOccurrence(updated);
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          icon: Icons.check,
                          backgroundColor: AppColors.success,
                        ),
                      const SizedBox(height: 12),
                      // Recurrence Button - creates new occurrence from technical data
                      PrimaryButton(
                        text: 'Criar Ocorrência Recorrente',
                        onPressed: () {
                          // Navigate to NewOccurrenceScreen with only technical data
                          // Does NOT copy: id, date, status, images, location, timeline
                          context.push(
                            '/occurrences/new',
                            extra: {'recurrentFrom': occurrence},
                          );
                        },
                        icon: Icons.repeat,
                        backgroundColor: Colors.white,
                        textColor: AppColors.textSecondary,
                        borderColor: AppColors.border,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getSeverityColor(double severity) {
    if (severity > 0.7) return AppColors.error;
    if (severity > 0.4) return AppColors.warning;
    return AppColors.success;
  }

  Color _getStatusColor(String status) {
    if (status == 'active') return AppColors.error;
    if (status == 'monitoring') return AppColors.warning;
    if (status == 'resolved') return AppColors.success;
    return Colors.grey;
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String value,
    Occurrence occurrence,
  ) async {
    switch (value) {
      case 'edit':
        context.push('/occurrences/edit', extra: occurrence);
        break;
      case 'share':
        Share.share(
          'Ocorrência: ${occurrence.title}\n'
          'Tipo: ${occurrence.type}\n'
          'Severidade: ${(occurrence.severity * 100).toInt()}%\n'
          'Status: ${occurrence.status}\n'
          'Descrição: ${occurrence.description}',
        );
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Excluir Ocorrência'),
            content: const Text(
              'Tem certeza que deseja excluir esta ocorrência?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await ref
              .read(occurrenceControllerProvider.notifier)
              .deleteOccurrence(occurrence.id);
          if (context.mounted) {
            context.pop(); // Close detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ocorrência excluída.')),
            );
          }
        }
        break;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: Colors.grey),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String url;
  const _ImageCard(this.url);

  @override
  Widget build(BuildContext context) {
    bool isNetwork = url.startsWith('http') || url.startsWith('https');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: isNetwork
          ? Image.network(
              url,
              width: 150,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            )
          : Image.file(
              File(url),
              width: 150,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  final bool isLast;

  const _TimelineItem({
    required this.date,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 50, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: AppTypography.caption.copyWith(color: Colors.grey),
            ),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(subtitle, style: AppTypography.bodySmall),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}

/// Widget that displays temporal analysis of occurrences in the same area.
/// Read-only, no AI, no predictions - just historical data visualization.
class _TemporalAnalysisSection extends StatefulWidget {
  final Occurrence currentOccurrence;
  final List<Occurrence> allOccurrences;

  const _TemporalAnalysisSection({
    required this.currentOccurrence,
    required this.allOccurrences,
  });

  @override
  State<_TemporalAnalysisSection> createState() =>
      _TemporalAnalysisSectionState();
}

class _TemporalAnalysisSectionState extends State<_TemporalAnalysisSection> {
  String _groupBy = 'data'; // data, categoria, status, ano

  List<Occurrence> get _relatedOccurrences {
    // Filter occurrences from the same area, excluding current
    return widget.allOccurrences
        .where(
          (o) =>
              o.areaName == widget.currentOccurrence.areaName &&
              o.id != widget.currentOccurrence.id,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  @override
  Widget build(BuildContext context) {
    final related = _relatedOccurrences;

    if (related.isEmpty) {
      return const SizedBox.shrink(); // No related occurrences
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with grouping selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Histórico da Área (${related.length})',
                style: AppTypography.h4,
              ),
              PopupMenuButton<String>(
                initialValue: _groupBy,
                onSelected: (value) => setState(() => _groupBy = value),
                icon: const Icon(Icons.filter_list, size: 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'data', child: Text('Por Data')),
                  const PopupMenuItem(
                    value: 'categoria',
                    child: Text('Por Categoria'),
                  ),
                  const PopupMenuItem(
                    value: 'status',
                    child: Text('Por Status'),
                  ),
                  const PopupMenuItem(value: 'ano', child: Text('Por Ano')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grouped list
          _buildGroupedList(related),
        ],
      ),
    );
  }

  Widget _buildGroupedList(List<Occurrence> occurrences) {
    switch (_groupBy) {
      case 'categoria':
        return _buildByCategoryGroup(occurrences);
      case 'status':
        return _buildByStatusGroup(occurrences);
      case 'ano':
        return _buildByYearGroup(occurrences);
      default:
        return _buildByDateList(occurrences);
    }
  }

  Widget _buildByDateList(List<Occurrence> occurrences) {
    return Column(
      children: occurrences
          .take(5)
          .map((o) => _buildOccurrenceCard(o))
          .toList(),
    );
  }

  Widget _buildByCategoryGroup(List<Occurrence> occurrences) {
    final grouped = <String, List<Occurrence>>{};
    for (final o in occurrences) {
      final cats = o.categorySeverities.keys.toList();
      final label = cats.isNotEmpty ? cats.join(', ') : o.type;
      grouped.putIfAbsent(label, () => []).add(o);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries
          .map(
            (entry) => _buildGroupHeader(
              entry.key,
              entry.value.length,
              entry.value.take(3).toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _buildByStatusGroup(List<Occurrence> occurrences) {
    final grouped = <String, List<Occurrence>>{};
    for (final o in occurrences) {
      grouped.putIfAbsent(o.status, () => []).add(o);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries
          .map(
            (entry) => _buildGroupHeader(
              _getStatusLabel(entry.key),
              entry.value.length,
              entry.value.take(3).toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _buildByYearGroup(List<Occurrence> occurrences) {
    final grouped = <int, List<Occurrence>>{};
    for (final o in occurrences) {
      grouped.putIfAbsent(o.date.year, () => []).add(o);
    }

    final sortedYears = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedYears
          .map(
            (year) => _buildGroupHeader(
              year.toString(),
              grouped[year]!.length,
              grouped[year]!.take(3).toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGroupHeader(String title, int count, List<Occurrence> items) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: AppTypography.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      children: items.map((o) => _buildOccurrenceCard(o)).toList(),
    );
  }

  Widget _buildOccurrenceCard(Occurrence o) {
    return InkWell(
      onTap: () => context.push('/occurrences/${o.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Date column
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${o.date.day}',
                  style: AppTypography.h4.copyWith(color: AppColors.primary),
                ),
                Text(
                  '${_getMonthAbbr(o.date.month)}/${o.date.year.toString().substring(2)}',
                  style: AppTypography.caption,
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.title.length > 30
                        ? '${o.title.substring(0, 30)}...'
                        : o.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatusChip(o.status),
                      const SizedBox(width: 8),
                      Text(
                        '${(o.severity * 100).toInt()}%',
                        style: AppTypography.caption.copyWith(
                          color: _getSeverityColor(o.severity),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getStatusLabel(status),
        style: AppTypography.caption.copyWith(
          color: _getStatusColor(status),
          fontSize: 10,
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    return switch (status) {
      'active' => 'Ativa',
      'monitoring' => 'Monitorando',
      'resolved' => 'Resolvida',
      _ => status,
    };
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'active' => AppColors.error,
      'monitoring' => AppColors.warning,
      'resolved' => AppColors.success,
      _ => Colors.grey,
    };
  }

  Color _getSeverityColor(double severity) {
    if (severity > 0.7) return AppColors.error;
    if (severity > 0.4) return AppColors.warning;
    return AppColors.success;
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return months[month - 1];
  }
}
