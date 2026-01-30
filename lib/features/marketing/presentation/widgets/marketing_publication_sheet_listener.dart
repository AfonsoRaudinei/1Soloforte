/// 🚨 MAPA CANÔNICO — PREVIEW (GATILHO)
///
/// Este widget escuta o provider e DISPARA o [showModalBottomSheet].
/// É aqui que o preview "nasce".
///
/// ⚠️ NÃO É UMA ROTA DE NAVEGAÇÃO.
/// É um listener que injeta o Bottom Sheet no overlay do mapa.
///
/// O CTA (Botão Secundário) aqui definido é quem faz o `context.push`
/// para a rota real de edição (/map/marketing/edit).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_publication_sheet_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_publication_bottom_sheet.dart';
import 'package:soloforte_app/features/marketing/presentation/services/marketing_interaction_tracker.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/marketing_public_preview_bottom_sheet.dart';

class MarketingPublicationSheetListener extends ConsumerStatefulWidget {
  final bool isPublicPreview;

  const MarketingPublicationSheetListener({
    super.key,
    this.isPublicPreview = false,
  });

  @override
  ConsumerState<MarketingPublicationSheetListener> createState() =>
      _MarketingPublicationSheetListenerState();
}

class _MarketingPublicationSheetListenerState
    extends ConsumerState<MarketingPublicationSheetListener> {
  bool _dismissedByDrag = false;

  Future<void> _openSheet(MarketingPublication publication) async {
    final controller = ref.read(marketingPublicationSheetProvider.notifier);
    _dismissedByDrag = false;
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
          minChildSize: 0.2,
          maxChildSize: 0.88,
          builder: (_, scrollController) {
            // 🎨 UX CANÔNICA (Comportamento do Container)
            //
            // PADRÃO IOS MAPS:
            // 1. Initial Child Size (Peek): ~32% (Espaço suficiente para Título + Imagem + CTA)
            // 2. Max Child Size (Expanded): ~88% (Quase tela cheia, topo visível)
            // 3. Min Child Size (Closed/Min): ~25%
            //
            // COMPORTAMENTO:
            // - Drag up -> Expande
            // - Drag down -> Fecha (ou minimiza)
            // - Handle Bar -> Sempre visível para indicar arraste
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

                        if (widget.isPublicPreview) {
                          return MarketingPublicPreviewBottomSheet(
                            publication: selected,
                            onClose: () {
                              controller.markClosing();
                              Navigator.of(ctx).pop();
                            },
                            onLogin: () {
                              MarketingInteractionTracker.ctaClicked(
                                publicationId: selected.id,
                              );
                              context.go('/login');
                            },
                          );
                        }

                        // Obter ID do usuário atual para validação de permissões
                        final authState =
                            ref.watch(authStateProvider).valueOrNull;
                        final currentUserId = authState?.userId;

                        return MarketingPublicationBottomSheet(
                          publication: selected,
                          currentUserId: currentUserId,
                          onClose: () {
                            controller.markClosing();
                            Navigator.of(ctx).pop();
                          },
                          // Ação "Ver detalhes" - modo somente leitura para todos
                          onViewDetails: () {
                            MarketingInteractionTracker.ctaClicked(
                              publicationId: selected.id,
                            );
                            context.push('/map/marketing/edit?id=${selected.id}');
                          },
                          // Ação "Editar" - apenas para o autor
                          onEdit: () {
                            MarketingInteractionTracker.ctaClicked(
                              publicationId: selected.id,
                            );
                            context.push('/map/marketing/edit?id=${selected.id}');
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
