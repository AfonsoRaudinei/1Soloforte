// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harvest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Harvest {

 String get id; String get areaId; String get areaName; String get cropType;// e.g. "Soybean", "Corn"
 DateTime get plantedDate; DateTime? get harvestDate; double get plantedAreaHa; double get totalProductionBags;// Sacas
 double get totalCost; String get status;// 'planned', 'active', 'harvested'
 List<String> get notes;
/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestCopyWith<Harvest> get copyWith => _$HarvestCopyWithImpl<Harvest>(this as Harvest, _$identity);

  /// Serializes this Harvest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Harvest&&(identical(other.id, id) || other.id == id)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.plantedDate, plantedDate) || other.plantedDate == plantedDate)&&(identical(other.harvestDate, harvestDate) || other.harvestDate == harvestDate)&&(identical(other.plantedAreaHa, plantedAreaHa) || other.plantedAreaHa == plantedAreaHa)&&(identical(other.totalProductionBags, totalProductionBags) || other.totalProductionBags == totalProductionBags)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.notes, notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,areaId,areaName,cropType,plantedDate,harvestDate,plantedAreaHa,totalProductionBags,totalCost,status,const DeepCollectionEquality().hash(notes));

@override
String toString() {
  return 'Harvest(id: $id, areaId: $areaId, areaName: $areaName, cropType: $cropType, plantedDate: $plantedDate, harvestDate: $harvestDate, plantedAreaHa: $plantedAreaHa, totalProductionBags: $totalProductionBags, totalCost: $totalCost, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $HarvestCopyWith<$Res>  {
  factory $HarvestCopyWith(Harvest value, $Res Function(Harvest) _then) = _$HarvestCopyWithImpl;
@useResult
$Res call({
 String id, String areaId, String areaName, String cropType, DateTime plantedDate, DateTime? harvestDate, double plantedAreaHa, double totalProductionBags, double totalCost, String status, List<String> notes
});




}
/// @nodoc
class _$HarvestCopyWithImpl<$Res>
    implements $HarvestCopyWith<$Res> {
  _$HarvestCopyWithImpl(this._self, this._then);

  final Harvest _self;
  final $Res Function(Harvest) _then;

/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? areaId = null,Object? areaName = null,Object? cropType = null,Object? plantedDate = null,Object? harvestDate = freezed,Object? plantedAreaHa = null,Object? totalProductionBags = null,Object? totalCost = null,Object? status = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,areaName: null == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,plantedDate: null == plantedDate ? _self.plantedDate : plantedDate // ignore: cast_nullable_to_non_nullable
as DateTime,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plantedAreaHa: null == plantedAreaHa ? _self.plantedAreaHa : plantedAreaHa // ignore: cast_nullable_to_non_nullable
as double,totalProductionBags: null == totalProductionBags ? _self.totalProductionBags : totalProductionBags // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Harvest].
extension HarvestPatterns on Harvest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Harvest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Harvest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Harvest value)  $default,){
final _that = this;
switch (_that) {
case _Harvest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Harvest value)?  $default,){
final _that = this;
switch (_that) {
case _Harvest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String areaId,  String areaName,  String cropType,  DateTime plantedDate,  DateTime? harvestDate,  double plantedAreaHa,  double totalProductionBags,  double totalCost,  String status,  List<String> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Harvest() when $default != null:
return $default(_that.id,_that.areaId,_that.areaName,_that.cropType,_that.plantedDate,_that.harvestDate,_that.plantedAreaHa,_that.totalProductionBags,_that.totalCost,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String areaId,  String areaName,  String cropType,  DateTime plantedDate,  DateTime? harvestDate,  double plantedAreaHa,  double totalProductionBags,  double totalCost,  String status,  List<String> notes)  $default,) {final _that = this;
switch (_that) {
case _Harvest():
return $default(_that.id,_that.areaId,_that.areaName,_that.cropType,_that.plantedDate,_that.harvestDate,_that.plantedAreaHa,_that.totalProductionBags,_that.totalCost,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String areaId,  String areaName,  String cropType,  DateTime plantedDate,  DateTime? harvestDate,  double plantedAreaHa,  double totalProductionBags,  double totalCost,  String status,  List<String> notes)?  $default,) {final _that = this;
switch (_that) {
case _Harvest() when $default != null:
return $default(_that.id,_that.areaId,_that.areaName,_that.cropType,_that.plantedDate,_that.harvestDate,_that.plantedAreaHa,_that.totalProductionBags,_that.totalCost,_that.status,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Harvest implements Harvest {
  const _Harvest({required this.id, required this.areaId, required this.areaName, required this.cropType, required this.plantedDate, required this.harvestDate, required this.plantedAreaHa, required this.totalProductionBags, required this.totalCost, required this.status, final  List<String> notes = const []}): _notes = notes;
  factory _Harvest.fromJson(Map<String, dynamic> json) => _$HarvestFromJson(json);

@override final  String id;
@override final  String areaId;
@override final  String areaName;
@override final  String cropType;
// e.g. "Soybean", "Corn"
@override final  DateTime plantedDate;
@override final  DateTime? harvestDate;
@override final  double plantedAreaHa;
@override final  double totalProductionBags;
// Sacas
@override final  double totalCost;
@override final  String status;
// 'planned', 'active', 'harvested'
 final  List<String> _notes;
// 'planned', 'active', 'harvested'
@override@JsonKey() List<String> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}


/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestCopyWith<_Harvest> get copyWith => __$HarvestCopyWithImpl<_Harvest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Harvest&&(identical(other.id, id) || other.id == id)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.plantedDate, plantedDate) || other.plantedDate == plantedDate)&&(identical(other.harvestDate, harvestDate) || other.harvestDate == harvestDate)&&(identical(other.plantedAreaHa, plantedAreaHa) || other.plantedAreaHa == plantedAreaHa)&&(identical(other.totalProductionBags, totalProductionBags) || other.totalProductionBags == totalProductionBags)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,areaId,areaName,cropType,plantedDate,harvestDate,plantedAreaHa,totalProductionBags,totalCost,status,const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'Harvest(id: $id, areaId: $areaId, areaName: $areaName, cropType: $cropType, plantedDate: $plantedDate, harvestDate: $harvestDate, plantedAreaHa: $plantedAreaHa, totalProductionBags: $totalProductionBags, totalCost: $totalCost, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$HarvestCopyWith<$Res> implements $HarvestCopyWith<$Res> {
  factory _$HarvestCopyWith(_Harvest value, $Res Function(_Harvest) _then) = __$HarvestCopyWithImpl;
@override @useResult
$Res call({
 String id, String areaId, String areaName, String cropType, DateTime plantedDate, DateTime? harvestDate, double plantedAreaHa, double totalProductionBags, double totalCost, String status, List<String> notes
});




}
/// @nodoc
class __$HarvestCopyWithImpl<$Res>
    implements _$HarvestCopyWith<$Res> {
  __$HarvestCopyWithImpl(this._self, this._then);

  final _Harvest _self;
  final $Res Function(_Harvest) _then;

/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? areaId = null,Object? areaName = null,Object? cropType = null,Object? plantedDate = null,Object? harvestDate = freezed,Object? plantedAreaHa = null,Object? totalProductionBags = null,Object? totalCost = null,Object? status = null,Object? notes = null,}) {
  return _then(_Harvest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,areaName: null == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,plantedDate: null == plantedDate ? _self.plantedDate : plantedDate // ignore: cast_nullable_to_non_nullable
as DateTime,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plantedAreaHa: null == plantedAreaHa ? _self.plantedAreaHa : plantedAreaHa // ignore: cast_nullable_to_non_nullable
as double,totalProductionBags: null == totalProductionBags ? _self.totalProductionBags : totalProductionBags // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
