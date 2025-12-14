// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackModel {

 String get id; FeedbackType get type; String get title; String get description; DateTime get createdAt; String get userId; List<String> get screenshots; String get status; String? get response; DateTime? get respondedAt;
/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackModelCopyWith<FeedbackModel> get copyWith => _$FeedbackModelCopyWithImpl<FeedbackModel>(this as FeedbackModel, _$identity);

  /// Serializes this FeedbackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.screenshots, screenshots)&&(identical(other.status, status) || other.status == status)&&(identical(other.response, response) || other.response == response)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,createdAt,userId,const DeepCollectionEquality().hash(screenshots),status,response,respondedAt);

@override
String toString() {
  return 'FeedbackModel(id: $id, type: $type, title: $title, description: $description, createdAt: $createdAt, userId: $userId, screenshots: $screenshots, status: $status, response: $response, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class $FeedbackModelCopyWith<$Res>  {
  factory $FeedbackModelCopyWith(FeedbackModel value, $Res Function(FeedbackModel) _then) = _$FeedbackModelCopyWithImpl;
@useResult
$Res call({
 String id, FeedbackType type, String title, String description, DateTime createdAt, String userId, List<String> screenshots, String status, String? response, DateTime? respondedAt
});




}
/// @nodoc
class _$FeedbackModelCopyWithImpl<$Res>
    implements $FeedbackModelCopyWith<$Res> {
  _$FeedbackModelCopyWithImpl(this._self, this._then);

  final FeedbackModel _self;
  final $Res Function(FeedbackModel) _then;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? createdAt = null,Object? userId = null,Object? screenshots = null,Object? status = null,Object? response = freezed,Object? respondedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeedbackType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,screenshots: null == screenshots ? _self.screenshots : screenshots // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackModel].
extension FeedbackModelPatterns on FeedbackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackModel value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FeedbackType type,  String title,  String description,  DateTime createdAt,  String userId,  List<String> screenshots,  String status,  String? response,  DateTime? respondedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.createdAt,_that.userId,_that.screenshots,_that.status,_that.response,_that.respondedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FeedbackType type,  String title,  String description,  DateTime createdAt,  String userId,  List<String> screenshots,  String status,  String? response,  DateTime? respondedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedbackModel():
return $default(_that.id,_that.type,_that.title,_that.description,_that.createdAt,_that.userId,_that.screenshots,_that.status,_that.response,_that.respondedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FeedbackType type,  String title,  String description,  DateTime createdAt,  String userId,  List<String> screenshots,  String status,  String? response,  DateTime? respondedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.createdAt,_that.userId,_that.screenshots,_that.status,_that.response,_that.respondedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackModel implements FeedbackModel {
  const _FeedbackModel({required this.id, required this.type, required this.title, required this.description, required this.createdAt, required this.userId, final  List<String> screenshots = const [], this.status = 'pending', this.response, this.respondedAt}): _screenshots = screenshots;
  factory _FeedbackModel.fromJson(Map<String, dynamic> json) => _$FeedbackModelFromJson(json);

@override final  String id;
@override final  FeedbackType type;
@override final  String title;
@override final  String description;
@override final  DateTime createdAt;
@override final  String userId;
 final  List<String> _screenshots;
@override@JsonKey() List<String> get screenshots {
  if (_screenshots is EqualUnmodifiableListView) return _screenshots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screenshots);
}

@override@JsonKey() final  String status;
@override final  String? response;
@override final  DateTime? respondedAt;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackModelCopyWith<_FeedbackModel> get copyWith => __$FeedbackModelCopyWithImpl<_FeedbackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._screenshots, _screenshots)&&(identical(other.status, status) || other.status == status)&&(identical(other.response, response) || other.response == response)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,createdAt,userId,const DeepCollectionEquality().hash(_screenshots),status,response,respondedAt);

@override
String toString() {
  return 'FeedbackModel(id: $id, type: $type, title: $title, description: $description, createdAt: $createdAt, userId: $userId, screenshots: $screenshots, status: $status, response: $response, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedbackModelCopyWith<$Res> implements $FeedbackModelCopyWith<$Res> {
  factory _$FeedbackModelCopyWith(_FeedbackModel value, $Res Function(_FeedbackModel) _then) = __$FeedbackModelCopyWithImpl;
@override @useResult
$Res call({
 String id, FeedbackType type, String title, String description, DateTime createdAt, String userId, List<String> screenshots, String status, String? response, DateTime? respondedAt
});




}
/// @nodoc
class __$FeedbackModelCopyWithImpl<$Res>
    implements _$FeedbackModelCopyWith<$Res> {
  __$FeedbackModelCopyWithImpl(this._self, this._then);

  final _FeedbackModel _self;
  final $Res Function(_FeedbackModel) _then;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? createdAt = null,Object? userId = null,Object? screenshots = null,Object? status = null,Object? response = freezed,Object? respondedAt = freezed,}) {
  return _then(_FeedbackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeedbackType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,screenshots: null == screenshots ? _self._screenshots : screenshots // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
