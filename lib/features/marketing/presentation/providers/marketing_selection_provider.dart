import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketingSelectionState {
  final bool isSelecting;
  final String reportType; // 'case' or 'side_by_side'

  const MarketingSelectionState({
    this.isSelecting = false,
    this.reportType = 'case',
  });

  MarketingSelectionState copyWith({bool? isSelecting, String? reportType}) {
    return MarketingSelectionState(
      isSelecting: isSelecting ?? this.isSelecting,
      reportType: reportType ?? this.reportType,
    );
  }
}

final marketingSelectionProvider = StateProvider<MarketingSelectionState>((
  ref,
) {
  return const MarketingSelectionState();
});
