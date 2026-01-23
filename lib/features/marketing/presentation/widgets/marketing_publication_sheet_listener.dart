import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_publication_sheet_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_publication_bottom_sheet.dart';
import 'package:soloforte_app/features/marketing/presentation/services/marketing_interaction_tracker.dart';

class MarketingPublicationSheetListener extends ConsumerStatefulWidget {
  const MarketingPublicationSheetListener({super.key});

  @override
  ConsumerState<MarketingPublicationSheetListener> createState() =>
      _MarketingPublicationSheetListenerState();
}

class _MarketingPublicationSheetListenerState
    extends ConsumerState<MarketingPublicationSheetListener> {
  Future<void> _openSheet(MarketingPublication publication) async {
    final controller = ref.read(marketingPublicationSheetProvider.notifier);
    controller.markOpening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markOpened();
      MarketingInteractionTracker.sheetOpened(publicationId: publication.id);
      controller.applyPendingIfAny();
    });
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.32,
          minChildSize: 0.25,
          maxChildSize: 0.88,
          builder: (_, scrollController) {
            return Container(
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
                child: PrimaryScrollController(
                  controller: scrollController,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(
                        marketingPublicationSheetProvider,
                      );
                      final selected = state.selectedPublication;
                      if (selected == null) {
                        return const SizedBox.shrink();
                      }
                      return MarketingPublicationBottomSheet(
                        publication: selected,
                        onClose: () {
                          controller.markClosing();
                          Navigator.of(ctx).pop();
                        },
                        onSecondaryAction: () {
                          MarketingInteractionTracker.ctaClicked(
                            publicationId: selected.id,
                          );
                          // Navegar para tela de edição completa (iOS Maps pattern)
                          context.push('/map/marketing/edit?id=${selected.id}');
                        },
                        secondaryActionLabel: 'Ver case completo',
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    controller.markClosed();
    MarketingInteractionTracker.sheetClosed(publicationId: publication.id);
    controller.applyPendingIfAny();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MarketingPublicationSheetState>(
      marketingPublicationSheetProvider,
      (previous, next) {
        if (next.selectedPublication == null ||
            next.isSheetOpen ||
            next.isSheetOpening ||
            next.isSheetClosing) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openSheet(next.selectedPublication!);
        });
      },
    );

    return const SizedBox.shrink();
  }
}
