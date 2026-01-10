// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeoArea _$GeoAreaFromJson(Map<String, dynamic> json) {
  return _GeoArea.fromJson(json);
}

/// @nodoc
mixin _$GeoArea {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<LatLng> get points => throw _privateConstructorUsedError;
  List<List<LatLng>> get holes => throw _privateConstructorUsedError;
  double get areaHectares => throw _privateConstructorUsedError;
  double get perimeterKm => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  LatLng? get center => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // polygon, circle, rectangle
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GeoArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoAreaCopyWith<GeoArea> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoAreaCopyWith<$Res> {
  factory $GeoAreaCopyWith(GeoArea value, $Res Function(GeoArea) then) =
      _$GeoAreaCopyWithImpl<$Res, GeoArea>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> points,
    List<List<LatLng>> holes,
    double areaHectares,
    double perimeterKm,
    double radius,
    LatLng? center,
    String type,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$GeoAreaCopyWithImpl<$Res, $Val extends GeoArea>
    implements $GeoAreaCopyWith<$Res> {
  _$GeoAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? points = null,
    Object? holes = null,
    Object? areaHectares = null,
    Object? perimeterKm = null,
    Object? radius = null,
    Object? center = freezed,
    Object? type = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            holes: null == holes
                ? _value.holes
                : holes // ignore: cast_nullable_to_non_nullable
                      as List<List<LatLng>>,
            areaHectares: null == areaHectares
                ? _value.areaHectares
                : areaHectares // ignore: cast_nullable_to_non_nullable
                      as double,
            perimeterKm: null == perimeterKm
                ? _value.perimeterKm
                : perimeterKm // ignore: cast_nullable_to_non_nullable
                      as double,
            radius: null == radius
                ? _value.radius
                : radius // ignore: cast_nullable_to_non_nullable
                      as double,
            center: freezed == center
                ? _value.center
                : center // ignore: cast_nullable_to_non_nullable
                      as LatLng?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeoAreaImplCopyWith<$Res> implements $GeoAreaCopyWith<$Res> {
  factory _$$GeoAreaImplCopyWith(
    _$GeoAreaImpl value,
    $Res Function(_$GeoAreaImpl) then,
  ) = __$$GeoAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> points,
    List<List<LatLng>> holes,
    double areaHectares,
    double perimeterKm,
    double radius,
    LatLng? center,
    String type,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$GeoAreaImplCopyWithImpl<$Res>
    extends _$GeoAreaCopyWithImpl<$Res, _$GeoAreaImpl>
    implements _$$GeoAreaImplCopyWith<$Res> {
  __$$GeoAreaImplCopyWithImpl(
    _$GeoAreaImpl _value,
    $Res Function(_$GeoAreaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeoArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? points = null,
    Object? holes = null,
    Object? areaHectares = null,
    Object? perimeterKm = null,
    Object? radius = null,
    Object? center = freezed,
    Object? type = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GeoAreaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value._points
            : points // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        holes: null == holes
            ? _value._holes
            : holes // ignore: cast_nullable_to_non_nullable
                  as List<List<LatLng>>,
        areaHectares: null == areaHectares
            ? _value.areaHectares
            : areaHectares // ignore: cast_nullable_to_non_nullable
                  as double,
        perimeterKm: null == perimeterKm
            ? _value.perimeterKm
            : perimeterKm // ignore: cast_nullable_to_non_nullable
                  as double,
        radius: null == radius
            ? _value.radius
            : radius // ignore: cast_nullable_to_non_nullable
                  as double,
        center: freezed == center
            ? _value.center
            : center // ignore: cast_nullable_to_non_nullable
                  as LatLng?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoAreaImpl implements _GeoArea {
  const _$GeoAreaImpl({
    required this.id,
    required this.name,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<LatLng> points = const [],
    final List<List<LatLng>> holes = const [],
    this.areaHectares = 0.0,
    this.perimeterKm = 0.0,
    this.radius = 0.0,
    this.center,
    this.type = 'polygon',
    this.createdAt,
  }) : _points = points,
       _holes = holes;

  factory _$GeoAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoAreaImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  // ignore: invalid_annotation_target
  final List<LatLng> _points;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<LatLng> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  final List<List<LatLng>> _holes;
  @override
  @JsonKey()
  List<List<LatLng>> get holes {
    if (_holes is EqualUnmodifiableListView) return _holes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_holes);
  }

  @override
  @JsonKey()
  final double areaHectares;
  @override
  @JsonKey()
  final double perimeterKm;
  @override
  @JsonKey()
  final double radius;
  @override
  final LatLng? center;
  @override
  @JsonKey()
  final String type;
  // polygon, circle, rectangle
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GeoArea(id: $id, name: $name, points: $points, holes: $holes, areaHectares: $areaHectares, perimeterKm: $perimeterKm, radius: $radius, center: $center, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoAreaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            const DeepCollectionEquality().equals(other._holes, _holes) &&
            (identical(other.areaHectares, areaHectares) ||
                other.areaHectares == areaHectares) &&
            (identical(other.perimeterKm, perimeterKm) ||
                other.perimeterKm == perimeterKm) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_points),
    const DeepCollectionEquality().hash(_holes),
    areaHectares,
    perimeterKm,
    radius,
    center,
    type,
    createdAt,
  );

  /// Create a copy of GeoArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoAreaImplCopyWith<_$GeoAreaImpl> get copyWith =>
      __$$GeoAreaImplCopyWithImpl<_$GeoAreaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoAreaImplToJson(this);
  }
}

abstract class _GeoArea implements GeoArea {
  const factory _GeoArea({
    required final String id,
    required final String name,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<LatLng> points,
    final List<List<LatLng>> holes,
    final double areaHectares,
    final double perimeterKm,
    final double radius,
    final LatLng? center,
    final String type,
    final DateTime? createdAt,
  }) = _$GeoAreaImpl;

  factory _GeoArea.fromJson(Map<String, dynamic> json) = _$GeoAreaImpl.fromJson;

  @override
  String get id;
  @override
  String get name; // ignore: invalid_annotation_target
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<LatLng> get points;
  @override
  List<List<LatLng>> get holes;
  @override
  double get areaHectares;
  @override
  double get perimeterKm;
  @override
  double get radius;
  @override
  LatLng? get center;
  @override
  String get type; // polygon, circle, rectangle
  @override
  DateTime? get createdAt;

  /// Create a copy of GeoArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoAreaImplCopyWith<_$GeoAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
