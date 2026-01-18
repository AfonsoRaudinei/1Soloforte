// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comparison_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ComparisonItem _$ComparisonItemFromJson(Map<String, dynamic> json) {
  return _ComparisonItem.fromJson(json);
}

/// @nodoc
mixin _$ComparisonItem {
  /// Unique identifier for this comparison item
  String get id => throw _privateConstructorUsedError;

  /// Editable label (e.g., "Padrão Fazenda", "Produto Teste", "Tratamento A", etc.)
  /// NOT fixed to "Antes" or "Depois"
  String get label => throw _privateConstructorUsedError;

  /// Dynamic list of image paths (0, 1, or many images)
  List<String> get imagePaths => throw _privateConstructorUsedError;

  /// Associated metrics
  double? get productivity => throw _privateConstructorUsedError;
  double? get ndvi => throw _privateConstructorUsedError;
  double? get biomass => throw _privateConstructorUsedError;

  /// Productivity unit (sc/ha, ton/ha, kg/ha)
  String get productivityUnit => throw _privateConstructorUsedError;

  /// Order/position in the comparison set
  int get order => throw _privateConstructorUsedError;

  /// Optional notes specific to this item
  String? get notes => throw _privateConstructorUsedError;

  /// Optional color for visual distinction in UI
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this ComparisonItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonItemCopyWith<ComparisonItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonItemCopyWith<$Res> {
  factory $ComparisonItemCopyWith(
    ComparisonItem value,
    $Res Function(ComparisonItem) then,
  ) = _$ComparisonItemCopyWithImpl<$Res, ComparisonItem>;
  @useResult
  $Res call({
    String id,
    String label,
    List<String> imagePaths,
    double? productivity,
    double? ndvi,
    double? biomass,
    String productivityUnit,
    int order,
    String? notes,
    String? color,
  });
}

/// @nodoc
class _$ComparisonItemCopyWithImpl<$Res, $Val extends ComparisonItem>
    implements $ComparisonItemCopyWith<$Res> {
  _$ComparisonItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? imagePaths = null,
    Object? productivity = freezed,
    Object? ndvi = freezed,
    Object? biomass = freezed,
    Object? productivityUnit = null,
    Object? order = null,
    Object? notes = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            imagePaths: null == imagePaths
                ? _value.imagePaths
                : imagePaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            productivity: freezed == productivity
                ? _value.productivity
                : productivity // ignore: cast_nullable_to_non_nullable
                      as double?,
            ndvi: freezed == ndvi
                ? _value.ndvi
                : ndvi // ignore: cast_nullable_to_non_nullable
                      as double?,
            biomass: freezed == biomass
                ? _value.biomass
                : biomass // ignore: cast_nullable_to_non_nullable
                      as double?,
            productivityUnit: null == productivityUnit
                ? _value.productivityUnit
                : productivityUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComparisonItemImplCopyWith<$Res>
    implements $ComparisonItemCopyWith<$Res> {
  factory _$$ComparisonItemImplCopyWith(
    _$ComparisonItemImpl value,
    $Res Function(_$ComparisonItemImpl) then,
  ) = __$$ComparisonItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    List<String> imagePaths,
    double? productivity,
    double? ndvi,
    double? biomass,
    String productivityUnit,
    int order,
    String? notes,
    String? color,
  });
}

/// @nodoc
class __$$ComparisonItemImplCopyWithImpl<$Res>
    extends _$ComparisonItemCopyWithImpl<$Res, _$ComparisonItemImpl>
    implements _$$ComparisonItemImplCopyWith<$Res> {
  __$$ComparisonItemImplCopyWithImpl(
    _$ComparisonItemImpl _value,
    $Res Function(_$ComparisonItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComparisonItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? imagePaths = null,
    Object? productivity = freezed,
    Object? ndvi = freezed,
    Object? biomass = freezed,
    Object? productivityUnit = null,
    Object? order = null,
    Object? notes = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _$ComparisonItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        imagePaths: null == imagePaths
            ? _value._imagePaths
            : imagePaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        productivity: freezed == productivity
            ? _value.productivity
            : productivity // ignore: cast_nullable_to_non_nullable
                  as double?,
        ndvi: freezed == ndvi
            ? _value.ndvi
            : ndvi // ignore: cast_nullable_to_non_nullable
                  as double?,
        biomass: freezed == biomass
            ? _value.biomass
            : biomass // ignore: cast_nullable_to_non_nullable
                  as double?,
        productivityUnit: null == productivityUnit
            ? _value.productivityUnit
            : productivityUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonItemImpl implements _ComparisonItem {
  const _$ComparisonItemImpl({
    required this.id,
    required this.label,
    final List<String> imagePaths = const [],
    this.productivity = null,
    this.ndvi = null,
    this.biomass = null,
    this.productivityUnit = 'sc/ha',
    this.order = 0,
    this.notes = null,
    this.color = null,
  }) : _imagePaths = imagePaths;

  factory _$ComparisonItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonItemImplFromJson(json);

  /// Unique identifier for this comparison item
  @override
  final String id;

  /// Editable label (e.g., "Padrão Fazenda", "Produto Teste", "Tratamento A", etc.)
  /// NOT fixed to "Antes" or "Depois"
  @override
  final String label;

  /// Dynamic list of image paths (0, 1, or many images)
  final List<String> _imagePaths;

  /// Dynamic list of image paths (0, 1, or many images)
  @override
  @JsonKey()
  List<String> get imagePaths {
    if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imagePaths);
  }

  /// Associated metrics
  @override
  @JsonKey()
  final double? productivity;
  @override
  @JsonKey()
  final double? ndvi;
  @override
  @JsonKey()
  final double? biomass;

  /// Productivity unit (sc/ha, ton/ha, kg/ha)
  @override
  @JsonKey()
  final String productivityUnit;

  /// Order/position in the comparison set
  @override
  @JsonKey()
  final int order;

  /// Optional notes specific to this item
  @override
  @JsonKey()
  final String? notes;

  /// Optional color for visual distinction in UI
  @override
  @JsonKey()
  final String? color;

  @override
  String toString() {
    return 'ComparisonItem(id: $id, label: $label, imagePaths: $imagePaths, productivity: $productivity, ndvi: $ndvi, biomass: $biomass, productivityUnit: $productivityUnit, order: $order, notes: $notes, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(
              other._imagePaths,
              _imagePaths,
            ) &&
            (identical(other.productivity, productivity) ||
                other.productivity == productivity) &&
            (identical(other.ndvi, ndvi) || other.ndvi == ndvi) &&
            (identical(other.biomass, biomass) || other.biomass == biomass) &&
            (identical(other.productivityUnit, productivityUnit) ||
                other.productivityUnit == productivityUnit) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    const DeepCollectionEquality().hash(_imagePaths),
    productivity,
    ndvi,
    biomass,
    productivityUnit,
    order,
    notes,
    color,
  );

  /// Create a copy of ComparisonItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonItemImplCopyWith<_$ComparisonItemImpl> get copyWith =>
      __$$ComparisonItemImplCopyWithImpl<_$ComparisonItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonItemImplToJson(this);
  }
}

abstract class _ComparisonItem implements ComparisonItem {
  const factory _ComparisonItem({
    required final String id,
    required final String label,
    final List<String> imagePaths,
    final double? productivity,
    final double? ndvi,
    final double? biomass,
    final String productivityUnit,
    final int order,
    final String? notes,
    final String? color,
  }) = _$ComparisonItemImpl;

  factory _ComparisonItem.fromJson(Map<String, dynamic> json) =
      _$ComparisonItemImpl.fromJson;

  /// Unique identifier for this comparison item
  @override
  String get id;

  /// Editable label (e.g., "Padrão Fazenda", "Produto Teste", "Tratamento A", etc.)
  /// NOT fixed to "Antes" or "Depois"
  @override
  String get label;

  /// Dynamic list of image paths (0, 1, or many images)
  @override
  List<String> get imagePaths;

  /// Associated metrics
  @override
  double? get productivity;
  @override
  double? get ndvi;
  @override
  double? get biomass;

  /// Productivity unit (sc/ha, ton/ha, kg/ha)
  @override
  String get productivityUnit;

  /// Order/position in the comparison set
  @override
  int get order;

  /// Optional notes specific to this item
  @override
  String? get notes;

  /// Optional color for visual distinction in UI
  @override
  String? get color;

  /// Create a copy of ComparisonItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonItemImplCopyWith<_$ComparisonItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComparisonSet _$ComparisonSetFromJson(Map<String, dynamic> json) {
  return _ComparisonSet.fromJson(json);
}

/// @nodoc
mixin _$ComparisonSet {
  /// List of comparison items (dynamic, not fixed to 2)
  List<ComparisonItem> get items => throw _privateConstructorUsedError;

  /// Optional title for the entire comparison
  String? get title => throw _privateConstructorUsedError;

  /// General notes for the comparison
  String? get notes => throw _privateConstructorUsedError;

  /// Type of comparison for categorization
  /// e.g., 'product', 'treatment', 'farm_standard', 'before_after', 'custom'
  String get comparisonType => throw _privateConstructorUsedError;

  /// Serializes this ComparisonSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonSetCopyWith<ComparisonSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonSetCopyWith<$Res> {
  factory $ComparisonSetCopyWith(
    ComparisonSet value,
    $Res Function(ComparisonSet) then,
  ) = _$ComparisonSetCopyWithImpl<$Res, ComparisonSet>;
  @useResult
  $Res call({
    List<ComparisonItem> items,
    String? title,
    String? notes,
    String comparisonType,
  });
}

/// @nodoc
class _$ComparisonSetCopyWithImpl<$Res, $Val extends ComparisonSet>
    implements $ComparisonSetCopyWith<$Res> {
  _$ComparisonSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? title = freezed,
    Object? notes = freezed,
    Object? comparisonType = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ComparisonItem>,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            comparisonType: null == comparisonType
                ? _value.comparisonType
                : comparisonType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComparisonSetImplCopyWith<$Res>
    implements $ComparisonSetCopyWith<$Res> {
  factory _$$ComparisonSetImplCopyWith(
    _$ComparisonSetImpl value,
    $Res Function(_$ComparisonSetImpl) then,
  ) = __$$ComparisonSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ComparisonItem> items,
    String? title,
    String? notes,
    String comparisonType,
  });
}

/// @nodoc
class __$$ComparisonSetImplCopyWithImpl<$Res>
    extends _$ComparisonSetCopyWithImpl<$Res, _$ComparisonSetImpl>
    implements _$$ComparisonSetImplCopyWith<$Res> {
  __$$ComparisonSetImplCopyWithImpl(
    _$ComparisonSetImpl _value,
    $Res Function(_$ComparisonSetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComparisonSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? title = freezed,
    Object? notes = freezed,
    Object? comparisonType = null,
  }) {
    return _then(
      _$ComparisonSetImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ComparisonItem>,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        comparisonType: null == comparisonType
            ? _value.comparisonType
            : comparisonType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonSetImpl extends _ComparisonSet {
  const _$ComparisonSetImpl({
    final List<ComparisonItem> items = const [],
    this.title = null,
    this.notes = null,
    this.comparisonType = 'custom',
  }) : _items = items,
       super._();

  factory _$ComparisonSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonSetImplFromJson(json);

  /// List of comparison items (dynamic, not fixed to 2)
  final List<ComparisonItem> _items;

  /// List of comparison items (dynamic, not fixed to 2)
  @override
  @JsonKey()
  List<ComparisonItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Optional title for the entire comparison
  @override
  @JsonKey()
  final String? title;

  /// General notes for the comparison
  @override
  @JsonKey()
  final String? notes;

  /// Type of comparison for categorization
  /// e.g., 'product', 'treatment', 'farm_standard', 'before_after', 'custom'
  @override
  @JsonKey()
  final String comparisonType;

  @override
  String toString() {
    return 'ComparisonSet(items: $items, title: $title, notes: $notes, comparisonType: $comparisonType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonSetImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.comparisonType, comparisonType) ||
                other.comparisonType == comparisonType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    title,
    notes,
    comparisonType,
  );

  /// Create a copy of ComparisonSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonSetImplCopyWith<_$ComparisonSetImpl> get copyWith =>
      __$$ComparisonSetImplCopyWithImpl<_$ComparisonSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonSetImplToJson(this);
  }
}

abstract class _ComparisonSet extends ComparisonSet {
  const factory _ComparisonSet({
    final List<ComparisonItem> items,
    final String? title,
    final String? notes,
    final String comparisonType,
  }) = _$ComparisonSetImpl;
  const _ComparisonSet._() : super._();

  factory _ComparisonSet.fromJson(Map<String, dynamic> json) =
      _$ComparisonSetImpl.fromJson;

  /// List of comparison items (dynamic, not fixed to 2)
  @override
  List<ComparisonItem> get items;

  /// Optional title for the entire comparison
  @override
  String? get title;

  /// General notes for the comparison
  @override
  String? get notes;

  /// Type of comparison for categorization
  /// e.g., 'product', 'treatment', 'farm_standard', 'before_after', 'custom'
  @override
  String get comparisonType;

  /// Create a copy of ComparisonSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonSetImplCopyWith<_$ComparisonSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
