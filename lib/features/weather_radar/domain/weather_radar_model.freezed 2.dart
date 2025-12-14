// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_radar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherRadar {

 String get id; DateTime get timestamp; double get latitude; double get longitude; int get zoom; String get radarType;// precipitation, clouds, temperature
 String? get imageUrl; Map<String, dynamic>? get metadata;
/// Create a copy of WeatherRadar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherRadarCopyWith<WeatherRadar> get copyWith => _$WeatherRadarCopyWithImpl<WeatherRadar>(this as WeatherRadar, _$identity);

  /// Serializes this WeatherRadar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherRadar&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.radarType, radarType) || other.radarType == radarType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,latitude,longitude,zoom,radarType,imageUrl,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'WeatherRadar(id: $id, timestamp: $timestamp, latitude: $latitude, longitude: $longitude, zoom: $zoom, radarType: $radarType, imageUrl: $imageUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $WeatherRadarCopyWith<$Res>  {
  factory $WeatherRadarCopyWith(WeatherRadar value, $Res Function(WeatherRadar) _then) = _$WeatherRadarCopyWithImpl;
@useResult
$Res call({
 String id, DateTime timestamp, double latitude, double longitude, int zoom, String radarType, String? imageUrl, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$WeatherRadarCopyWithImpl<$Res>
    implements $WeatherRadarCopyWith<$Res> {
  _$WeatherRadarCopyWithImpl(this._self, this._then);

  final WeatherRadar _self;
  final $Res Function(WeatherRadar) _then;

/// Create a copy of WeatherRadar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? latitude = null,Object? longitude = null,Object? zoom = null,Object? radarType = null,Object? imageUrl = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as int,radarType: null == radarType ? _self.radarType : radarType // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherRadar].
extension WeatherRadarPatterns on WeatherRadar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherRadar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherRadar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherRadar value)  $default,){
final _that = this;
switch (_that) {
case _WeatherRadar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherRadar value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherRadar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  double latitude,  double longitude,  int zoom,  String radarType,  String? imageUrl,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherRadar() when $default != null:
return $default(_that.id,_that.timestamp,_that.latitude,_that.longitude,_that.zoom,_that.radarType,_that.imageUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  double latitude,  double longitude,  int zoom,  String radarType,  String? imageUrl,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _WeatherRadar():
return $default(_that.id,_that.timestamp,_that.latitude,_that.longitude,_that.zoom,_that.radarType,_that.imageUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime timestamp,  double latitude,  double longitude,  int zoom,  String radarType,  String? imageUrl,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _WeatherRadar() when $default != null:
return $default(_that.id,_that.timestamp,_that.latitude,_that.longitude,_that.zoom,_that.radarType,_that.imageUrl,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherRadar implements WeatherRadar {
  const _WeatherRadar({required this.id, required this.timestamp, required this.latitude, required this.longitude, required this.zoom, required this.radarType, this.imageUrl, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _WeatherRadar.fromJson(Map<String, dynamic> json) => _$WeatherRadarFromJson(json);

@override final  String id;
@override final  DateTime timestamp;
@override final  double latitude;
@override final  double longitude;
@override final  int zoom;
@override final  String radarType;
// precipitation, clouds, temperature
@override final  String? imageUrl;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of WeatherRadar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherRadarCopyWith<_WeatherRadar> get copyWith => __$WeatherRadarCopyWithImpl<_WeatherRadar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherRadarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherRadar&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.radarType, radarType) || other.radarType == radarType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,latitude,longitude,zoom,radarType,imageUrl,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'WeatherRadar(id: $id, timestamp: $timestamp, latitude: $latitude, longitude: $longitude, zoom: $zoom, radarType: $radarType, imageUrl: $imageUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$WeatherRadarCopyWith<$Res> implements $WeatherRadarCopyWith<$Res> {
  factory _$WeatherRadarCopyWith(_WeatherRadar value, $Res Function(_WeatherRadar) _then) = __$WeatherRadarCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime timestamp, double latitude, double longitude, int zoom, String radarType, String? imageUrl, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$WeatherRadarCopyWithImpl<$Res>
    implements _$WeatherRadarCopyWith<$Res> {
  __$WeatherRadarCopyWithImpl(this._self, this._then);

  final _WeatherRadar _self;
  final $Res Function(_WeatherRadar) _then;

/// Create a copy of WeatherRadar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? latitude = null,Object? longitude = null,Object? zoom = null,Object? radarType = null,Object? imageUrl = freezed,Object? metadata = freezed,}) {
  return _then(_WeatherRadar(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as int,radarType: null == radarType ? _self.radarType : radarType // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
