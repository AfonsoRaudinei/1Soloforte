// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoArea {

 String get id; String get name;// ignore: invalid_annotation_target
@JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> get points; double get areaHectares; double get perimeterKm; double get radius; LatLng? get center; String get type;// polygon, circle, rectangle
 DateTime? get createdAt;
/// Create a copy of GeoArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoAreaCopyWith<GeoArea> get copyWith => _$GeoAreaCopyWithImpl<GeoArea>(this as GeoArea, _$identity);

  /// Serializes this GeoArea to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.areaHectares, areaHectares) || other.areaHectares == areaHectares)&&(identical(other.perimeterKm, perimeterKm) || other.perimeterKm == perimeterKm)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.center, center) || other.center == center)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(points),areaHectares,perimeterKm,radius,center,type,createdAt);

@override
String toString() {
  return 'GeoArea(id: $id, name: $name, points: $points, areaHectares: $areaHectares, perimeterKm: $perimeterKm, radius: $radius, center: $center, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GeoAreaCopyWith<$Res>  {
  factory $GeoAreaCopyWith(GeoArea value, $Res Function(GeoArea) _then) = _$GeoAreaCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> points, double areaHectares, double perimeterKm, double radius, LatLng? center, String type, DateTime? createdAt
});




}
/// @nodoc
class _$GeoAreaCopyWithImpl<$Res>
    implements $GeoAreaCopyWith<$Res> {
  _$GeoAreaCopyWithImpl(this._self, this._then);

  final GeoArea _self;
  final $Res Function(GeoArea) _then;

/// Create a copy of GeoArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? points = null,Object? areaHectares = null,Object? perimeterKm = null,Object? radius = null,Object? center = freezed,Object? type = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,areaHectares: null == areaHectares ? _self.areaHectares : areaHectares // ignore: cast_nullable_to_non_nullable
as double,perimeterKm: null == perimeterKm ? _self.perimeterKm : perimeterKm // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,center: freezed == center ? _self.center : center // ignore: cast_nullable_to_non_nullable
as LatLng?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoArea].
extension GeoAreaPatterns on GeoArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoArea value)  $default,){
final _that = this;
switch (_that) {
case _GeoArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoArea value)?  $default,){
final _that = this;
switch (_that) {
case _GeoArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(includeFromJson: false, includeToJson: false)  List<LatLng> points,  double areaHectares,  double perimeterKm,  double radius,  LatLng? center,  String type,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoArea() when $default != null:
return $default(_that.id,_that.name,_that.points,_that.areaHectares,_that.perimeterKm,_that.radius,_that.center,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(includeFromJson: false, includeToJson: false)  List<LatLng> points,  double areaHectares,  double perimeterKm,  double radius,  LatLng? center,  String type,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _GeoArea():
return $default(_that.id,_that.name,_that.points,_that.areaHectares,_that.perimeterKm,_that.radius,_that.center,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(includeFromJson: false, includeToJson: false)  List<LatLng> points,  double areaHectares,  double perimeterKm,  double radius,  LatLng? center,  String type,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GeoArea() when $default != null:
return $default(_that.id,_that.name,_that.points,_that.areaHectares,_that.perimeterKm,_that.radius,_that.center,_that.type,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoArea implements GeoArea {
  const _GeoArea({required this.id, required this.name, @JsonKey(includeFromJson: false, includeToJson: false) final  List<LatLng> points = const [], this.areaHectares = 0.0, this.perimeterKm = 0.0, this.radius = 0.0, this.center, this.type = 'polygon', this.createdAt}): _points = points;
  factory _GeoArea.fromJson(Map<String, dynamic> json) => _$GeoAreaFromJson(json);

@override final  String id;
@override final  String name;
// ignore: invalid_annotation_target
 final  List<LatLng> _points;
// ignore: invalid_annotation_target
@override@JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  double areaHectares;
@override@JsonKey() final  double perimeterKm;
@override@JsonKey() final  double radius;
@override final  LatLng? center;
@override@JsonKey() final  String type;
// polygon, circle, rectangle
@override final  DateTime? createdAt;

/// Create a copy of GeoArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoAreaCopyWith<_GeoArea> get copyWith => __$GeoAreaCopyWithImpl<_GeoArea>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoAreaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.areaHectares, areaHectares) || other.areaHectares == areaHectares)&&(identical(other.perimeterKm, perimeterKm) || other.perimeterKm == perimeterKm)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.center, center) || other.center == center)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_points),areaHectares,perimeterKm,radius,center,type,createdAt);

@override
String toString() {
  return 'GeoArea(id: $id, name: $name, points: $points, areaHectares: $areaHectares, perimeterKm: $perimeterKm, radius: $radius, center: $center, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GeoAreaCopyWith<$Res> implements $GeoAreaCopyWith<$Res> {
  factory _$GeoAreaCopyWith(_GeoArea value, $Res Function(_GeoArea) _then) = __$GeoAreaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(includeFromJson: false, includeToJson: false) List<LatLng> points, double areaHectares, double perimeterKm, double radius, LatLng? center, String type, DateTime? createdAt
});




}
/// @nodoc
class __$GeoAreaCopyWithImpl<$Res>
    implements _$GeoAreaCopyWith<$Res> {
  __$GeoAreaCopyWithImpl(this._self, this._then);

  final _GeoArea _self;
  final $Res Function(_GeoArea) _then;

/// Create a copy of GeoArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? points = null,Object? areaHectares = null,Object? perimeterKm = null,Object? radius = null,Object? center = freezed,Object? type = null,Object? createdAt = freezed,}) {
  return _then(_GeoArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,areaHectares: null == areaHectares ? _self.areaHectares : areaHectares // ignore: cast_nullable_to_non_nullable
as double,perimeterKm: null == perimeterKm ? _self.perimeterKm : perimeterKm // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,center: freezed == center ? _self.center : center // ignore: cast_nullable_to_non_nullable
as LatLng?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
