// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapPoint {

 String get id; String get title; String get description; double get latitude; double get longitude; String get type;// 'pest', 'disease', 'observation'
 DateTime? get timestamp;
/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPointCopyWith<MapPoint> get copyWith => _$MapPointCopyWithImpl<MapPoint>(this as MapPoint, _$identity);

  /// Serializes this MapPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPoint&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.type, type) || other.type == type)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,latitude,longitude,type,timestamp);

@override
String toString() {
  return 'MapPoint(id: $id, title: $title, description: $description, latitude: $latitude, longitude: $longitude, type: $type, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $MapPointCopyWith<$Res>  {
  factory $MapPointCopyWith(MapPoint value, $Res Function(MapPoint) _then) = _$MapPointCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, double latitude, double longitude, String type, DateTime? timestamp
});




}
/// @nodoc
class _$MapPointCopyWithImpl<$Res>
    implements $MapPointCopyWith<$Res> {
  _$MapPointCopyWithImpl(this._self, this._then);

  final MapPoint _self;
  final $Res Function(MapPoint) _then;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? latitude = null,Object? longitude = null,Object? type = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapPoint].
extension MapPointPatterns on MapPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPoint value)  $default,){
final _that = this;
switch (_that) {
case _MapPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPoint value)?  $default,){
final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double latitude,  double longitude,  String type,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.latitude,_that.longitude,_that.type,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double latitude,  double longitude,  String type,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _MapPoint():
return $default(_that.id,_that.title,_that.description,_that.latitude,_that.longitude,_that.type,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  double latitude,  double longitude,  String type,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.latitude,_that.longitude,_that.type,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapPoint implements MapPoint {
  const _MapPoint({required this.id, required this.title, required this.description, required this.latitude, required this.longitude, required this.type, this.timestamp});
  factory _MapPoint.fromJson(Map<String, dynamic> json) => _$MapPointFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  double latitude;
@override final  double longitude;
@override final  String type;
// 'pest', 'disease', 'observation'
@override final  DateTime? timestamp;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPointCopyWith<_MapPoint> get copyWith => __$MapPointCopyWithImpl<_MapPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPoint&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.type, type) || other.type == type)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,latitude,longitude,type,timestamp);

@override
String toString() {
  return 'MapPoint(id: $id, title: $title, description: $description, latitude: $latitude, longitude: $longitude, type: $type, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$MapPointCopyWith<$Res> implements $MapPointCopyWith<$Res> {
  factory _$MapPointCopyWith(_MapPoint value, $Res Function(_MapPoint) _then) = __$MapPointCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, double latitude, double longitude, String type, DateTime? timestamp
});




}
/// @nodoc
class __$MapPointCopyWithImpl<$Res>
    implements _$MapPointCopyWith<$Res> {
  __$MapPointCopyWithImpl(this._self, this._then);

  final _MapPoint _self;
  final $Res Function(_MapPoint) _then;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? latitude = null,Object? longitude = null,Object? type = null,Object? timestamp = freezed,}) {
  return _then(_MapPoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
