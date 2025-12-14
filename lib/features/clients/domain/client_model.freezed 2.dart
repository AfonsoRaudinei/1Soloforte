// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Client {

 String get id; String get name; String get email; String get phone; String? get cpfCnpj; String get address; String get city; String get state; String get type;// 'producer', 'consultant'
 String get status;// 'active', 'inactive'
 DateTime get lastActivity; String? get avatarUrl; String? get notes; List<String> get farmIds;
/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientCopyWith<Client> get copyWith => _$ClientCopyWithImpl<Client>(this as Client, _$identity);

  /// Serializes this Client to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Client&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cpfCnpj, cpfCnpj) || other.cpfCnpj == cpfCnpj)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.farmIds, farmIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,cpfCnpj,address,city,state,type,status,lastActivity,avatarUrl,notes,const DeepCollectionEquality().hash(farmIds));

@override
String toString() {
  return 'Client(id: $id, name: $name, email: $email, phone: $phone, cpfCnpj: $cpfCnpj, address: $address, city: $city, state: $state, type: $type, status: $status, lastActivity: $lastActivity, avatarUrl: $avatarUrl, notes: $notes, farmIds: $farmIds)';
}


}

/// @nodoc
abstract mixin class $ClientCopyWith<$Res>  {
  factory $ClientCopyWith(Client value, $Res Function(Client) _then) = _$ClientCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String phone, String? cpfCnpj, String address, String city, String state, String type, String status, DateTime lastActivity, String? avatarUrl, String? notes, List<String> farmIds
});




}
/// @nodoc
class _$ClientCopyWithImpl<$Res>
    implements $ClientCopyWith<$Res> {
  _$ClientCopyWithImpl(this._self, this._then);

  final Client _self;
  final $Res Function(Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? cpfCnpj = freezed,Object? address = null,Object? city = null,Object? state = null,Object? type = null,Object? status = null,Object? lastActivity = null,Object? avatarUrl = freezed,Object? notes = freezed,Object? farmIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cpfCnpj: freezed == cpfCnpj ? _self.cpfCnpj : cpfCnpj // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActivity: null == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,farmIds: null == farmIds ? _self.farmIds : farmIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Client].
extension ClientPatterns on Client {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Client value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Client value)  $default,){
final _that = this;
switch (_that) {
case _Client():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Client value)?  $default,){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  String? cpfCnpj,  String address,  String city,  String state,  String type,  String status,  DateTime lastActivity,  String? avatarUrl,  String? notes,  List<String> farmIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.cpfCnpj,_that.address,_that.city,_that.state,_that.type,_that.status,_that.lastActivity,_that.avatarUrl,_that.notes,_that.farmIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  String? cpfCnpj,  String address,  String city,  String state,  String type,  String status,  DateTime lastActivity,  String? avatarUrl,  String? notes,  List<String> farmIds)  $default,) {final _that = this;
switch (_that) {
case _Client():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.cpfCnpj,_that.address,_that.city,_that.state,_that.type,_that.status,_that.lastActivity,_that.avatarUrl,_that.notes,_that.farmIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String phone,  String? cpfCnpj,  String address,  String city,  String state,  String type,  String status,  DateTime lastActivity,  String? avatarUrl,  String? notes,  List<String> farmIds)?  $default,) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.cpfCnpj,_that.address,_that.city,_that.state,_that.type,_that.status,_that.lastActivity,_that.avatarUrl,_that.notes,_that.farmIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Client extends Client {
  const _Client({required this.id, required this.name, required this.email, required this.phone, this.cpfCnpj, required this.address, required this.city, required this.state, required this.type, required this.status, required this.lastActivity, this.avatarUrl, this.notes, final  List<String> farmIds = const []}): _farmIds = farmIds,super._();
  factory _Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String phone;
@override final  String? cpfCnpj;
@override final  String address;
@override final  String city;
@override final  String state;
@override final  String type;
// 'producer', 'consultant'
@override final  String status;
// 'active', 'inactive'
@override final  DateTime lastActivity;
@override final  String? avatarUrl;
@override final  String? notes;
 final  List<String> _farmIds;
@override@JsonKey() List<String> get farmIds {
  if (_farmIds is EqualUnmodifiableListView) return _farmIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_farmIds);
}


/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientCopyWith<_Client> get copyWith => __$ClientCopyWithImpl<_Client>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Client&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.cpfCnpj, cpfCnpj) || other.cpfCnpj == cpfCnpj)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._farmIds, _farmIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,cpfCnpj,address,city,state,type,status,lastActivity,avatarUrl,notes,const DeepCollectionEquality().hash(_farmIds));

@override
String toString() {
  return 'Client(id: $id, name: $name, email: $email, phone: $phone, cpfCnpj: $cpfCnpj, address: $address, city: $city, state: $state, type: $type, status: $status, lastActivity: $lastActivity, avatarUrl: $avatarUrl, notes: $notes, farmIds: $farmIds)';
}


}

/// @nodoc
abstract mixin class _$ClientCopyWith<$Res> implements $ClientCopyWith<$Res> {
  factory _$ClientCopyWith(_Client value, $Res Function(_Client) _then) = __$ClientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String phone, String? cpfCnpj, String address, String city, String state, String type, String status, DateTime lastActivity, String? avatarUrl, String? notes, List<String> farmIds
});




}
/// @nodoc
class __$ClientCopyWithImpl<$Res>
    implements _$ClientCopyWith<$Res> {
  __$ClientCopyWithImpl(this._self, this._then);

  final _Client _self;
  final $Res Function(_Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? cpfCnpj = freezed,Object? address = null,Object? city = null,Object? state = null,Object? type = null,Object? status = null,Object? lastActivity = null,Object? avatarUrl = freezed,Object? notes = freezed,Object? farmIds = null,}) {
  return _then(_Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,cpfCnpj: freezed == cpfCnpj ? _self.cpfCnpj : cpfCnpj // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActivity: null == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,farmIds: null == farmIds ? _self._farmIds : farmIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
