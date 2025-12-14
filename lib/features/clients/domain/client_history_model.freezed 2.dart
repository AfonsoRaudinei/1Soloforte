// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientHistory {

 String get id; String get clientId; String get actionType;// 'visit', 'occurrence', 'report', 'call', 'whatsapp', 'email', 'created', 'updated'
 DateTime get timestamp; String get description; String? get relatedId;// ID da visita, ocorrência, relatório, etc.
 String? get userId;// Quem executou a ação
 Map<String, dynamic>? get metadata;
/// Create a copy of ClientHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientHistoryCopyWith<ClientHistory> get copyWith => _$ClientHistoryCopyWithImpl<ClientHistory>(this as ClientHistory, _$identity);

  /// Serializes this ClientHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.description, description) || other.description == description)&&(identical(other.relatedId, relatedId) || other.relatedId == relatedId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,actionType,timestamp,description,relatedId,userId,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'ClientHistory(id: $id, clientId: $clientId, actionType: $actionType, timestamp: $timestamp, description: $description, relatedId: $relatedId, userId: $userId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ClientHistoryCopyWith<$Res>  {
  factory $ClientHistoryCopyWith(ClientHistory value, $Res Function(ClientHistory) _then) = _$ClientHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String actionType, DateTime timestamp, String description, String? relatedId, String? userId, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$ClientHistoryCopyWithImpl<$Res>
    implements $ClientHistoryCopyWith<$Res> {
  _$ClientHistoryCopyWithImpl(this._self, this._then);

  final ClientHistory _self;
  final $Res Function(ClientHistory) _then;

/// Create a copy of ClientHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? actionType = null,Object? timestamp = null,Object? description = null,Object? relatedId = freezed,Object? userId = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,relatedId: freezed == relatedId ? _self.relatedId : relatedId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientHistory].
extension ClientHistoryPatterns on ClientHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientHistory value)  $default,){
final _that = this;
switch (_that) {
case _ClientHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ClientHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String actionType,  DateTime timestamp,  String description,  String? relatedId,  String? userId,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientHistory() when $default != null:
return $default(_that.id,_that.clientId,_that.actionType,_that.timestamp,_that.description,_that.relatedId,_that.userId,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String actionType,  DateTime timestamp,  String description,  String? relatedId,  String? userId,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _ClientHistory():
return $default(_that.id,_that.clientId,_that.actionType,_that.timestamp,_that.description,_that.relatedId,_that.userId,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String actionType,  DateTime timestamp,  String description,  String? relatedId,  String? userId,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _ClientHistory() when $default != null:
return $default(_that.id,_that.clientId,_that.actionType,_that.timestamp,_that.description,_that.relatedId,_that.userId,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientHistory implements ClientHistory {
  const _ClientHistory({required this.id, required this.clientId, required this.actionType, required this.timestamp, required this.description, this.relatedId, this.userId, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _ClientHistory.fromJson(Map<String, dynamic> json) => _$ClientHistoryFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String actionType;
// 'visit', 'occurrence', 'report', 'call', 'whatsapp', 'email', 'created', 'updated'
@override final  DateTime timestamp;
@override final  String description;
@override final  String? relatedId;
// ID da visita, ocorrência, relatório, etc.
@override final  String? userId;
// Quem executou a ação
 final  Map<String, dynamic>? _metadata;
// Quem executou a ação
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ClientHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientHistoryCopyWith<_ClientHistory> get copyWith => __$ClientHistoryCopyWithImpl<_ClientHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.description, description) || other.description == description)&&(identical(other.relatedId, relatedId) || other.relatedId == relatedId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,actionType,timestamp,description,relatedId,userId,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'ClientHistory(id: $id, clientId: $clientId, actionType: $actionType, timestamp: $timestamp, description: $description, relatedId: $relatedId, userId: $userId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ClientHistoryCopyWith<$Res> implements $ClientHistoryCopyWith<$Res> {
  factory _$ClientHistoryCopyWith(_ClientHistory value, $Res Function(_ClientHistory) _then) = __$ClientHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String actionType, DateTime timestamp, String description, String? relatedId, String? userId, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$ClientHistoryCopyWithImpl<$Res>
    implements _$ClientHistoryCopyWith<$Res> {
  __$ClientHistoryCopyWithImpl(this._self, this._then);

  final _ClientHistory _self;
  final $Res Function(_ClientHistory) _then;

/// Create a copy of ClientHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? actionType = null,Object? timestamp = null,Object? description = null,Object? relatedId = freezed,Object? userId = freezed,Object? metadata = freezed,}) {
  return _then(_ClientHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,relatedId: freezed == relatedId ? _self.relatedId : relatedId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
