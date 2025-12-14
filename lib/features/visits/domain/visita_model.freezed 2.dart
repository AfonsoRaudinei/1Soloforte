// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visita_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Visita {

 String get id; String get clienteId; String get fazendaId; String get clienteNome; String get fazendaNome; DateTime get startTime; DateTime? get endTime; int? get durationMinutes; String get status;// em_andamento, concluida, cancelada
 String? get observacoes; List<String>? get fotos; String? get talhaoId; String? get talhaoNome;
/// Create a copy of Visita
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitaCopyWith<Visita> get copyWith => _$VisitaCopyWithImpl<Visita>(this as Visita, _$identity);

  /// Serializes this Visita to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Visita&&(identical(other.id, id) || other.id == id)&&(identical(other.clienteId, clienteId) || other.clienteId == clienteId)&&(identical(other.fazendaId, fazendaId) || other.fazendaId == fazendaId)&&(identical(other.clienteNome, clienteNome) || other.clienteNome == clienteNome)&&(identical(other.fazendaNome, fazendaNome) || other.fazendaNome == fazendaNome)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.observacoes, observacoes) || other.observacoes == observacoes)&&const DeepCollectionEquality().equals(other.fotos, fotos)&&(identical(other.talhaoId, talhaoId) || other.talhaoId == talhaoId)&&(identical(other.talhaoNome, talhaoNome) || other.talhaoNome == talhaoNome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clienteId,fazendaId,clienteNome,fazendaNome,startTime,endTime,durationMinutes,status,observacoes,const DeepCollectionEquality().hash(fotos),talhaoId,talhaoNome);

@override
String toString() {
  return 'Visita(id: $id, clienteId: $clienteId, fazendaId: $fazendaId, clienteNome: $clienteNome, fazendaNome: $fazendaNome, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, status: $status, observacoes: $observacoes, fotos: $fotos, talhaoId: $talhaoId, talhaoNome: $talhaoNome)';
}


}

/// @nodoc
abstract mixin class $VisitaCopyWith<$Res>  {
  factory $VisitaCopyWith(Visita value, $Res Function(Visita) _then) = _$VisitaCopyWithImpl;
@useResult
$Res call({
 String id, String clienteId, String fazendaId, String clienteNome, String fazendaNome, DateTime startTime, DateTime? endTime, int? durationMinutes, String status, String? observacoes, List<String>? fotos, String? talhaoId, String? talhaoNome
});




}
/// @nodoc
class _$VisitaCopyWithImpl<$Res>
    implements $VisitaCopyWith<$Res> {
  _$VisitaCopyWithImpl(this._self, this._then);

  final Visita _self;
  final $Res Function(Visita) _then;

/// Create a copy of Visita
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clienteId = null,Object? fazendaId = null,Object? clienteNome = null,Object? fazendaNome = null,Object? startTime = null,Object? endTime = freezed,Object? durationMinutes = freezed,Object? status = null,Object? observacoes = freezed,Object? fotos = freezed,Object? talhaoId = freezed,Object? talhaoNome = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clienteId: null == clienteId ? _self.clienteId : clienteId // ignore: cast_nullable_to_non_nullable
as String,fazendaId: null == fazendaId ? _self.fazendaId : fazendaId // ignore: cast_nullable_to_non_nullable
as String,clienteNome: null == clienteNome ? _self.clienteNome : clienteNome // ignore: cast_nullable_to_non_nullable
as String,fazendaNome: null == fazendaNome ? _self.fazendaNome : fazendaNome // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,observacoes: freezed == observacoes ? _self.observacoes : observacoes // ignore: cast_nullable_to_non_nullable
as String?,fotos: freezed == fotos ? _self.fotos : fotos // ignore: cast_nullable_to_non_nullable
as List<String>?,talhaoId: freezed == talhaoId ? _self.talhaoId : talhaoId // ignore: cast_nullable_to_non_nullable
as String?,talhaoNome: freezed == talhaoNome ? _self.talhaoNome : talhaoNome // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Visita].
extension VisitaPatterns on Visita {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Visita value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Visita() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Visita value)  $default,){
final _that = this;
switch (_that) {
case _Visita():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Visita value)?  $default,){
final _that = this;
switch (_that) {
case _Visita() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clienteId,  String fazendaId,  String clienteNome,  String fazendaNome,  DateTime startTime,  DateTime? endTime,  int? durationMinutes,  String status,  String? observacoes,  List<String>? fotos,  String? talhaoId,  String? talhaoNome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Visita() when $default != null:
return $default(_that.id,_that.clienteId,_that.fazendaId,_that.clienteNome,_that.fazendaNome,_that.startTime,_that.endTime,_that.durationMinutes,_that.status,_that.observacoes,_that.fotos,_that.talhaoId,_that.talhaoNome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clienteId,  String fazendaId,  String clienteNome,  String fazendaNome,  DateTime startTime,  DateTime? endTime,  int? durationMinutes,  String status,  String? observacoes,  List<String>? fotos,  String? talhaoId,  String? talhaoNome)  $default,) {final _that = this;
switch (_that) {
case _Visita():
return $default(_that.id,_that.clienteId,_that.fazendaId,_that.clienteNome,_that.fazendaNome,_that.startTime,_that.endTime,_that.durationMinutes,_that.status,_that.observacoes,_that.fotos,_that.talhaoId,_that.talhaoNome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clienteId,  String fazendaId,  String clienteNome,  String fazendaNome,  DateTime startTime,  DateTime? endTime,  int? durationMinutes,  String status,  String? observacoes,  List<String>? fotos,  String? talhaoId,  String? talhaoNome)?  $default,) {final _that = this;
switch (_that) {
case _Visita() when $default != null:
return $default(_that.id,_that.clienteId,_that.fazendaId,_that.clienteNome,_that.fazendaNome,_that.startTime,_that.endTime,_that.durationMinutes,_that.status,_that.observacoes,_that.fotos,_that.talhaoId,_that.talhaoNome);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Visita implements Visita {
  const _Visita({required this.id, required this.clienteId, required this.fazendaId, required this.clienteNome, required this.fazendaNome, required this.startTime, this.endTime, this.durationMinutes, this.status = 'em_andamento', this.observacoes, final  List<String>? fotos, this.talhaoId, this.talhaoNome}): _fotos = fotos;
  factory _Visita.fromJson(Map<String, dynamic> json) => _$VisitaFromJson(json);

@override final  String id;
@override final  String clienteId;
@override final  String fazendaId;
@override final  String clienteNome;
@override final  String fazendaNome;
@override final  DateTime startTime;
@override final  DateTime? endTime;
@override final  int? durationMinutes;
@override@JsonKey() final  String status;
// em_andamento, concluida, cancelada
@override final  String? observacoes;
 final  List<String>? _fotos;
@override List<String>? get fotos {
  final value = _fotos;
  if (value == null) return null;
  if (_fotos is EqualUnmodifiableListView) return _fotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? talhaoId;
@override final  String? talhaoNome;

/// Create a copy of Visita
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitaCopyWith<_Visita> get copyWith => __$VisitaCopyWithImpl<_Visita>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Visita&&(identical(other.id, id) || other.id == id)&&(identical(other.clienteId, clienteId) || other.clienteId == clienteId)&&(identical(other.fazendaId, fazendaId) || other.fazendaId == fazendaId)&&(identical(other.clienteNome, clienteNome) || other.clienteNome == clienteNome)&&(identical(other.fazendaNome, fazendaNome) || other.fazendaNome == fazendaNome)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.observacoes, observacoes) || other.observacoes == observacoes)&&const DeepCollectionEquality().equals(other._fotos, _fotos)&&(identical(other.talhaoId, talhaoId) || other.talhaoId == talhaoId)&&(identical(other.talhaoNome, talhaoNome) || other.talhaoNome == talhaoNome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clienteId,fazendaId,clienteNome,fazendaNome,startTime,endTime,durationMinutes,status,observacoes,const DeepCollectionEquality().hash(_fotos),talhaoId,talhaoNome);

@override
String toString() {
  return 'Visita(id: $id, clienteId: $clienteId, fazendaId: $fazendaId, clienteNome: $clienteNome, fazendaNome: $fazendaNome, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, status: $status, observacoes: $observacoes, fotos: $fotos, talhaoId: $talhaoId, talhaoNome: $talhaoNome)';
}


}

/// @nodoc
abstract mixin class _$VisitaCopyWith<$Res> implements $VisitaCopyWith<$Res> {
  factory _$VisitaCopyWith(_Visita value, $Res Function(_Visita) _then) = __$VisitaCopyWithImpl;
@override @useResult
$Res call({
 String id, String clienteId, String fazendaId, String clienteNome, String fazendaNome, DateTime startTime, DateTime? endTime, int? durationMinutes, String status, String? observacoes, List<String>? fotos, String? talhaoId, String? talhaoNome
});




}
/// @nodoc
class __$VisitaCopyWithImpl<$Res>
    implements _$VisitaCopyWith<$Res> {
  __$VisitaCopyWithImpl(this._self, this._then);

  final _Visita _self;
  final $Res Function(_Visita) _then;

/// Create a copy of Visita
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clienteId = null,Object? fazendaId = null,Object? clienteNome = null,Object? fazendaNome = null,Object? startTime = null,Object? endTime = freezed,Object? durationMinutes = freezed,Object? status = null,Object? observacoes = freezed,Object? fotos = freezed,Object? talhaoId = freezed,Object? talhaoNome = freezed,}) {
  return _then(_Visita(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clienteId: null == clienteId ? _self.clienteId : clienteId // ignore: cast_nullable_to_non_nullable
as String,fazendaId: null == fazendaId ? _self.fazendaId : fazendaId // ignore: cast_nullable_to_non_nullable
as String,clienteNome: null == clienteNome ? _self.clienteNome : clienteNome // ignore: cast_nullable_to_non_nullable
as String,fazendaNome: null == fazendaNome ? _self.fazendaNome : fazendaNome // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,observacoes: freezed == observacoes ? _self.observacoes : observacoes // ignore: cast_nullable_to_non_nullable
as String?,fotos: freezed == fotos ? _self._fotos : fotos // ignore: cast_nullable_to_non_nullable
as List<String>?,talhaoId: freezed == talhaoId ? _self.talhaoId : talhaoId // ignore: cast_nullable_to_non_nullable
as String?,talhaoNome: freezed == talhaoNome ? _self.talhaoNome : talhaoNome // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
