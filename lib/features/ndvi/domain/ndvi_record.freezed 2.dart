// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ndvi_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NDVIRecord {

 String get id; DateTime get date; String get imageUrl; String get description; double get averageValue;
/// Create a copy of NDVIRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NDVIRecordCopyWith<NDVIRecord> get copyWith => _$NDVIRecordCopyWithImpl<NDVIRecord>(this as NDVIRecord, _$identity);

  /// Serializes this NDVIRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NDVIRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.averageValue, averageValue) || other.averageValue == averageValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,imageUrl,description,averageValue);

@override
String toString() {
  return 'NDVIRecord(id: $id, date: $date, imageUrl: $imageUrl, description: $description, averageValue: $averageValue)';
}


}

/// @nodoc
abstract mixin class $NDVIRecordCopyWith<$Res>  {
  factory $NDVIRecordCopyWith(NDVIRecord value, $Res Function(NDVIRecord) _then) = _$NDVIRecordCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String imageUrl, String description, double averageValue
});




}
/// @nodoc
class _$NDVIRecordCopyWithImpl<$Res>
    implements $NDVIRecordCopyWith<$Res> {
  _$NDVIRecordCopyWithImpl(this._self, this._then);

  final NDVIRecord _self;
  final $Res Function(NDVIRecord) _then;

/// Create a copy of NDVIRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? imageUrl = null,Object? description = null,Object? averageValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,averageValue: null == averageValue ? _self.averageValue : averageValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NDVIRecord].
extension NDVIRecordPatterns on NDVIRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NDVIRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NDVIRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NDVIRecord value)  $default,){
final _that = this;
switch (_that) {
case _NDVIRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NDVIRecord value)?  $default,){
final _that = this;
switch (_that) {
case _NDVIRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String imageUrl,  String description,  double averageValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NDVIRecord() when $default != null:
return $default(_that.id,_that.date,_that.imageUrl,_that.description,_that.averageValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String imageUrl,  String description,  double averageValue)  $default,) {final _that = this;
switch (_that) {
case _NDVIRecord():
return $default(_that.id,_that.date,_that.imageUrl,_that.description,_that.averageValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String imageUrl,  String description,  double averageValue)?  $default,) {final _that = this;
switch (_that) {
case _NDVIRecord() when $default != null:
return $default(_that.id,_that.date,_that.imageUrl,_that.description,_that.averageValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NDVIRecord implements NDVIRecord {
  const _NDVIRecord({required this.id, required this.date, required this.imageUrl, required this.description, required this.averageValue});
  factory _NDVIRecord.fromJson(Map<String, dynamic> json) => _$NDVIRecordFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String imageUrl;
@override final  String description;
@override final  double averageValue;

/// Create a copy of NDVIRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NDVIRecordCopyWith<_NDVIRecord> get copyWith => __$NDVIRecordCopyWithImpl<_NDVIRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NDVIRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NDVIRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.averageValue, averageValue) || other.averageValue == averageValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,imageUrl,description,averageValue);

@override
String toString() {
  return 'NDVIRecord(id: $id, date: $date, imageUrl: $imageUrl, description: $description, averageValue: $averageValue)';
}


}

/// @nodoc
abstract mixin class _$NDVIRecordCopyWith<$Res> implements $NDVIRecordCopyWith<$Res> {
  factory _$NDVIRecordCopyWith(_NDVIRecord value, $Res Function(_NDVIRecord) _then) = __$NDVIRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String imageUrl, String description, double averageValue
});




}
/// @nodoc
class __$NDVIRecordCopyWithImpl<$Res>
    implements _$NDVIRecordCopyWith<$Res> {
  __$NDVIRecordCopyWithImpl(this._self, this._then);

  final _NDVIRecord _self;
  final $Res Function(_NDVIRecord) _then;

/// Create a copy of NDVIRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? imageUrl = null,Object? description = null,Object? averageValue = null,}) {
  return _then(_NDVIRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,averageValue: null == averageValue ? _self.averageValue : averageValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
