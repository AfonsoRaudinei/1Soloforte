import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_sheet_provider.dart';
import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_preview_bottom_sheet.dart';

class OccurrenceSheetListener extends ConsumerStatefulWidget {
  const OccurrenceSheetListener({super.key});

  @override
  ConsumerState<OccurrenceSheetListener> createState() =>
      _OccurrenceSheetListenerState();
}

class _OccurrenceSheetListenerState
    extends ConsumerState<OccurrenceSheetListener> {
  bool _dismissedByDrag = false;

  Future<void> _openSheet(Occurrence occurrence) async {
    final controller = ref.read(occurrenceSheetProvider.notifier);
    _dismissedByDrag = false;
    controller.markOpening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markOpened();
      controller.applyPendingIfAny();
    });

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.32,
          minChildSize: 0.2,
          maxChildSize: 0.88,
          expand: false,
          builder: (_, scrollController) {
            return NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                final minExtent = notification.minExtent;
                if (!_dismissedByDrag &&
                    notification.extent <= minExtent + 0.001) {
                  _dismissedByDrag = true;
                  controller.markClosing();
                  Navigator.of(ctx).pop();
                }
                return false;
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(occurrenceSheetProvider);
                        final selected = state.selectedOccurrence;
                        if (selected == null) {
                          return const SizedBox.shrink();
                        }

                        return OccurrencePreviewBottomSheet(
                          occurrence: selected,
                          onClose: () {
                            controller.markClosing();
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    controller.markClosed();
    controller.applyPendingIfAny();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OccurrenceSheetState>(occurrenceSheetProvider, (previous, next) {
      if (next.selectedOccurrence == null ||
          next.isSheetOpen ||
          next.isSheetOpening ||
          next.isSheetClosing) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openSheet(next.selectedOccurrence!);
      });
    });

    return const SizedBox.shrink();
  }
}
