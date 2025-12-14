// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Farm {

 String get id; String get clientId; String get name; String get city; String get state; String? get address; double? get totalAreaHa; int? get totalAreas; String? get description; bool get isActive; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmCopyWith<Farm> get copyWith => _$FarmCopyWithImpl<Farm>(this as Farm, _$identity);

  /// Serializes this Farm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.address, address) || other.address == address)&&(identical(other.totalAreaHa, totalAreaHa) || other.totalAreaHa == totalAreaHa)&&(identical(other.totalAreas, totalAreas) || other.totalAreas == totalAreas)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,name,city,state,address,totalAreaHa,totalAreas,description,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'Farm(id: $id, clientId: $clientId, name: $name, city: $city, state: $state, address: $address, totalAreaHa: $totalAreaHa, totalAreas: $totalAreas, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FarmCopyWith<$Res>  {
  factory $FarmCopyWith(Farm value, $Res Function(Farm) _then) = _$FarmCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String name, String city, String state, String? address, double? totalAreaHa, int? totalAreas, String? description, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$FarmCopyWithImpl<$Res>
    implements $FarmCopyWith<$Res> {
  _$FarmCopyWithImpl(this._self, this._then);

  final Farm _self;
  final $Res Function(Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? name = null,Object? city = null,Object? state = null,Object? address = freezed,Object? totalAreaHa = freezed,Object? totalAreas = freezed,Object? description = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,totalAreaHa: freezed == totalAreaHa ? _self.totalAreaHa : totalAreaHa // ignore: cast_nullable_to_non_nullable
as double?,totalAreas: freezed == totalAreas ? _self.totalAreas : totalAreas // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Farm].
extension FarmPatterns on Farm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Farm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Farm value)  $default,){
final _that = this;
switch (_that) {
case _Farm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Farm value)?  $default,){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String name,  String city,  String state,  String? address,  double? totalAreaHa,  int? totalAreas,  String? description,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.clientId,_that.name,_that.city,_that.state,_that.address,_that.totalAreaHa,_that.totalAreas,_that.description,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String name,  String city,  String state,  String? address,  double? totalAreaHa,  int? totalAreas,  String? description,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Farm():
return $default(_that.id,_that.clientId,_that.name,_that.city,_that.state,_that.address,_that.totalAreaHa,_that.totalAreas,_that.description,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String name,  String city,  String state,  String? address,  double? totalAreaHa,  int? totalAreas,  String? description,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.clientId,_that.name,_that.city,_that.state,_that.address,_that.totalAreaHa,_that.totalAreas,_that.description,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Farm implements Farm {
  const _Farm({required this.id, required this.clientId, required this.name, required this.city, required this.state, this.address, this.totalAreaHa, this.totalAreas, this.description, this.isActive = true, this.createdAt, this.updatedAt});
  factory _Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String name;
@override final  String city;
@override final  String state;
@override final  String? address;
@override final  double? totalAreaHa;
@override final  int? totalAreas;
@override final  String? description;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmCopyWith<_Farm> get copyWith => __$FarmCopyWithImpl<_Farm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.address, address) || other.address == address)&&(identical(other.totalAreaHa, totalAreaHa) || other.totalAreaHa == totalAreaHa)&&(identical(other.totalAreas, totalAreas) || other.totalAreas == totalAreas)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,name,city,state,address,totalAreaHa,totalAreas,description,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'Farm(id: $id, clientId: $clientId, name: $name, city: $city, state: $state, address: $address, totalAreaHa: $totalAreaHa, totalAreas: $totalAreas, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FarmCopyWith<$Res> implements $FarmCopyWith<$Res> {
  factory _$FarmCopyWith(_Farm value, $Res Function(_Farm) _then) = __$FarmCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String name, String city, String state, String? address, double? totalAreaHa, int? totalAreas, String? description, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$FarmCopyWithImpl<$Res>
    implements _$FarmCopyWith<$Res> {
  __$FarmCopyWithImpl(this._self, this._then);

  final _Farm _self;
  final $Res Function(_Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? name = null,Object? city = null,Object? state = null,Object? address = freezed,Object? totalAreaHa = freezed,Object? totalAreas = freezed,Object? description = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Farm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,totalAreaHa: freezed == totalAreaHa ? _self.totalAreaHa : totalAreaHa // ignore: cast_nullable_to_non_nullable
as double?,totalAreas: freezed == totalAreas ? _self.totalAreas : totalAreas // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
