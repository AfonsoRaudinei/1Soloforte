import 'package:freezed_annotation/freezed_annotation.dart';

part 'comparison_item.freezed.dart';
part 'comparison_item.g.dart';

/// Represents a single comparison item in a dynamic comparison set.
/// This replaces the fixed "before/after" binary model with a flexible
/// container that supports multiple items with custom labels.
@freezed
class ComparisonItem with _$ComparisonItem {
  const factory ComparisonItem({
    /// Unique identifier for this comparison item
    required String id,

    /// Editable label (e.g., "Padrão Fazenda", "Produto Teste", "Tratamento A", etc.)
    /// NOT fixed to "Antes" or "Depois"
    required String label,

    /// Dynamic list of image paths (0, 1, or many images)
    @Default([]) List<String> imagePaths,

    /// Associated metrics
    @Default(null) double? productivity,
    @Default(null) double? ndvi,
    @Default(null) double? biomass,

    /// Productivity unit (sc/ha, ton/ha, kg/ha)
    @Default('sc/ha') String productivityUnit,

    /// Order/position in the comparison set
    @Default(0) int order,

    /// Optional notes specific to this item
    @Default(null) String? notes,

    /// Optional color for visual distinction in UI
    @Default(null) String? color,
  }) = _ComparisonItem;

  factory ComparisonItem.fromJson(Map<String, dynamic> json) =>
      _$ComparisonItemFromJson(json);
}

/// Represents a complete comparison set containing multiple ComparisonItems.
/// This is the SOURCE OF TRUTH for comparison data.
@freezed
class ComparisonSet with _$ComparisonSet {
  const ComparisonSet._();

  const factory ComparisonSet({
    /// List of comparison items (dynamic, not fixed to 2)
    @Default([]) List<ComparisonItem> items,

    /// Optional title for the entire comparison
    @Default(null) String? title,

    /// General notes for the comparison
    @Default(null) String? notes,

    /// Type of comparison for categorization
    /// e.g., 'product', 'treatment', 'farm_standard', 'before_after', 'custom'
    @Default('custom') String comparisonType,
  }) = _ComparisonSet;

  factory ComparisonSet.fromJson(Map<String, dynamic> json) =>
      _$ComparisonSetFromJson(json);

  /// Calculate gain between two items by index
  /// Returns percentage difference: (itemB - itemA) / itemA * 100
  double calculateGain({
    required int indexA,
    required int indexB,
    required String metric, // 'productivity', 'ndvi', 'biomass'
  }) {
    if (indexA < 0 ||
        indexA >= items.length ||
        indexB < 0 ||
        indexB >= items.length) {
      return 0;
    }

    final itemA = items[indexA];
    final itemB = items[indexB];

    double? valueA;
    double? valueB;

    switch (metric) {
      case 'productivity':
        valueA = itemA.productivity;
        valueB = itemB.productivity;
        break;
      case 'ndvi':
        valueA = itemA.ndvi;
        valueB = itemB.ndvi;
        break;
      case 'biomass':
        valueA = itemA.biomass;
        valueB = itemB.biomass;
        break;
    }

    if (valueA == null || valueB == null || valueA == 0) {
      return 0;
    }

    return ((valueB - valueA) / valueA) * 100;
  }

  /// Convenience method to get gain between first two items (backward compatible)
  double get productivityGain => items.length >= 2
      ? calculateGain(indexA: 0, indexB: 1, metric: 'productivity')
      : 0;

  double get ndviGain => items.length >= 2
      ? calculateGain(indexA: 0, indexB: 1, metric: 'ndvi')
      : 0;

  double get biomassGain => items.length >= 2
      ? calculateGain(indexA: 0, indexB: 1, metric: 'biomass')
      : 0;

  /// Check if the comparison set has minimum required data
  bool get isComplete =>
      items.length >= 2 && items.every((item) => item.imagePaths.isNotEmpty);

  /// Check if any item has productivity data
  bool get hasProductivityData =>
      items.any((item) => item.productivity != null);

  /// Check if any item has NDVI data
  bool get hasNdviData => items.any((item) => item.ndvi != null);

  /// Check if any item has biomass data
  bool get hasBiomassData => items.any((item) => item.biomass != null);
}

/// Predefined comparison templates for quick setup
class ComparisonTemplates {
  static ComparisonSet beforeAfter() => ComparisonSet(
    comparisonType: 'before_after',
    items: [
      ComparisonItem(id: 'item_1', label: 'Antes', order: 0),
      ComparisonItem(id: 'item_2', label: 'Depois', order: 1),
    ],
  );

  static ComparisonSet productComparison() => ComparisonSet(
    comparisonType: 'product',
    items: [
      ComparisonItem(id: 'item_1', label: 'Testemunha', order: 0),
      ComparisonItem(id: 'item_2', label: 'Produto Teste', order: 1),
    ],
  );

  static ComparisonSet treatmentComparison() => ComparisonSet(
    comparisonType: 'treatment',
    items: [
      ComparisonItem(id: 'item_1', label: 'Controle', order: 0),
      ComparisonItem(id: 'item_2', label: 'Tratamento A', order: 1),
    ],
  );

  static ComparisonSet farmStandardComparison() => ComparisonSet(
    comparisonType: 'farm_standard',
    items: [
      ComparisonItem(id: 'item_1', label: 'Padrão Fazenda', order: 0),
      ComparisonItem(id: 'item_2', label: 'Recomendação Técnica', order: 1),
    ],
  );

  static ComparisonSet multiTreatment({int count = 3}) => ComparisonSet(
    comparisonType: 'multi_treatment',
    items: List.generate(
      count,
      (i) => ComparisonItem(
        id: 'item_${i + 1}',
        label: i == 0
            ? 'Controle'
            : 'Tratamento ${String.fromCharCode(65 + i - 1)}',
        order: i,
      ),
    ),
  );

  /// Create empty comparison set
  static ComparisonSet empty() => const ComparisonSet();

  /// Create custom comparison with N items
  static ComparisonSet custom({
    required int itemCount,
    String type = 'custom',
  }) => ComparisonSet(
    comparisonType: type,
    items: List.generate(
      itemCount,
      (i) =>
          ComparisonItem(id: 'item_${i + 1}', label: 'Item ${i + 1}', order: i),
    ),
  );
}
