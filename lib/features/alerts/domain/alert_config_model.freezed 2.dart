// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertConfig {

 String get id; AlertType get type; String get title; bool get isEnabled; bool get pushNotification; bool get emailNotification; bool get smsNotification; Map<String, dynamic>? get conditions;
/// Create a copy of AlertConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertConfigCopyWith<AlertConfig> get copyWith => _$AlertConfigCopyWithImpl<AlertConfig>(this as AlertConfig, _$identity);

  /// Serializes this AlertConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.pushNotification, pushNotification) || other.pushNotification == pushNotification)&&(identical(other.emailNotification, emailNotification) || other.emailNotification == emailNotification)&&(identical(other.smsNotification, smsNotification) || other.smsNotification == smsNotification)&&const DeepCollectionEquality().equals(other.conditions, conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,isEnabled,pushNotification,emailNotification,smsNotification,const DeepCollectionEquality().hash(conditions));

@override
String toString() {
  return 'AlertConfig(id: $id, type: $type, title: $title, isEnabled: $isEnabled, pushNotification: $pushNotification, emailNotification: $emailNotification, smsNotification: $smsNotification, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class $AlertConfigCopyWith<$Res>  {
  factory $AlertConfigCopyWith(AlertConfig value, $Res Function(AlertConfig) _then) = _$AlertConfigCopyWithImpl;
@useResult
$Res call({
 String id, AlertType type, String title, bool isEnabled, bool pushNotification, bool emailNotification, bool smsNotification, Map<String, dynamic>? conditions
});




}
/// @nodoc
class _$AlertConfigCopyWithImpl<$Res>
    implements $AlertConfigCopyWith<$Res> {
  _$AlertConfigCopyWithImpl(this._self, this._then);

  final AlertConfig _self;
  final $Res Function(AlertConfig) _then;

/// Create a copy of AlertConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? isEnabled = null,Object? pushNotification = null,Object? emailNotification = null,Object? smsNotification = null,Object? conditions = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushNotification: null == pushNotification ? _self.pushNotification : pushNotification // ignore: cast_nullable_to_non_nullable
as bool,emailNotification: null == emailNotification ? _self.emailNotification : emailNotification // ignore: cast_nullable_to_non_nullable
as bool,smsNotification: null == smsNotification ? _self.smsNotification : smsNotification // ignore: cast_nullable_to_non_nullable
as bool,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertConfig].
extension AlertConfigPatterns on AlertConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertConfig value)  $default,){
final _that = this;
switch (_that) {
case _AlertConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AlertConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AlertType type,  String title,  bool isEnabled,  bool pushNotification,  bool emailNotification,  bool smsNotification,  Map<String, dynamic>? conditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertConfig() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.isEnabled,_that.pushNotification,_that.emailNotification,_that.smsNotification,_that.conditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AlertType type,  String title,  bool isEnabled,  bool pushNotification,  bool emailNotification,  bool smsNotification,  Map<String, dynamic>? conditions)  $default,) {final _that = this;
switch (_that) {
case _AlertConfig():
return $default(_that.id,_that.type,_that.title,_that.isEnabled,_that.pushNotification,_that.emailNotification,_that.smsNotification,_that.conditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AlertType type,  String title,  bool isEnabled,  bool pushNotification,  bool emailNotification,  bool smsNotification,  Map<String, dynamic>? conditions)?  $default,) {final _that = this;
switch (_that) {
case _AlertConfig() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.isEnabled,_that.pushNotification,_that.emailNotification,_that.smsNotification,_that.conditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertConfig implements AlertConfig {
  const _AlertConfig({required this.id, required this.type, required this.title, required this.isEnabled, this.pushNotification = true, this.emailNotification = false, this.smsNotification = false, final  Map<String, dynamic>? conditions}): _conditions = conditions;
  factory _AlertConfig.fromJson(Map<String, dynamic> json) => _$AlertConfigFromJson(json);

@override final  String id;
@override final  AlertType type;
@override final  String title;
@override final  bool isEnabled;
@override@JsonKey() final  bool pushNotification;
@override@JsonKey() final  bool emailNotification;
@override@JsonKey() final  bool smsNotification;
 final  Map<String, dynamic>? _conditions;
@override Map<String, dynamic>? get conditions {
  final value = _conditions;
  if (value == null) return null;
  if (_conditions is EqualUnmodifiableMapView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AlertConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertConfigCopyWith<_AlertConfig> get copyWith => __$AlertConfigCopyWithImpl<_AlertConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.pushNotification, pushNotification) || other.pushNotification == pushNotification)&&(identical(other.emailNotification, emailNotification) || other.emailNotification == emailNotification)&&(identical(other.smsNotification, smsNotification) || other.smsNotification == smsNotification)&&const DeepCollectionEquality().equals(other._conditions, _conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,isEnabled,pushNotification,emailNotification,smsNotification,const DeepCollectionEquality().hash(_conditions));

@override
String toString() {
  return 'AlertConfig(id: $id, type: $type, title: $title, isEnabled: $isEnabled, pushNotification: $pushNotification, emailNotification: $emailNotification, smsNotification: $smsNotification, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class _$AlertConfigCopyWith<$Res> implements $AlertConfigCopyWith<$Res> {
  factory _$AlertConfigCopyWith(_AlertConfig value, $Res Function(_AlertConfig) _then) = __$AlertConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, AlertType type, String title, bool isEnabled, bool pushNotification, bool emailNotification, bool smsNotification, Map<String, dynamic>? conditions
});




}
/// @nodoc
class __$AlertConfigCopyWithImpl<$Res>
    implements _$AlertConfigCopyWith<$Res> {
  __$AlertConfigCopyWithImpl(this._self, this._then);

  final _AlertConfig _self;
  final $Res Function(_AlertConfig) _then;

/// Create a copy of AlertConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? isEnabled = null,Object? pushNotification = null,Object? emailNotification = null,Object? smsNotification = null,Object? conditions = freezed,}) {
  return _then(_AlertConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushNotification: null == pushNotification ? _self.pushNotification : pushNotification // ignore: cast_nullable_to_non_nullable
as bool,emailNotification: null == emailNotification ? _self.emailNotification : emailNotification // ignore: cast_nullable_to_non_nullable
as bool,smsNotification: null == smsNotification ? _self.smsNotification : smsNotification // ignore: cast_nullable_to_non_nullable
as bool,conditions: freezed == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
