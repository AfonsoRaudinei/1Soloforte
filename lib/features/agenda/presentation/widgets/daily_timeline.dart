import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';

class DailyTimeline extends StatelessWidget {
  final List<Event> events;
  final DateTime date;
  final Function(Event)? onEventTap;
  final Function(Event event, DateTime newStartTime)? onEventRescheduled;

  const DailyTimeline({
    super.key,
    required this.events,
    required this.date,
    this.onEventTap,
    this.onEventRescheduled,
  });

  @override
  Widget build(BuildContext context) {
    // Configurações da Grid
    const double hourHeight = 80.0;
    const int startHour = 6; // Começando um pouco antes das 8h para dar margem
    const int endHour = 20; // Terminando um pouco depois das 19h

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          // Grade Horária com DragTargets
          Column(
            children: List.generate(endHour - startHour + 1, (index) {
              final hour = startHour + index;

              return DragTarget<Event>(
                onWillAcceptWithDetails: (data) => true,
                onAcceptWithDetails: (details) {
                  final event = details.data;
                  // Calcular nova hora de início
                  final newStartTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    hour,
                  );
                  // Notificar com a nova data. O handler pai deve atualizar o endTime baseado na duração se necessário,
                  // aqui passamos apenas o novo startTime, mas poderíamos passar o evento atualizado.
                  // Vamos passar o novo StartTime e deixar o pai recalcular o EndTime.
                  onEventRescheduled?.call(event, newStartTime);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: hourHeight,
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : null,
                      border: candidateData.isNotEmpty
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            )
                          : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Coluna da Hora
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${hour.toString().padLeft(2, '0')}:00',
                            textAlign: TextAlign.right,
                            style: AppTypography.caption.copyWith(
                              color: candidateData.isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey[500],
                              fontWeight: candidateData.isNotEmpty
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Linha Horizontal
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[200],
                            margin: const EdgeInsets.only(top: 8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Linha do tempo atual (se for hoje)
          if (date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day)
            Positioned(
              top:
                  _calculateTopOffset(DateTime.now(), startHour, hourHeight) +
                  8,
              left: 58,
              right: 0,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: Container(height: 2, color: Colors.red)),
                ],
              ),
            ),

          // Eventos Draggable
          ...events.map((event) {
            final top = _calculateTopOffset(
              event.startTime,
              startHour,
              hourHeight,
            );
            final height = _calculateHeight(
              event.startTime,
              event.endTime,
              hourHeight,
            );

            if (top < 0) return const SizedBox.shrink();

            return Positioned(
              top: top + 8,
              left: 60,
              right: 16,
              height: height > 20 ? height - 4 : 20,
              child: LongPressDraggable<Event>(
                data: event,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width -
                        92, // Largura aproximada
                    height: height > 20 ? height - 4 : 20,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(event.type).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      event.title,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildEventCard(event, height),
                ),
                child: GestureDetector(
                  onTap: () => onEventTap?.call(event),
                  child: _buildEventCard(event, height),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event, double height) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getTypeColor(event.type).withValues(alpha: 0.15),
        border: Border(
          left: BorderSide(color: _getTypeColor(event.type), width: 4),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.title,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (height > 40) ...[
            const SizedBox(height: 2),
            Text(
              '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateTopOffset(DateTime time, int startHour, double hourHeight) {
    final hourOffset = time.hour - startHour;
    final minuteFraction = time.minute / 60.0;
    return (hourOffset + minuteFraction) * hourHeight;
  }

  double _calculateHeight(DateTime start, DateTime end, double hourHeight) {
    final duration = end.difference(start).inMinutes;
    return (duration / 60.0) * hourHeight;
  }

  Color _getTypeColor(EventType type) {
    switch (type) {
      case EventType.technicalVisit:
        return AppColors.primary;
      case EventType.application:
        return AppColors.alert;
      case EventType.harvest:
        return AppColors.secondary;
      case EventType.meeting:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
