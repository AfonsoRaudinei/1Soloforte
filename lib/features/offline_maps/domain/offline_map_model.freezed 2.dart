// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_map_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfflineMap {

 String get id; String get name; double get minLat; double get maxLat; double get minLng; double get maxLng; int get zoomLevel; DateTime get downloadedAt; int get sizeBytes; bool get isDownloading; double get downloadProgress;
/// Create a copy of OfflineMap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflineMapCopyWith<OfflineMap> get copyWith => _$OfflineMapCopyWithImpl<OfflineMap>(this as OfflineMap, _$identity);

  /// Serializes this OfflineMap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineMap&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minLat, minLat) || other.minLat == minLat)&&(identical(other.maxLat, maxLat) || other.maxLat == maxLat)&&(identical(other.minLng, minLng) || other.minLng == minLng)&&(identical(other.maxLng, maxLng) || other.maxLng == maxLng)&&(identical(other.zoomLevel, zoomLevel) || other.zoomLevel == zoomLevel)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minLat,maxLat,minLng,maxLng,zoomLevel,downloadedAt,sizeBytes,isDownloading,downloadProgress);

@override
String toString() {
  return 'OfflineMap(id: $id, name: $name, minLat: $minLat, maxLat: $maxLat, minLng: $minLng, maxLng: $maxLng, zoomLevel: $zoomLevel, downloadedAt: $downloadedAt, sizeBytes: $sizeBytes, isDownloading: $isDownloading, downloadProgress: $downloadProgress)';
}


}

/// @nodoc
abstract mixin class $OfflineMapCopyWith<$Res>  {
  factory $OfflineMapCopyWith(OfflineMap value, $Res Function(OfflineMap) _then) = _$OfflineMapCopyWithImpl;
@useResult
$Res call({
 String id, String name, double minLat, double maxLat, double minLng, double maxLng, int zoomLevel, DateTime downloadedAt, int sizeBytes, bool isDownloading, double downloadProgress
});




}
/// @nodoc
class _$OfflineMapCopyWithImpl<$Res>
    implements $OfflineMapCopyWith<$Res> {
  _$OfflineMapCopyWithImpl(this._self, this._then);

  final OfflineMap _self;
  final $Res Function(OfflineMap) _then;

/// Create a copy of OfflineMap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? minLat = null,Object? maxLat = null,Object? minLng = null,Object? maxLng = null,Object? zoomLevel = null,Object? downloadedAt = null,Object? sizeBytes = null,Object? isDownloading = null,Object? downloadProgress = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minLat: null == minLat ? _self.minLat : minLat // ignore: cast_nullable_to_non_nullable
as double,maxLat: null == maxLat ? _self.maxLat : maxLat // ignore: cast_nullable_to_non_nullable
as double,minLng: null == minLng ? _self.minLng : minLng // ignore: cast_nullable_to_non_nullable
as double,maxLng: null == maxLng ? _self.maxLng : maxLng // ignore: cast_nullable_to_non_nullable
as double,zoomLevel: null == zoomLevel ? _self.zoomLevel : zoomLevel // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OfflineMap].
extension OfflineMapPatterns on OfflineMap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfflineMap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfflineMap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfflineMap value)  $default,){
final _that = this;
switch (_that) {
case _OfflineMap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfflineMap value)?  $default,){
final _that = this;
switch (_that) {
case _OfflineMap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double minLat,  double maxLat,  double minLng,  double maxLng,  int zoomLevel,  DateTime downloadedAt,  int sizeBytes,  bool isDownloading,  double downloadProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfflineMap() when $default != null:
return $default(_that.id,_that.name,_that.minLat,_that.maxLat,_that.minLng,_that.maxLng,_that.zoomLevel,_that.downloadedAt,_that.sizeBytes,_that.isDownloading,_that.downloadProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double minLat,  double maxLat,  double minLng,  double maxLng,  int zoomLevel,  DateTime downloadedAt,  int sizeBytes,  bool isDownloading,  double downloadProgress)  $default,) {final _that = this;
switch (_that) {
case _OfflineMap():
return $default(_that.id,_that.name,_that.minLat,_that.maxLat,_that.minLng,_that.maxLng,_that.zoomLevel,_that.downloadedAt,_that.sizeBytes,_that.isDownloading,_that.downloadProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double minLat,  double maxLat,  double minLng,  double maxLng,  int zoomLevel,  DateTime downloadedAt,  int sizeBytes,  bool isDownloading,  double downloadProgress)?  $default,) {final _that = this;
switch (_that) {
case _OfflineMap() when $default != null:
return $default(_that.id,_that.name,_that.minLat,_that.maxLat,_that.minLng,_that.maxLng,_that.zoomLevel,_that.downloadedAt,_that.sizeBytes,_that.isDownloading,_that.downloadProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfflineMap implements OfflineMap {
  const _OfflineMap({required this.id, required this.name, required this.minLat, required this.maxLat, required this.minLng, required this.maxLng, required this.zoomLevel, required this.downloadedAt, required this.sizeBytes, this.isDownloading = false, this.downloadProgress = 0});
  factory _OfflineMap.fromJson(Map<String, dynamic> json) => _$OfflineMapFromJson(json);

@override final  String id;
@override final  String name;
@override final  double minLat;
@override final  double maxLat;
@override final  double minLng;
@override final  double maxLng;
@override final  int zoomLevel;
@override final  DateTime downloadedAt;
@override final  int sizeBytes;
@override@JsonKey() final  bool isDownloading;
@override@JsonKey() final  double downloadProgress;

/// Create a copy of OfflineMap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfflineMapCopyWith<_OfflineMap> get copyWith => __$OfflineMapCopyWithImpl<_OfflineMap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfflineMapToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfflineMap&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minLat, minLat) || other.minLat == minLat)&&(identical(other.maxLat, maxLat) || other.maxLat == maxLat)&&(identical(other.minLng, minLng) || other.minLng == minLng)&&(identical(other.maxLng, maxLng) || other.maxLng == maxLng)&&(identical(other.zoomLevel, zoomLevel) || other.zoomLevel == zoomLevel)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minLat,maxLat,minLng,maxLng,zoomLevel,downloadedAt,sizeBytes,isDownloading,downloadProgress);

@override
String toString() {
  return 'OfflineMap(id: $id, name: $name, minLat: $minLat, maxLat: $maxLat, minLng: $minLng, maxLng: $maxLng, zoomLevel: $zoomLevel, downloadedAt: $downloadedAt, sizeBytes: $sizeBytes, isDownloading: $isDownloading, downloadProgress: $downloadProgress)';
}


}

/// @nodoc
abstract mixin class _$OfflineMapCopyWith<$Res> implements $OfflineMapCopyWith<$Res> {
  factory _$OfflineMapCopyWith(_OfflineMap value, $Res Function(_OfflineMap) _then) = __$OfflineMapCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double minLat, double maxLat, double minLng, double maxLng, int zoomLevel, DateTime downloadedAt, int sizeBytes, bool isDownloading, double downloadProgress
});




}
/// @nodoc
class __$OfflineMapCopyWithImpl<$Res>
    implements _$OfflineMapCopyWith<$Res> {
  __$OfflineMapCopyWithImpl(this._self, this._then);

  final _OfflineMap _self;
  final $Res Function(_OfflineMap) _then;

/// Create a copy of OfflineMap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? minLat = null,Object? maxLat = null,Object? minLng = null,Object? maxLng = null,Object? zoomLevel = null,Object? downloadedAt = null,Object? sizeBytes = null,Object? isDownloading = null,Object? downloadProgress = null,}) {
  return _then(_OfflineMap(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minLat: null == minLat ? _self.minLat : minLat // ignore: cast_nullable_to_non_nullable
as double,maxLat: null == maxLat ? _self.maxLat : maxLat // ignore: cast_nullable_to_non_nullable
as double,minLng: null == minLng ? _self.minLng : minLng // ignore: cast_nullable_to_non_nullable
as double,maxLng: null == maxLng ? _self.maxLng : maxLng // ignore: cast_nullable_to_non_nullable
as double,zoomLevel: null == zoomLevel ? _self.zoomLevel : zoomLevel // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
