import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';

class OccurrenceSheetState {
  final Occurrence? selectedOccurrence;
  final bool isSheetOpen;
  final bool isSheetOpening;
  final bool isSheetClosing;
  final Occurrence? pendingOccurrence;

  const OccurrenceSheetState({
    this.selectedOccurrence,
    this.isSheetOpen = false,
    this.isSheetOpening = false,
    this.isSheetClosing = false,
    this.pendingOccurrence,
  });

  OccurrenceSheetState copyWith({
    Occurrence? selectedOccurrence,
    bool? isSheetOpen,
    bool? isSheetOpening,
    bool? isSheetClosing,
    Occurrence? pendingOccurrence,
    bool clearSelection = false,
    bool clearPending = false,
  }) {
    return OccurrenceSheetState(
      selectedOccurrence: clearSelection
          ? null
          : selectedOccurrence ?? this.selectedOccurrence,
      isSheetOpen: isSheetOpen ?? this.isSheetOpen,
      isSheetOpening: isSheetOpening ?? this.isSheetOpening,
      isSheetClosing: isSheetClosing ?? this.isSheetClosing,
      pendingOccurrence: clearPending
          ? null
          : pendingOccurrence ?? this.pendingOccurrence,
    );
  }
}

class OccurrenceSheetController extends StateNotifier<OccurrenceSheetState> {
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 200);

  OccurrenceSheetController() : super(const OccurrenceSheetState());

  void select(Occurrence occurrence) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _processSelection(occurrence);
    });
  }

  void _processSelection(Occurrence occurrence) {
    if (state.isSheetOpening || state.isSheetClosing) {
      state = state.copyWith(pendingOccurrence: occurrence);
      return;
    }

    state = state.copyWith(selectedOccurrence: occurrence, clearPending: true);
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
    final pending = state.pendingOccurrence;
    if (pending == null) return;
    state = state.copyWith(clearPending: true);
    _processSelection(pending);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final occurrenceSheetProvider =
    StateNotifierProvider<OccurrenceSheetController, OccurrenceSheetState>((
      ref,
    ) {
      return OccurrenceSheetController();
    });
