// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardState {
  bool get isRadialMenuOpen => throw _privateConstructorUsedError;
  String get mapLayer => throw _privateConstructorUsedError;
  bool get isWeatherRadarVisible => throw _privateConstructorUsedError;
  LatLng? get tempPin => throw _privateConstructorUsedError;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
    DashboardState value,
    $Res Function(DashboardState) then,
  ) = _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call({
    bool isRadialMenuOpen,
    String mapLayer,
    bool isWeatherRadarVisible,
    LatLng? tempPin,
  });
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRadialMenuOpen = null,
    Object? mapLayer = null,
    Object? isWeatherRadarVisible = null,
    Object? tempPin = freezed,
  }) {
    return _then(
      _value.copyWith(
            isRadialMenuOpen: null == isRadialMenuOpen
                ? _value.isRadialMenuOpen
                : isRadialMenuOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            mapLayer: null == mapLayer
                ? _value.mapLayer
                : mapLayer // ignore: cast_nullable_to_non_nullable
                      as String,
            isWeatherRadarVisible: null == isWeatherRadarVisible
                ? _value.isWeatherRadarVisible
                : isWeatherRadarVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            tempPin: freezed == tempPin
                ? _value.tempPin
                : tempPin // ignore: cast_nullable_to_non_nullable
                      as LatLng?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(
    _$DashboardStateImpl value,
    $Res Function(_$DashboardStateImpl) then,
  ) = __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isRadialMenuOpen,
    String mapLayer,
    bool isWeatherRadarVisible,
    LatLng? tempPin,
  });
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
    _$DashboardStateImpl _value,
    $Res Function(_$DashboardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRadialMenuOpen = null,
    Object? mapLayer = null,
    Object? isWeatherRadarVisible = null,
    Object? tempPin = freezed,
  }) {
    return _then(
      _$DashboardStateImpl(
        isRadialMenuOpen: null == isRadialMenuOpen
            ? _value.isRadialMenuOpen
            : isRadialMenuOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        mapLayer: null == mapLayer
            ? _value.mapLayer
            : mapLayer // ignore: cast_nullable_to_non_nullable
                  as String,
        isWeatherRadarVisible: null == isWeatherRadarVisible
            ? _value.isWeatherRadarVisible
            : isWeatherRadarVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        tempPin: freezed == tempPin
            ? _value.tempPin
            : tempPin // ignore: cast_nullable_to_non_nullable
                  as LatLng?,
      ),
    );
  }
}

/// @nodoc

class _$DashboardStateImpl implements _DashboardState {
  const _$DashboardStateImpl({
    this.isRadialMenuOpen = false,
    this.mapLayer = 'standard',
    this.isWeatherRadarVisible = false,
    this.tempPin,
  });

  @override
  @JsonKey()
  final bool isRadialMenuOpen;
  @override
  @JsonKey()
  final String mapLayer;
  @override
  @JsonKey()
  final bool isWeatherRadarVisible;
  @override
  final LatLng? tempPin;

  @override
  String toString() {
    return 'DashboardState(isRadialMenuOpen: $isRadialMenuOpen, mapLayer: $mapLayer, isWeatherRadarVisible: $isWeatherRadarVisible, tempPin: $tempPin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            (identical(other.isRadialMenuOpen, isRadialMenuOpen) ||
                other.isRadialMenuOpen == isRadialMenuOpen) &&
            (identical(other.mapLayer, mapLayer) ||
                other.mapLayer == mapLayer) &&
            (identical(other.isWeatherRadarVisible, isWeatherRadarVisible) ||
                other.isWeatherRadarVisible == isWeatherRadarVisible) &&
            (identical(other.tempPin, tempPin) || other.tempPin == tempPin));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isRadialMenuOpen,
    mapLayer,
    isWeatherRadarVisible,
    tempPin,
  );

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DashboardState implements DashboardState {
  const factory _DashboardState({
    final bool isRadialMenuOpen,
    final String mapLayer,
    final bool isWeatherRadarVisible,
    final LatLng? tempPin,
  }) = _$DashboardStateImpl;

  @override
  bool get isRadialMenuOpen;
  @override
  String get mapLayer;
  @override
  bool get isWeatherRadarVisible;
  @override
  LatLng? get tempPin;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
