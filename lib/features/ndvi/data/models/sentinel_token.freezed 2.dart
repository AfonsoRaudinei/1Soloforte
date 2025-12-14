// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sentinel_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SentinelToken {

// ignore: invalid_annotation_target
@JsonKey(name: 'access_token') String get accessToken;// ignore: invalid_annotation_target
@JsonKey(name: 'expires_in') int get expiresIn; int get receivedAt;
/// Create a copy of SentinelToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentinelTokenCopyWith<SentinelToken> get copyWith => _$SentinelTokenCopyWithImpl<SentinelToken>(this as SentinelToken, _$identity);

  /// Serializes this SentinelToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentinelToken&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,expiresIn,receivedAt);

@override
String toString() {
  return 'SentinelToken(accessToken: $accessToken, expiresIn: $expiresIn, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class $SentinelTokenCopyWith<$Res>  {
  factory $SentinelTokenCopyWith(SentinelToken value, $Res Function(SentinelToken) _then) = _$SentinelTokenCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'expires_in') int expiresIn, int receivedAt
});




}
/// @nodoc
class _$SentinelTokenCopyWithImpl<$Res>
    implements $SentinelTokenCopyWith<$Res> {
  _$SentinelTokenCopyWithImpl(this._self, this._then);

  final SentinelToken _self;
  final $Res Function(SentinelToken) _then;

/// Create a copy of SentinelToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? expiresIn = null,Object? receivedAt = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SentinelToken].
extension SentinelTokenPatterns on SentinelToken {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentinelToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentinelToken() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentinelToken value)  $default,){
final _that = this;
switch (_that) {
case _SentinelToken():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentinelToken value)?  $default,){
final _that = this;
switch (_that) {
case _SentinelToken() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'expires_in')  int expiresIn,  int receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentinelToken() when $default != null:
return $default(_that.accessToken,_that.expiresIn,_that.receivedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'expires_in')  int expiresIn,  int receivedAt)  $default,) {final _that = this;
switch (_that) {
case _SentinelToken():
return $default(_that.accessToken,_that.expiresIn,_that.receivedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'expires_in')  int expiresIn,  int receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _SentinelToken() when $default != null:
return $default(_that.accessToken,_that.expiresIn,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SentinelToken implements SentinelToken {
  const _SentinelToken({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'expires_in') required this.expiresIn, this.receivedAt = 0});
  factory _SentinelToken.fromJson(Map<String, dynamic> json) => _$SentinelTokenFromJson(json);

// ignore: invalid_annotation_target
@override@JsonKey(name: 'access_token') final  String accessToken;
// ignore: invalid_annotation_target
@override@JsonKey(name: 'expires_in') final  int expiresIn;
@override@JsonKey() final  int receivedAt;

/// Create a copy of SentinelToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentinelTokenCopyWith<_SentinelToken> get copyWith => __$SentinelTokenCopyWithImpl<_SentinelToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SentinelTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentinelToken&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,expiresIn,receivedAt);

@override
String toString() {
  return 'SentinelToken(accessToken: $accessToken, expiresIn: $expiresIn, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$SentinelTokenCopyWith<$Res> implements $SentinelTokenCopyWith<$Res> {
  factory _$SentinelTokenCopyWith(_SentinelToken value, $Res Function(_SentinelToken) _then) = __$SentinelTokenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'expires_in') int expiresIn, int receivedAt
});




}
/// @nodoc
class __$SentinelTokenCopyWithImpl<$Res>
    implements _$SentinelTokenCopyWith<$Res> {
  __$SentinelTokenCopyWithImpl(this._self, this._then);

  final _SentinelToken _self;
  final $Res Function(_SentinelToken) _then;

/// Create a copy of SentinelToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? expiresIn = null,Object? receivedAt = null,}) {
  return _then(_SentinelToken(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
