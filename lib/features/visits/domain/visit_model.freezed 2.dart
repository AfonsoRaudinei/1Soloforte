// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Visit {

 String get id; Client get client; DateTime get checkInTime; DateTime? get checkOutTime; double get latitude; double get longitude; String? get checkOutNotes;
/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitCopyWith<Visit> get copyWith => _$VisitCopyWithImpl<Visit>(this as Visit, _$identity);

  /// Serializes this Visit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Visit&&(identical(other.id, id) || other.id == id)&&(identical(other.client, client) || other.client == client)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.checkOutNotes, checkOutNotes) || other.checkOutNotes == checkOutNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,client,checkInTime,checkOutTime,latitude,longitude,checkOutNotes);

@override
String toString() {
  return 'Visit(id: $id, client: $client, checkInTime: $checkInTime, checkOutTime: $checkOutTime, latitude: $latitude, longitude: $longitude, checkOutNotes: $checkOutNotes)';
}


}

/// @nodoc
abstract mixin class $VisitCopyWith<$Res>  {
  factory $VisitCopyWith(Visit value, $Res Function(Visit) _then) = _$VisitCopyWithImpl;
@useResult
$Res call({
 String id, Client client, DateTime checkInTime, DateTime? checkOutTime, double latitude, double longitude, String? checkOutNotes
});


$ClientCopyWith<$Res> get client;

}
/// @nodoc
class _$VisitCopyWithImpl<$Res>
    implements $VisitCopyWith<$Res> {
  _$VisitCopyWithImpl(this._self, this._then);

  final Visit _self;
  final $Res Function(Visit) _then;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? client = null,Object? checkInTime = null,Object? checkOutTime = freezed,Object? latitude = null,Object? longitude = null,Object? checkOutNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,checkInTime: null == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as DateTime,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,checkOutNotes: freezed == checkOutNotes ? _self.checkOutNotes : checkOutNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [Visit].
extension VisitPatterns on Visit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Visit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Visit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Visit value)  $default,){
final _that = this;
switch (_that) {
case _Visit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Visit value)?  $default,){
final _that = this;
switch (_that) {
case _Visit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Client client,  DateTime checkInTime,  DateTime? checkOutTime,  double latitude,  double longitude,  String? checkOutNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Visit() when $default != null:
return $default(_that.id,_that.client,_that.checkInTime,_that.checkOutTime,_that.latitude,_that.longitude,_that.checkOutNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Client client,  DateTime checkInTime,  DateTime? checkOutTime,  double latitude,  double longitude,  String? checkOutNotes)  $default,) {final _that = this;
switch (_that) {
case _Visit():
return $default(_that.id,_that.client,_that.checkInTime,_that.checkOutTime,_that.latitude,_that.longitude,_that.checkOutNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Client client,  DateTime checkInTime,  DateTime? checkOutTime,  double latitude,  double longitude,  String? checkOutNotes)?  $default,) {final _that = this;
switch (_that) {
case _Visit() when $default != null:
return $default(_that.id,_that.client,_that.checkInTime,_that.checkOutTime,_that.latitude,_that.longitude,_that.checkOutNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Visit implements Visit {
  const _Visit({required this.id, required this.client, required this.checkInTime, this.checkOutTime, required this.latitude, required this.longitude, this.checkOutNotes});
  factory _Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

@override final  String id;
@override final  Client client;
@override final  DateTime checkInTime;
@override final  DateTime? checkOutTime;
@override final  double latitude;
@override final  double longitude;
@override final  String? checkOutNotes;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitCopyWith<_Visit> get copyWith => __$VisitCopyWithImpl<_Visit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Visit&&(identical(other.id, id) || other.id == id)&&(identical(other.client, client) || other.client == client)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.checkOutNotes, checkOutNotes) || other.checkOutNotes == checkOutNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,client,checkInTime,checkOutTime,latitude,longitude,checkOutNotes);

@override
String toString() {
  return 'Visit(id: $id, client: $client, checkInTime: $checkInTime, checkOutTime: $checkOutTime, latitude: $latitude, longitude: $longitude, checkOutNotes: $checkOutNotes)';
}


}

/// @nodoc
abstract mixin class _$VisitCopyWith<$Res> implements $VisitCopyWith<$Res> {
  factory _$VisitCopyWith(_Visit value, $Res Function(_Visit) _then) = __$VisitCopyWithImpl;
@override @useResult
$Res call({
 String id, Client client, DateTime checkInTime, DateTime? checkOutTime, double latitude, double longitude, String? checkOutNotes
});


@override $ClientCopyWith<$Res> get client;

}
/// @nodoc
class __$VisitCopyWithImpl<$Res>
    implements _$VisitCopyWith<$Res> {
  __$VisitCopyWithImpl(this._self, this._then);

  final _Visit _self;
  final $Res Function(_Visit) _then;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? client = null,Object? checkInTime = null,Object? checkOutTime = freezed,Object? latitude = null,Object? longitude = null,Object? checkOutNotes = freezed,}) {
  return _then(_Visit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,checkInTime: null == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as DateTime,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,checkOutNotes: freezed == checkOutNotes ? _self.checkOutNotes : checkOutNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
