import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketingSelectionState {
  final bool isSelecting;

  const MarketingSelectionState({this.isSelecting = false});

  MarketingSelectionState copyWith({bool? isSelecting}) {
    return MarketingSelectionState(
      isSelecting: isSelecting ?? this.isSelecting,
    );
  }
}

final marketingSelectionProvider = StateProvider<MarketingSelectionState>((
  ref,
) {
  return const MarketingSelectionState();
});
