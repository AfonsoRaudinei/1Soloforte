import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/marketing/data/marketing_publication_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';

class MarketingPublicationSheetState {
  final MarketingPublication? selectedPublication;
  final bool isSheetOpen;
  final bool isSheetOpening;
  final bool isSheetClosing;
  final String? pendingPublicationId;

  const MarketingPublicationSheetState({
    this.selectedPublication,
    this.isSheetOpen = false,
    this.isSheetOpening = false,
    this.isSheetClosing = false,
    this.pendingPublicationId,
  });

  MarketingPublicationSheetState copyWith({
    MarketingPublication? selectedPublication,
    bool? isSheetOpen,
    bool? isSheetOpening,
    bool? isSheetClosing,
    String? pendingPublicationId,
    bool clearSelection = false,
    bool clearPending = false,
  }) {
    return MarketingPublicationSheetState(
      selectedPublication:
          clearSelection ? null : selectedPublication ?? this.selectedPublication,
      isSheetOpen: isSheetOpen ?? this.isSheetOpen,
      isSheetOpening: isSheetOpening ?? this.isSheetOpening,
      isSheetClosing: isSheetClosing ?? this.isSheetClosing,
      pendingPublicationId: clearPending
          ? null
          : pendingPublicationId ?? this.pendingPublicationId,
    );
  }
}

class MarketingPublicationSheetController
    extends StateNotifier<MarketingPublicationSheetState> {
  final Ref ref;
  Timer? _debounceTimer;
  String? _debouncePublicationId;
  static const Duration _debounceDuration = Duration(milliseconds: 280);

  MarketingPublicationSheetController(this.ref)
    : super(const MarketingPublicationSheetState());

  void selectById(String publicationId) {
    _debouncePublicationId = publicationId;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      final targetId = _debouncePublicationId;
      _debouncePublicationId = null;
      if (targetId == null) return;
      _processSelection(targetId);
    });
  }

  Future<void> _processSelection(String publicationId) async {
    if (state.isSheetOpening || state.isSheetClosing) {
      state = state.copyWith(pendingPublicationId: publicationId);
      return;
    }

    final repository = ref.read(marketingPublicationRepositoryProvider);
    final publication = await repository.getById(publicationId);
    if (publication == null) return;

    state = state.copyWith(
      selectedPublication: publication,
      clearPending: true,
    );
  }

  void markOpening() {
    state = state.copyWith(isSheetOpening: true, isSheetClosing: false);
  }

  void markOpened() {
    state = state.copyWith(isSheetOpen: true, isSheetOpening: false);
  }

  void markClosing() {
    if (!state.isSheetOpen) return;
    state = state.copyWith(isSheetClosing: true);
  }

  void markClosed() {
    state = state.copyWith(
      isSheetOpen: false,
      isSheetOpening: false,
      isSheetClosing: false,
      clearSelection: true,
    );
  }

  void applyPendingIfAny() {
    final pendingId = state.pendingPublicationId;
    if (pendingId == null) return;
    state = state.copyWith(clearPending: true);
    _processSelection(pendingId);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final marketingPublicationSheetProvider = StateNotifierProvider<
  MarketingPublicationSheetController,
  MarketingPublicationSheetState
>((ref) {
  return MarketingPublicationSheetController(ref);
});
