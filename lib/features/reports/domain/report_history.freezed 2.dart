// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedReport {

 String get id; String get title; ReportTemplate get template; DateTime get createdAt; ReportConfiguration get configuration; String? get pdfPath; int? get fileSizeBytes; bool get isFavorite; String? get sharedLink; DateTime? get lastViewedAt; int get viewCount;
/// Create a copy of SavedReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedReportCopyWith<SavedReport> get copyWith => _$SavedReportCopyWithImpl<SavedReport>(this as SavedReport, _$identity);

  /// Serializes this SavedReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedReport&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.template, template) || other.template == template)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sharedLink, sharedLink) || other.sharedLink == sharedLink)&&(identical(other.lastViewedAt, lastViewedAt) || other.lastViewedAt == lastViewedAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,template,createdAt,configuration,pdfPath,fileSizeBytes,isFavorite,sharedLink,lastViewedAt,viewCount);

@override
String toString() {
  return 'SavedReport(id: $id, title: $title, template: $template, createdAt: $createdAt, configuration: $configuration, pdfPath: $pdfPath, fileSizeBytes: $fileSizeBytes, isFavorite: $isFavorite, sharedLink: $sharedLink, lastViewedAt: $lastViewedAt, viewCount: $viewCount)';
}


}

/// @nodoc
abstract mixin class $SavedReportCopyWith<$Res>  {
  factory $SavedReportCopyWith(SavedReport value, $Res Function(SavedReport) _then) = _$SavedReportCopyWithImpl;
@useResult
$Res call({
 String id, String title, ReportTemplate template, DateTime createdAt, ReportConfiguration configuration, String? pdfPath, int? fileSizeBytes, bool isFavorite, String? sharedLink, DateTime? lastViewedAt, int viewCount
});




}
/// @nodoc
class _$SavedReportCopyWithImpl<$Res>
    implements $SavedReportCopyWith<$Res> {
  _$SavedReportCopyWithImpl(this._self, this._then);

  final SavedReport _self;
  final $Res Function(SavedReport) _then;

/// Create a copy of SavedReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? template = null,Object? createdAt = null,Object? configuration = null,Object? pdfPath = freezed,Object? fileSizeBytes = freezed,Object? isFavorite = null,Object? sharedLink = freezed,Object? lastViewedAt = freezed,Object? viewCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ReportTemplate,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ReportConfiguration,pdfPath: freezed == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,sharedLink: freezed == sharedLink ? _self.sharedLink : sharedLink // ignore: cast_nullable_to_non_nullable
as String?,lastViewedAt: freezed == lastViewedAt ? _self.lastViewedAt : lastViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedReport].
extension SavedReportPatterns on SavedReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedReport value)  $default,){
final _that = this;
switch (_that) {
case _SavedReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedReport value)?  $default,){
final _that = this;
switch (_that) {
case _SavedReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ReportTemplate template,  DateTime createdAt,  ReportConfiguration configuration,  String? pdfPath,  int? fileSizeBytes,  bool isFavorite,  String? sharedLink,  DateTime? lastViewedAt,  int viewCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedReport() when $default != null:
return $default(_that.id,_that.title,_that.template,_that.createdAt,_that.configuration,_that.pdfPath,_that.fileSizeBytes,_that.isFavorite,_that.sharedLink,_that.lastViewedAt,_that.viewCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ReportTemplate template,  DateTime createdAt,  ReportConfiguration configuration,  String? pdfPath,  int? fileSizeBytes,  bool isFavorite,  String? sharedLink,  DateTime? lastViewedAt,  int viewCount)  $default,) {final _that = this;
switch (_that) {
case _SavedReport():
return $default(_that.id,_that.title,_that.template,_that.createdAt,_that.configuration,_that.pdfPath,_that.fileSizeBytes,_that.isFavorite,_that.sharedLink,_that.lastViewedAt,_that.viewCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ReportTemplate template,  DateTime createdAt,  ReportConfiguration configuration,  String? pdfPath,  int? fileSizeBytes,  bool isFavorite,  String? sharedLink,  DateTime? lastViewedAt,  int viewCount)?  $default,) {final _that = this;
switch (_that) {
case _SavedReport() when $default != null:
return $default(_that.id,_that.title,_that.template,_that.createdAt,_that.configuration,_that.pdfPath,_that.fileSizeBytes,_that.isFavorite,_that.sharedLink,_that.lastViewedAt,_that.viewCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedReport implements SavedReport {
  const _SavedReport({required this.id, required this.title, required this.template, required this.createdAt, required this.configuration, this.pdfPath, this.fileSizeBytes, this.isFavorite = false, this.sharedLink, this.lastViewedAt, this.viewCount = 0});
  factory _SavedReport.fromJson(Map<String, dynamic> json) => _$SavedReportFromJson(json);

@override final  String id;
@override final  String title;
@override final  ReportTemplate template;
@override final  DateTime createdAt;
@override final  ReportConfiguration configuration;
@override final  String? pdfPath;
@override final  int? fileSizeBytes;
@override@JsonKey() final  bool isFavorite;
@override final  String? sharedLink;
@override final  DateTime? lastViewedAt;
@override@JsonKey() final  int viewCount;

/// Create a copy of SavedReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedReportCopyWith<_SavedReport> get copyWith => __$SavedReportCopyWithImpl<_SavedReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedReport&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.template, template) || other.template == template)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sharedLink, sharedLink) || other.sharedLink == sharedLink)&&(identical(other.lastViewedAt, lastViewedAt) || other.lastViewedAt == lastViewedAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,template,createdAt,configuration,pdfPath,fileSizeBytes,isFavorite,sharedLink,lastViewedAt,viewCount);

@override
String toString() {
  return 'SavedReport(id: $id, title: $title, template: $template, createdAt: $createdAt, configuration: $configuration, pdfPath: $pdfPath, fileSizeBytes: $fileSizeBytes, isFavorite: $isFavorite, sharedLink: $sharedLink, lastViewedAt: $lastViewedAt, viewCount: $viewCount)';
}


}

/// @nodoc
abstract mixin class _$SavedReportCopyWith<$Res> implements $SavedReportCopyWith<$Res> {
  factory _$SavedReportCopyWith(_SavedReport value, $Res Function(_SavedReport) _then) = __$SavedReportCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ReportTemplate template, DateTime createdAt, ReportConfiguration configuration, String? pdfPath, int? fileSizeBytes, bool isFavorite, String? sharedLink, DateTime? lastViewedAt, int viewCount
});




}
/// @nodoc
class __$SavedReportCopyWithImpl<$Res>
    implements _$SavedReportCopyWith<$Res> {
  __$SavedReportCopyWithImpl(this._self, this._then);

  final _SavedReport _self;
  final $Res Function(_SavedReport) _then;

/// Create a copy of SavedReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? template = null,Object? createdAt = null,Object? configuration = null,Object? pdfPath = freezed,Object? fileSizeBytes = freezed,Object? isFavorite = null,Object? sharedLink = freezed,Object? lastViewedAt = freezed,Object? viewCount = null,}) {
  return _then(_SavedReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ReportTemplate,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ReportConfiguration,pdfPath: freezed == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,sharedLink: freezed == sharedLink ? _self.sharedLink : sharedLink // ignore: cast_nullable_to_non_nullable
as String?,lastViewedAt: freezed == lastViewedAt ? _self.lastViewedAt : lastViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReportSchedule {

 String get id; String get title; ReportTemplate get template; ReportConfiguration get configuration; ScheduleFrequency get frequency; DateTime get nextRunAt; DateTime? get lastRunAt; bool get isActive; List<String>? get emailRecipients; String? get notes;
/// Create a copy of ReportSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportScheduleCopyWith<ReportSchedule> get copyWith => _$ReportScheduleCopyWithImpl<ReportSchedule>(this as ReportSchedule, _$identity);

  /// Serializes this ReportSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.template, template) || other.template == template)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.emailRecipients, emailRecipients)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,template,configuration,frequency,nextRunAt,lastRunAt,isActive,const DeepCollectionEquality().hash(emailRecipients),notes);

@override
String toString() {
  return 'ReportSchedule(id: $id, title: $title, template: $template, configuration: $configuration, frequency: $frequency, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, isActive: $isActive, emailRecipients: $emailRecipients, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ReportScheduleCopyWith<$Res>  {
  factory $ReportScheduleCopyWith(ReportSchedule value, $Res Function(ReportSchedule) _then) = _$ReportScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String title, ReportTemplate template, ReportConfiguration configuration, ScheduleFrequency frequency, DateTime nextRunAt, DateTime? lastRunAt, bool isActive, List<String>? emailRecipients, String? notes
});




}
/// @nodoc
class _$ReportScheduleCopyWithImpl<$Res>
    implements $ReportScheduleCopyWith<$Res> {
  _$ReportScheduleCopyWithImpl(this._self, this._then);

  final ReportSchedule _self;
  final $Res Function(ReportSchedule) _then;

/// Create a copy of ReportSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? template = null,Object? configuration = null,Object? frequency = null,Object? nextRunAt = null,Object? lastRunAt = freezed,Object? isActive = null,Object? emailRecipients = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ReportTemplate,configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ReportConfiguration,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,nextRunAt: null == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,emailRecipients: freezed == emailRecipients ? _self.emailRecipients : emailRecipients // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportSchedule].
extension ReportSchedulePatterns on ReportSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportSchedule value)  $default,){
final _that = this;
switch (_that) {
case _ReportSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _ReportSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ReportTemplate template,  ReportConfiguration configuration,  ScheduleFrequency frequency,  DateTime nextRunAt,  DateTime? lastRunAt,  bool isActive,  List<String>? emailRecipients,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportSchedule() when $default != null:
return $default(_that.id,_that.title,_that.template,_that.configuration,_that.frequency,_that.nextRunAt,_that.lastRunAt,_that.isActive,_that.emailRecipients,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ReportTemplate template,  ReportConfiguration configuration,  ScheduleFrequency frequency,  DateTime nextRunAt,  DateTime? lastRunAt,  bool isActive,  List<String>? emailRecipients,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ReportSchedule():
return $default(_that.id,_that.title,_that.template,_that.configuration,_that.frequency,_that.nextRunAt,_that.lastRunAt,_that.isActive,_that.emailRecipients,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ReportTemplate template,  ReportConfiguration configuration,  ScheduleFrequency frequency,  DateTime nextRunAt,  DateTime? lastRunAt,  bool isActive,  List<String>? emailRecipients,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ReportSchedule() when $default != null:
return $default(_that.id,_that.title,_that.template,_that.configuration,_that.frequency,_that.nextRunAt,_that.lastRunAt,_that.isActive,_that.emailRecipients,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportSchedule implements ReportSchedule {
  const _ReportSchedule({required this.id, required this.title, required this.template, required this.configuration, required this.frequency, required this.nextRunAt, this.lastRunAt, this.isActive = true, final  List<String>? emailRecipients, this.notes}): _emailRecipients = emailRecipients;
  factory _ReportSchedule.fromJson(Map<String, dynamic> json) => _$ReportScheduleFromJson(json);

@override final  String id;
@override final  String title;
@override final  ReportTemplate template;
@override final  ReportConfiguration configuration;
@override final  ScheduleFrequency frequency;
@override final  DateTime nextRunAt;
@override final  DateTime? lastRunAt;
@override@JsonKey() final  bool isActive;
 final  List<String>? _emailRecipients;
@override List<String>? get emailRecipients {
  final value = _emailRecipients;
  if (value == null) return null;
  if (_emailRecipients is EqualUnmodifiableListView) return _emailRecipients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? notes;

/// Create a copy of ReportSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportScheduleCopyWith<_ReportSchedule> get copyWith => __$ReportScheduleCopyWithImpl<_ReportSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.template, template) || other.template == template)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._emailRecipients, _emailRecipients)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,template,configuration,frequency,nextRunAt,lastRunAt,isActive,const DeepCollectionEquality().hash(_emailRecipients),notes);

@override
String toString() {
  return 'ReportSchedule(id: $id, title: $title, template: $template, configuration: $configuration, frequency: $frequency, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, isActive: $isActive, emailRecipients: $emailRecipients, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReportScheduleCopyWith<$Res> implements $ReportScheduleCopyWith<$Res> {
  factory _$ReportScheduleCopyWith(_ReportSchedule value, $Res Function(_ReportSchedule) _then) = __$ReportScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ReportTemplate template, ReportConfiguration configuration, ScheduleFrequency frequency, DateTime nextRunAt, DateTime? lastRunAt, bool isActive, List<String>? emailRecipients, String? notes
});




}
/// @nodoc
class __$ReportScheduleCopyWithImpl<$Res>
    implements _$ReportScheduleCopyWith<$Res> {
  __$ReportScheduleCopyWithImpl(this._self, this._then);

  final _ReportSchedule _self;
  final $Res Function(_ReportSchedule) _then;

/// Create a copy of ReportSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? template = null,Object? configuration = null,Object? frequency = null,Object? nextRunAt = null,Object? lastRunAt = freezed,Object? isActive = null,Object? emailRecipients = freezed,Object? notes = freezed,}) {
  return _then(_ReportSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ReportTemplate,configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ReportConfiguration,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,nextRunAt: null == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,emailRecipients: freezed == emailRecipients ? _self._emailRecipients : emailRecipients // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
