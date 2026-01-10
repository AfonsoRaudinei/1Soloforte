import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_history_model.dart';

class ClientHistoryTimeline extends StatelessWidget {
  final List<ClientHistory> history;
  final int? maxItems;
  final Function(ClientHistory)? onItemTap;

  const ClientHistoryTimeline({
    super.key,
    required this.history,
    this.maxItems,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayHistory = maxItems != null && history.length > maxItems!
        ? history.take(maxItems!).toList()
        : history;

    if (displayHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Nenhum histórico disponível',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayHistory.length,
      itemBuilder: (context, index) {
        final item = displayHistory[index];
        final isLast = index == displayHistory.length - 1;

        return _TimelineItem(
          history: item,
          isLast: isLast,
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ClientHistory history;
  final bool isLast;
  final VoidCallback? onTap;

  const _TimelineItem({
    required this.history,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconForActionType(history.actionType);
    final color = _getColorForActionType(history.actionType);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(iconData, color: color, size: 20),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  // Wrap for hit test behavior
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              history.description,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: onTap != null
                                    ? TextDecoration.underline
                                    : null, // Visual cue for link
                                decorationColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(history.timestamp),
                            style: AppTypography.caption.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      if (history.metadata != null &&
                          history.metadata!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: history.metadata!.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${entry.key}: ',
                                      style: AppTypography.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      entry.value.toString(),
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForActionType(String actionType) {
    switch (actionType) {
      case 'visit':
        return Icons.location_on;
      case 'occurrence':
        return Icons.warning;
      case 'report':
        return Icons.description;
      case 'call':
        return Icons.phone;
      case 'whatsapp':
        return Icons.chat;
      case 'email':
        return Icons.email;
      case 'created':
        return Icons.add_circle;
      case 'updated':
        return Icons.edit;
      default:
        return Icons.info;
    }
  }

  Color _getColorForActionType(String actionType) {
    switch (actionType) {
      case 'visit':
        return AppColors.primary;
      case 'occurrence':
        return AppColors.warning;
      case 'report':
        return AppColors.info;
      case 'call':
        return Colors.green;
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'email':
        return Colors.blue;
      case 'created':
        return AppColors.success;
      case 'updated':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Agora';
        }
        return '${difference.inMinutes}min atrás';
      }
      return '${difference.inHours}h atrás';
    } else if (difference.inDays == 1) {
      return 'Ontem às ${DateFormat.Hm().format(timestamp)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }
}
