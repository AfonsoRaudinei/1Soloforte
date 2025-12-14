// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Area {

 String get id; String get name; double get hectares; String get clienteNome; String get fazendaNome; String get status;// active, monitoring, inactive
 List<LatLng> get coordinates; String? get culture; String? get safra; double get ndviAverage; DateTime? get lastUpdate;
/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaCopyWith<Area> get copyWith => _$AreaCopyWithImpl<Area>(this as Area, _$identity);

  /// Serializes this Area to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Area&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hectares, hectares) || other.hectares == hectares)&&(identical(other.clienteNome, clienteNome) || other.clienteNome == clienteNome)&&(identical(other.fazendaNome, fazendaNome) || other.fazendaNome == fazendaNome)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.coordinates, coordinates)&&(identical(other.culture, culture) || other.culture == culture)&&(identical(other.safra, safra) || other.safra == safra)&&(identical(other.ndviAverage, ndviAverage) || other.ndviAverage == ndviAverage)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hectares,clienteNome,fazendaNome,status,const DeepCollectionEquality().hash(coordinates),culture,safra,ndviAverage,lastUpdate);

@override
String toString() {
  return 'Area(id: $id, name: $name, hectares: $hectares, clienteNome: $clienteNome, fazendaNome: $fazendaNome, status: $status, coordinates: $coordinates, culture: $culture, safra: $safra, ndviAverage: $ndviAverage, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class $AreaCopyWith<$Res>  {
  factory $AreaCopyWith(Area value, $Res Function(Area) _then) = _$AreaCopyWithImpl;
@useResult
$Res call({
 String id, String name, double hectares, String clienteNome, String fazendaNome, String status, List<LatLng> coordinates, String? culture, String? safra, double ndviAverage, DateTime? lastUpdate
});




}
/// @nodoc
class _$AreaCopyWithImpl<$Res>
    implements $AreaCopyWith<$Res> {
  _$AreaCopyWithImpl(this._self, this._then);

  final Area _self;
  final $Res Function(Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hectares = null,Object? clienteNome = null,Object? fazendaNome = null,Object? status = null,Object? coordinates = null,Object? culture = freezed,Object? safra = freezed,Object? ndviAverage = null,Object? lastUpdate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hectares: null == hectares ? _self.hectares : hectares // ignore: cast_nullable_to_non_nullable
as double,clienteNome: null == clienteNome ? _self.clienteNome : clienteNome // ignore: cast_nullable_to_non_nullable
as String,fazendaNome: null == fazendaNome ? _self.fazendaNome : fazendaNome // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<LatLng>,culture: freezed == culture ? _self.culture : culture // ignore: cast_nullable_to_non_nullable
as String?,safra: freezed == safra ? _self.safra : safra // ignore: cast_nullable_to_non_nullable
as String?,ndviAverage: null == ndviAverage ? _self.ndviAverage : ndviAverage // ignore: cast_nullable_to_non_nullable
as double,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Area].
extension AreaPatterns on Area {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Area value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Area() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Area value)  $default,){
final _that = this;
switch (_that) {
case _Area():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Area value)?  $default,){
final _that = this;
switch (_that) {
case _Area() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double hectares,  String clienteNome,  String fazendaNome,  String status,  List<LatLng> coordinates,  String? culture,  String? safra,  double ndviAverage,  DateTime? lastUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.id,_that.name,_that.hectares,_that.clienteNome,_that.fazendaNome,_that.status,_that.coordinates,_that.culture,_that.safra,_that.ndviAverage,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double hectares,  String clienteNome,  String fazendaNome,  String status,  List<LatLng> coordinates,  String? culture,  String? safra,  double ndviAverage,  DateTime? lastUpdate)  $default,) {final _that = this;
switch (_that) {
case _Area():
return $default(_that.id,_that.name,_that.hectares,_that.clienteNome,_that.fazendaNome,_that.status,_that.coordinates,_that.culture,_that.safra,_that.ndviAverage,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double hectares,  String clienteNome,  String fazendaNome,  String status,  List<LatLng> coordinates,  String? culture,  String? safra,  double ndviAverage,  DateTime? lastUpdate)?  $default,) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.id,_that.name,_that.hectares,_that.clienteNome,_that.fazendaNome,_that.status,_that.coordinates,_that.culture,_that.safra,_that.ndviAverage,_that.lastUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Area implements Area {
  const _Area({required this.id, required this.name, required this.hectares, required this.clienteNome, required this.fazendaNome, this.status = 'active', required final  List<LatLng> coordinates, this.culture, this.safra, this.ndviAverage = 0.0, this.lastUpdate}): _coordinates = coordinates;
  factory _Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

@override final  String id;
@override final  String name;
@override final  double hectares;
@override final  String clienteNome;
@override final  String fazendaNome;
@override@JsonKey() final  String status;
// active, monitoring, inactive
 final  List<LatLng> _coordinates;
// active, monitoring, inactive
@override List<LatLng> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}

@override final  String? culture;
@override final  String? safra;
@override@JsonKey() final  double ndviAverage;
@override final  DateTime? lastUpdate;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaCopyWith<_Area> get copyWith => __$AreaCopyWithImpl<_Area>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AreaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Area&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hectares, hectares) || other.hectares == hectares)&&(identical(other.clienteNome, clienteNome) || other.clienteNome == clienteNome)&&(identical(other.fazendaNome, fazendaNome) || other.fazendaNome == fazendaNome)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates)&&(identical(other.culture, culture) || other.culture == culture)&&(identical(other.safra, safra) || other.safra == safra)&&(identical(other.ndviAverage, ndviAverage) || other.ndviAverage == ndviAverage)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hectares,clienteNome,fazendaNome,status,const DeepCollectionEquality().hash(_coordinates),culture,safra,ndviAverage,lastUpdate);

@override
String toString() {
  return 'Area(id: $id, name: $name, hectares: $hectares, clienteNome: $clienteNome, fazendaNome: $fazendaNome, status: $status, coordinates: $coordinates, culture: $culture, safra: $safra, ndviAverage: $ndviAverage, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class _$AreaCopyWith<$Res> implements $AreaCopyWith<$Res> {
  factory _$AreaCopyWith(_Area value, $Res Function(_Area) _then) = __$AreaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double hectares, String clienteNome, String fazendaNome, String status, List<LatLng> coordinates, String? culture, String? safra, double ndviAverage, DateTime? lastUpdate
});




}
/// @nodoc
class __$AreaCopyWithImpl<$Res>
    implements _$AreaCopyWith<$Res> {
  __$AreaCopyWithImpl(this._self, this._then);

  final _Area _self;
  final $Res Function(_Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hectares = null,Object? clienteNome = null,Object? fazendaNome = null,Object? status = null,Object? coordinates = null,Object? culture = freezed,Object? safra = freezed,Object? ndviAverage = null,Object? lastUpdate = freezed,}) {
  return _then(_Area(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hectares: null == hectares ? _self.hectares : hectares // ignore: cast_nullable_to_non_nullable
as double,clienteNome: null == clienteNome ? _self.clienteNome : clienteNome // ignore: cast_nullable_to_non_nullable
as String,fazendaNome: null == fazendaNome ? _self.fazendaNome : fazendaNome // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<LatLng>,culture: freezed == culture ? _self.culture : culture // ignore: cast_nullable_to_non_nullable
as String?,safra: freezed == safra ? _self.safra : safra // ignore: cast_nullable_to_non_nullable
as String?,ndviAverage: null == ndviAverage ? _self.ndviAverage : ndviAverage // ignore: cast_nullable_to_non_nullable
as double,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
