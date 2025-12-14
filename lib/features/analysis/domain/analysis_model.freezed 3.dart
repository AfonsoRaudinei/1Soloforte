// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Analysis {

 String get id; String get code;// e.g., AN-2023-001
 Client get client;// Snapshot of client
 GeoArea get area;// Snapshot of area
 AnalysisType get type; AnalysisStatus get status; DateTime get date; String? get notes;
/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisCopyWith<Analysis> get copyWith => _$AnalysisCopyWithImpl<Analysis>(this as Analysis, _$identity);

  /// Serializes this Analysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Analysis&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.client, client) || other.client == client)&&(identical(other.area, area) || other.area == area)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,client,area,type,status,date,notes);

@override
String toString() {
  return 'Analysis(id: $id, code: $code, client: $client, area: $area, type: $type, status: $status, date: $date, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $AnalysisCopyWith<$Res>  {
  factory $AnalysisCopyWith(Analysis value, $Res Function(Analysis) _then) = _$AnalysisCopyWithImpl;
@useResult
$Res call({
 String id, String code, Client client, GeoArea area, AnalysisType type, AnalysisStatus status, DateTime date, String? notes
});


$ClientCopyWith<$Res> get client;$GeoAreaCopyWith<$Res> get area;

}
/// @nodoc
class _$AnalysisCopyWithImpl<$Res>
    implements $AnalysisCopyWith<$Res> {
  _$AnalysisCopyWithImpl(this._self, this._then);

  final Analysis _self;
  final $Res Function(Analysis) _then;

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? client = null,Object? area = null,Object? type = null,Object? status = null,Object? date = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as GeoArea,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnalysisType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnalysisStatus,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoAreaCopyWith<$Res> get area {
  
  return $GeoAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}


/// Adds pattern-matching-related methods to [Analysis].
extension AnalysisPatterns on Analysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Analysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Analysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Analysis value)  $default,){
final _that = this;
switch (_that) {
case _Analysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Analysis value)?  $default,){
final _that = this;
switch (_that) {
case _Analysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  Client client,  GeoArea area,  AnalysisType type,  AnalysisStatus status,  DateTime date,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Analysis() when $default != null:
return $default(_that.id,_that.code,_that.client,_that.area,_that.type,_that.status,_that.date,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  Client client,  GeoArea area,  AnalysisType type,  AnalysisStatus status,  DateTime date,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Analysis():
return $default(_that.id,_that.code,_that.client,_that.area,_that.type,_that.status,_that.date,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  Client client,  GeoArea area,  AnalysisType type,  AnalysisStatus status,  DateTime date,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Analysis() when $default != null:
return $default(_that.id,_that.code,_that.client,_that.area,_that.type,_that.status,_that.date,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Analysis implements Analysis {
  const _Analysis({required this.id, required this.code, required this.client, required this.area, required this.type, required this.status, required this.date, this.notes});
  factory _Analysis.fromJson(Map<String, dynamic> json) => _$AnalysisFromJson(json);

@override final  String id;
@override final  String code;
// e.g., AN-2023-001
@override final  Client client;
// Snapshot of client
@override final  GeoArea area;
// Snapshot of area
@override final  AnalysisType type;
@override final  AnalysisStatus status;
@override final  DateTime date;
@override final  String? notes;

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisCopyWith<_Analysis> get copyWith => __$AnalysisCopyWithImpl<_Analysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Analysis&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.client, client) || other.client == client)&&(identical(other.area, area) || other.area == area)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,client,area,type,status,date,notes);

@override
String toString() {
  return 'Analysis(id: $id, code: $code, client: $client, area: $area, type: $type, status: $status, date: $date, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$AnalysisCopyWith<$Res> implements $AnalysisCopyWith<$Res> {
  factory _$AnalysisCopyWith(_Analysis value, $Res Function(_Analysis) _then) = __$AnalysisCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, Client client, GeoArea area, AnalysisType type, AnalysisStatus status, DateTime date, String? notes
});


@override $ClientCopyWith<$Res> get client;@override $GeoAreaCopyWith<$Res> get area;

}
/// @nodoc
class __$AnalysisCopyWithImpl<$Res>
    implements _$AnalysisCopyWith<$Res> {
  __$AnalysisCopyWithImpl(this._self, this._then);

  final _Analysis _self;
  final $Res Function(_Analysis) _then;

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? client = null,Object? area = null,Object? type = null,Object? status = null,Object? date = null,Object? notes = freezed,}) {
  return _then(_Analysis(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as GeoArea,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnalysisType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnalysisStatus,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoAreaCopyWith<$Res> get area {
  
  return $GeoAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}

// dart format on
