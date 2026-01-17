// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AreaDto _$AreaDtoFromJson(Map<String, dynamic> json) {
  return _AreaDto.fromJson(json);
}

/// @nodoc
mixin _$AreaDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get hectares => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String get clientId => throw _privateConstructorUsedError;
  String get clienteNome => throw _privateConstructorUsedError;
  String get fazendaNome => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
  List<LatLng> get coordinates => throw _privateConstructorUsedError;
  String? get culture => throw _privateConstructorUsedError;
  String? get safra => throw _privateConstructorUsedError;
  double get ndviAverage => throw _privateConstructorUsedError;
  DateTime? get lastUpdate => throw _privateConstructorUsedError;

  /// Serializes this AreaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AreaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AreaDtoCopyWith<AreaDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaDtoCopyWith<$Res> {
  factory $AreaDtoCopyWith(AreaDto value, $Res Function(AreaDto) then) =
      _$AreaDtoCopyWithImpl<$Res, AreaDto>;
  @useResult
  $Res call({
    String id,
    String name,
    double hectares,
    @JsonKey(defaultValue: '') String clientId,
    String clienteNome,
    String fazendaNome,
    String status,
    @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
    List<LatLng> coordinates,
    String? culture,
    String? safra,
    double ndviAverage,
    DateTime? lastUpdate,
  });
}

/// @nodoc
class _$AreaDtoCopyWithImpl<$Res, $Val extends AreaDto>
    implements $AreaDtoCopyWith<$Res> {
  _$AreaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AreaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hectares = null,
    Object? clientId = null,
    Object? clienteNome = null,
    Object? fazendaNome = null,
    Object? status = null,
    Object? coordinates = null,
    Object? culture = freezed,
    Object? safra = freezed,
    Object? ndviAverage = null,
    Object? lastUpdate = freezed,
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
            hectares: null == hectares
                ? _value.hectares
                : hectares // ignore: cast_nullable_to_non_nullable
                      as double,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            clienteNome: null == clienteNome
                ? _value.clienteNome
                : clienteNome // ignore: cast_nullable_to_non_nullable
                      as String,
            fazendaNome: null == fazendaNome
                ? _value.fazendaNome
                : fazendaNome // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            coordinates: null == coordinates
                ? _value.coordinates
                : coordinates // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            culture: freezed == culture
                ? _value.culture
                : culture // ignore: cast_nullable_to_non_nullable
                      as String?,
            safra: freezed == safra
                ? _value.safra
                : safra // ignore: cast_nullable_to_non_nullable
                      as String?,
            ndviAverage: null == ndviAverage
                ? _value.ndviAverage
                : ndviAverage // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdate: freezed == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AreaDtoImplCopyWith<$Res> implements $AreaDtoCopyWith<$Res> {
  factory _$$AreaDtoImplCopyWith(
    _$AreaDtoImpl value,
    $Res Function(_$AreaDtoImpl) then,
  ) = __$$AreaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double hectares,
    @JsonKey(defaultValue: '') String clientId,
    String clienteNome,
    String fazendaNome,
    String status,
    @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
    List<LatLng> coordinates,
    String? culture,
    String? safra,
    double ndviAverage,
    DateTime? lastUpdate,
  });
}

/// @nodoc
class __$$AreaDtoImplCopyWithImpl<$Res>
    extends _$AreaDtoCopyWithImpl<$Res, _$AreaDtoImpl>
    implements _$$AreaDtoImplCopyWith<$Res> {
  __$$AreaDtoImplCopyWithImpl(
    _$AreaDtoImpl _value,
    $Res Function(_$AreaDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AreaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hectares = null,
    Object? clientId = null,
    Object? clienteNome = null,
    Object? fazendaNome = null,
    Object? status = null,
    Object? coordinates = null,
    Object? culture = freezed,
    Object? safra = freezed,
    Object? ndviAverage = null,
    Object? lastUpdate = freezed,
  }) {
    return _then(
      _$AreaDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        hectares: null == hectares
            ? _value.hectares
            : hectares // ignore: cast_nullable_to_non_nullable
                  as double,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        clienteNome: null == clienteNome
            ? _value.clienteNome
            : clienteNome // ignore: cast_nullable_to_non_nullable
                  as String,
        fazendaNome: null == fazendaNome
            ? _value.fazendaNome
            : fazendaNome // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        coordinates: null == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        culture: freezed == culture
            ? _value.culture
            : culture // ignore: cast_nullable_to_non_nullable
                  as String?,
        safra: freezed == safra
            ? _value.safra
            : safra // ignore: cast_nullable_to_non_nullable
                  as String?,
        ndviAverage: null == ndviAverage
            ? _value.ndviAverage
            : ndviAverage // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdate: freezed == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaDtoImpl extends _AreaDto {
  const _$AreaDtoImpl({
    required this.id,
    required this.name,
    required this.hectares,
    @JsonKey(defaultValue: '') required this.clientId,
    required this.clienteNome,
    required this.fazendaNome,
    this.status = 'active',
    @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
    required final List<LatLng> coordinates,
    this.culture,
    this.safra,
    this.ndviAverage = 0.0,
    this.lastUpdate,
  }) : _coordinates = coordinates,
       super._();

  factory _$AreaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AreaDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double hectares;
  @override
  @JsonKey(defaultValue: '')
  final String clientId;
  @override
  final String clienteNome;
  @override
  final String fazendaNome;
  @override
  @JsonKey()
  final String status;
  // ignore: invalid_annotation_target
  final List<LatLng> _coordinates;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
  List<LatLng> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final String? culture;
  @override
  final String? safra;
  @override
  @JsonKey()
  final double ndviAverage;
  @override
  final DateTime? lastUpdate;

  @override
  String toString() {
    return 'AreaDto(id: $id, name: $name, hectares: $hectares, clientId: $clientId, clienteNome: $clienteNome, fazendaNome: $fazendaNome, status: $status, coordinates: $coordinates, culture: $culture, safra: $safra, ndviAverage: $ndviAverage, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.hectares, hectares) ||
                other.hectares == hectares) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clienteNome, clienteNome) ||
                other.clienteNome == clienteNome) &&
            (identical(other.fazendaNome, fazendaNome) ||
                other.fazendaNome == fazendaNome) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._coordinates,
              _coordinates,
            ) &&
            (identical(other.culture, culture) || other.culture == culture) &&
            (identical(other.safra, safra) || other.safra == safra) &&
            (identical(other.ndviAverage, ndviAverage) ||
                other.ndviAverage == ndviAverage) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    hectares,
    clientId,
    clienteNome,
    fazendaNome,
    status,
    const DeepCollectionEquality().hash(_coordinates),
    culture,
    safra,
    ndviAverage,
    lastUpdate,
  );

  /// Create a copy of AreaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaDtoImplCopyWith<_$AreaDtoImpl> get copyWith =>
      __$$AreaDtoImplCopyWithImpl<_$AreaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaDtoImplToJson(this);
  }
}

abstract class _AreaDto extends AreaDto {
  const factory _AreaDto({
    required final String id,
    required final String name,
    required final double hectares,
    @JsonKey(defaultValue: '') required final String clientId,
    required final String clienteNome,
    required final String fazendaNome,
    final String status,
    @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
    required final List<LatLng> coordinates,
    final String? culture,
    final String? safra,
    final double ndviAverage,
    final DateTime? lastUpdate,
  }) = _$AreaDtoImpl;
  const _AreaDto._() : super._();

  factory _AreaDto.fromJson(Map<String, dynamic> json) = _$AreaDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get hectares;
  @override
  @JsonKey(defaultValue: '')
  String get clientId;
  @override
  String get clienteNome;
  @override
  String get fazendaNome;
  @override
  String get status; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _latLngListFromJson, toJson: _latLngListToJson)
  List<LatLng> get coordinates;
  @override
  String? get culture;
  @override
  String? get safra;
  @override
  double get ndviAverage;
  @override
  DateTime? get lastUpdate;

  /// Create a copy of AreaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AreaDtoImplCopyWith<_$AreaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
