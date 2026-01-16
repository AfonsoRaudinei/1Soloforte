import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';

class OccurrencesLayer extends ConsumerWidget {
  final String? clientId;
  final String? clientName;

  const OccurrencesLayer({super.key, this.clientId, this.clientName});

  IconData _getOccurrenceIcon(String type) {
    switch (type) {
      case 'pest':
        return Icons.bug_report;
      case 'disease':
        return Icons.coronavirus;
      case 'weed':
        return Icons.grass;
      default:
        return Icons.warning;
    }
  }

  Color _getSeverityColor(double severity) {
    if (severity < 0.3) return Colors.green;
    if (severity < 0.7) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occurrencesAsync = ref.watch(occurrenceControllerProvider);
    final shouldFilter = clientId != null;

    return occurrencesAsync.when(
      data: (occurrences) {
        var filteredOccurrences = occurrences;
        if (shouldFilter) {
          filteredOccurrences =
              occurrences.where((occ) => occ.clientId == clientId).toList();
        }
        return MarkerLayer(
          markers: filteredOccurrences.map((occ) {
          return Marker(
            point: LatLng(occ.latitude, occ.longitude),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => context.push('/occurrences/detail/${occ.id}'),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getOccurrenceIcon(occ.type),
                  color: _getSeverityColor(occ.severity),
                  size: 24,
                ),
              ),
            ),
          );
          }).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
