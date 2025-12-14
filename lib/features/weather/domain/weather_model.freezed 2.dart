// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherForecast {

 double get currentTemp; double get feelsLike; double get humidity; double get windSpeed; String get windDirection; double get precipitation; double get visibility; int get cloudCover; double get uvIndex; String get condition; List<DailyForecast> get daily; List<HourlyForecast> get hourly; List<WeatherAlert> get alerts;
/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherForecastCopyWith<WeatherForecast> get copyWith => _$WeatherForecastCopyWithImpl<WeatherForecast>(this as WeatherForecast, _$identity);

  /// Serializes this WeatherForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherForecast&&(identical(other.currentTemp, currentTemp) || other.currentTemp == currentTemp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.windDirection, windDirection) || other.windDirection == windDirection)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.condition, condition) || other.condition == condition)&&const DeepCollectionEquality().equals(other.daily, daily)&&const DeepCollectionEquality().equals(other.hourly, hourly)&&const DeepCollectionEquality().equals(other.alerts, alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentTemp,feelsLike,humidity,windSpeed,windDirection,precipitation,visibility,cloudCover,uvIndex,condition,const DeepCollectionEquality().hash(daily),const DeepCollectionEquality().hash(hourly),const DeepCollectionEquality().hash(alerts));

@override
String toString() {
  return 'WeatherForecast(currentTemp: $currentTemp, feelsLike: $feelsLike, humidity: $humidity, windSpeed: $windSpeed, windDirection: $windDirection, precipitation: $precipitation, visibility: $visibility, cloudCover: $cloudCover, uvIndex: $uvIndex, condition: $condition, daily: $daily, hourly: $hourly, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class $WeatherForecastCopyWith<$Res>  {
  factory $WeatherForecastCopyWith(WeatherForecast value, $Res Function(WeatherForecast) _then) = _$WeatherForecastCopyWithImpl;
@useResult
$Res call({
 double currentTemp, double feelsLike, double humidity, double windSpeed, String windDirection, double precipitation, double visibility, int cloudCover, double uvIndex, String condition, List<DailyForecast> daily, List<HourlyForecast> hourly, List<WeatherAlert> alerts
});




}
/// @nodoc
class _$WeatherForecastCopyWithImpl<$Res>
    implements $WeatherForecastCopyWith<$Res> {
  _$WeatherForecastCopyWithImpl(this._self, this._then);

  final WeatherForecast _self;
  final $Res Function(WeatherForecast) _then;

/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentTemp = null,Object? feelsLike = null,Object? humidity = null,Object? windSpeed = null,Object? windDirection = null,Object? precipitation = null,Object? visibility = null,Object? cloudCover = null,Object? uvIndex = null,Object? condition = null,Object? daily = null,Object? hourly = null,Object? alerts = null,}) {
  return _then(_self.copyWith(
currentTemp: null == currentTemp ? _self.currentTemp : currentTemp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windDirection: null == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as String,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecast>,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<WeatherAlert>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherForecast].
extension WeatherForecastPatterns on WeatherForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherForecast value)  $default,){
final _that = this;
switch (_that) {
case _WeatherForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherForecast value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double currentTemp,  double feelsLike,  double humidity,  double windSpeed,  String windDirection,  double precipitation,  double visibility,  int cloudCover,  double uvIndex,  String condition,  List<DailyForecast> daily,  List<HourlyForecast> hourly,  List<WeatherAlert> alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
return $default(_that.currentTemp,_that.feelsLike,_that.humidity,_that.windSpeed,_that.windDirection,_that.precipitation,_that.visibility,_that.cloudCover,_that.uvIndex,_that.condition,_that.daily,_that.hourly,_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double currentTemp,  double feelsLike,  double humidity,  double windSpeed,  String windDirection,  double precipitation,  double visibility,  int cloudCover,  double uvIndex,  String condition,  List<DailyForecast> daily,  List<HourlyForecast> hourly,  List<WeatherAlert> alerts)  $default,) {final _that = this;
switch (_that) {
case _WeatherForecast():
return $default(_that.currentTemp,_that.feelsLike,_that.humidity,_that.windSpeed,_that.windDirection,_that.precipitation,_that.visibility,_that.cloudCover,_that.uvIndex,_that.condition,_that.daily,_that.hourly,_that.alerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double currentTemp,  double feelsLike,  double humidity,  double windSpeed,  String windDirection,  double precipitation,  double visibility,  int cloudCover,  double uvIndex,  String condition,  List<DailyForecast> daily,  List<HourlyForecast> hourly,  List<WeatherAlert> alerts)?  $default,) {final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
return $default(_that.currentTemp,_that.feelsLike,_that.humidity,_that.windSpeed,_that.windDirection,_that.precipitation,_that.visibility,_that.cloudCover,_that.uvIndex,_that.condition,_that.daily,_that.hourly,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherForecast implements WeatherForecast {
  const _WeatherForecast({required this.currentTemp, required this.feelsLike, required this.humidity, required this.windSpeed, required this.windDirection, required this.precipitation, required this.visibility, required this.cloudCover, required this.uvIndex, required this.condition, required final  List<DailyForecast> daily, required final  List<HourlyForecast> hourly, final  List<WeatherAlert> alerts = const []}): _daily = daily,_hourly = hourly,_alerts = alerts;
  factory _WeatherForecast.fromJson(Map<String, dynamic> json) => _$WeatherForecastFromJson(json);

@override final  double currentTemp;
@override final  double feelsLike;
@override final  double humidity;
@override final  double windSpeed;
@override final  String windDirection;
@override final  double precipitation;
@override final  double visibility;
@override final  int cloudCover;
@override final  double uvIndex;
@override final  String condition;
 final  List<DailyForecast> _daily;
@override List<DailyForecast> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

 final  List<HourlyForecast> _hourly;
@override List<HourlyForecast> get hourly {
  if (_hourly is EqualUnmodifiableListView) return _hourly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourly);
}

 final  List<WeatherAlert> _alerts;
@override@JsonKey() List<WeatherAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherForecastCopyWith<_WeatherForecast> get copyWith => __$WeatherForecastCopyWithImpl<_WeatherForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherForecast&&(identical(other.currentTemp, currentTemp) || other.currentTemp == currentTemp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.windDirection, windDirection) || other.windDirection == windDirection)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.condition, condition) || other.condition == condition)&&const DeepCollectionEquality().equals(other._daily, _daily)&&const DeepCollectionEquality().equals(other._hourly, _hourly)&&const DeepCollectionEquality().equals(other._alerts, _alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentTemp,feelsLike,humidity,windSpeed,windDirection,precipitation,visibility,cloudCover,uvIndex,condition,const DeepCollectionEquality().hash(_daily),const DeepCollectionEquality().hash(_hourly),const DeepCollectionEquality().hash(_alerts));

@override
String toString() {
  return 'WeatherForecast(currentTemp: $currentTemp, feelsLike: $feelsLike, humidity: $humidity, windSpeed: $windSpeed, windDirection: $windDirection, precipitation: $precipitation, visibility: $visibility, cloudCover: $cloudCover, uvIndex: $uvIndex, condition: $condition, daily: $daily, hourly: $hourly, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$WeatherForecastCopyWith<$Res> implements $WeatherForecastCopyWith<$Res> {
  factory _$WeatherForecastCopyWith(_WeatherForecast value, $Res Function(_WeatherForecast) _then) = __$WeatherForecastCopyWithImpl;
@override @useResult
$Res call({
 double currentTemp, double feelsLike, double humidity, double windSpeed, String windDirection, double precipitation, double visibility, int cloudCover, double uvIndex, String condition, List<DailyForecast> daily, List<HourlyForecast> hourly, List<WeatherAlert> alerts
});




}
/// @nodoc
class __$WeatherForecastCopyWithImpl<$Res>
    implements _$WeatherForecastCopyWith<$Res> {
  __$WeatherForecastCopyWithImpl(this._self, this._then);

  final _WeatherForecast _self;
  final $Res Function(_WeatherForecast) _then;

/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTemp = null,Object? feelsLike = null,Object? humidity = null,Object? windSpeed = null,Object? windDirection = null,Object? precipitation = null,Object? visibility = null,Object? cloudCover = null,Object? uvIndex = null,Object? condition = null,Object? daily = null,Object? hourly = null,Object? alerts = null,}) {
  return _then(_WeatherForecast(
currentTemp: null == currentTemp ? _self.currentTemp : currentTemp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windDirection: null == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as String,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecast>,hourly: null == hourly ? _self._hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<WeatherAlert>,
  ));
}


}


/// @nodoc
mixin _$DailyForecast {

 DateTime get date; double get maxTemp; double get minTemp; String get condition; double get precipitation; double get windSpeed; int get rainProbability;
/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyForecastCopyWith<DailyForecast> get copyWith => _$DailyForecastCopyWithImpl<DailyForecast>(this as DailyForecast, _$identity);

  /// Serializes this DailyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.rainProbability, rainProbability) || other.rainProbability == rainProbability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,maxTemp,minTemp,condition,precipitation,windSpeed,rainProbability);

@override
String toString() {
  return 'DailyForecast(date: $date, maxTemp: $maxTemp, minTemp: $minTemp, condition: $condition, precipitation: $precipitation, windSpeed: $windSpeed, rainProbability: $rainProbability)';
}


}

/// @nodoc
abstract mixin class $DailyForecastCopyWith<$Res>  {
  factory $DailyForecastCopyWith(DailyForecast value, $Res Function(DailyForecast) _then) = _$DailyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime date, double maxTemp, double minTemp, String condition, double precipitation, double windSpeed, int rainProbability
});




}
/// @nodoc
class _$DailyForecastCopyWithImpl<$Res>
    implements $DailyForecastCopyWith<$Res> {
  _$DailyForecastCopyWithImpl(this._self, this._then);

  final DailyForecast _self;
  final $Res Function(DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? maxTemp = null,Object? minTemp = null,Object? condition = null,Object? precipitation = null,Object? windSpeed = null,Object? rainProbability = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,rainProbability: null == rainProbability ? _self.rainProbability : rainProbability // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyForecast].
extension DailyForecastPatterns on DailyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyForecast value)  $default,){
final _that = this;
switch (_that) {
case _DailyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double maxTemp,  double minTemp,  String condition,  double precipitation,  double windSpeed,  int rainProbability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.maxTemp,_that.minTemp,_that.condition,_that.precipitation,_that.windSpeed,_that.rainProbability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double maxTemp,  double minTemp,  String condition,  double precipitation,  double windSpeed,  int rainProbability)  $default,) {final _that = this;
switch (_that) {
case _DailyForecast():
return $default(_that.date,_that.maxTemp,_that.minTemp,_that.condition,_that.precipitation,_that.windSpeed,_that.rainProbability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double maxTemp,  double minTemp,  String condition,  double precipitation,  double windSpeed,  int rainProbability)?  $default,) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.maxTemp,_that.minTemp,_that.condition,_that.precipitation,_that.windSpeed,_that.rainProbability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyForecast implements DailyForecast {
  const _DailyForecast({required this.date, required this.maxTemp, required this.minTemp, required this.condition, required this.precipitation, required this.windSpeed, required this.rainProbability});
  factory _DailyForecast.fromJson(Map<String, dynamic> json) => _$DailyForecastFromJson(json);

@override final  DateTime date;
@override final  double maxTemp;
@override final  double minTemp;
@override final  String condition;
@override final  double precipitation;
@override final  double windSpeed;
@override final  int rainProbability;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyForecastCopyWith<_DailyForecast> get copyWith => __$DailyForecastCopyWithImpl<_DailyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.rainProbability, rainProbability) || other.rainProbability == rainProbability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,maxTemp,minTemp,condition,precipitation,windSpeed,rainProbability);

@override
String toString() {
  return 'DailyForecast(date: $date, maxTemp: $maxTemp, minTemp: $minTemp, condition: $condition, precipitation: $precipitation, windSpeed: $windSpeed, rainProbability: $rainProbability)';
}


}

/// @nodoc
abstract mixin class _$DailyForecastCopyWith<$Res> implements $DailyForecastCopyWith<$Res> {
  factory _$DailyForecastCopyWith(_DailyForecast value, $Res Function(_DailyForecast) _then) = __$DailyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double maxTemp, double minTemp, String condition, double precipitation, double windSpeed, int rainProbability
});




}
/// @nodoc
class __$DailyForecastCopyWithImpl<$Res>
    implements _$DailyForecastCopyWith<$Res> {
  __$DailyForecastCopyWithImpl(this._self, this._then);

  final _DailyForecast _self;
  final $Res Function(_DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? maxTemp = null,Object? minTemp = null,Object? condition = null,Object? precipitation = null,Object? windSpeed = null,Object? rainProbability = null,}) {
  return _then(_DailyForecast(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,rainProbability: null == rainProbability ? _self.rainProbability : rainProbability // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HourlyForecast {

 DateTime get time; double get temp; String get condition; int get rainProbability; double get precipitation;
/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyForecastCopyWith<HourlyForecast> get copyWith => _$HourlyForecastCopyWithImpl<HourlyForecast>(this as HourlyForecast, _$identity);

  /// Serializes this HourlyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.rainProbability, rainProbability) || other.rainProbability == rainProbability)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temp,condition,rainProbability,precipitation);

@override
String toString() {
  return 'HourlyForecast(time: $time, temp: $temp, condition: $condition, rainProbability: $rainProbability, precipitation: $precipitation)';
}


}

/// @nodoc
abstract mixin class $HourlyForecastCopyWith<$Res>  {
  factory $HourlyForecastCopyWith(HourlyForecast value, $Res Function(HourlyForecast) _then) = _$HourlyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temp, String condition, int rainProbability, double precipitation
});




}
/// @nodoc
class _$HourlyForecastCopyWithImpl<$Res>
    implements $HourlyForecastCopyWith<$Res> {
  _$HourlyForecastCopyWithImpl(this._self, this._then);

  final HourlyForecast _self;
  final $Res Function(HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temp = null,Object? condition = null,Object? rainProbability = null,Object? precipitation = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,rainProbability: null == rainProbability ? _self.rainProbability : rainProbability // ignore: cast_nullable_to_non_nullable
as int,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyForecast].
extension HourlyForecastPatterns on HourlyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyForecast value)  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temp,  String condition,  int rainProbability,  double precipitation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temp,_that.condition,_that.rainProbability,_that.precipitation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temp,  String condition,  int rainProbability,  double precipitation)  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast():
return $default(_that.time,_that.temp,_that.condition,_that.rainProbability,_that.precipitation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temp,  String condition,  int rainProbability,  double precipitation)?  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temp,_that.condition,_that.rainProbability,_that.precipitation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyForecast implements HourlyForecast {
  const _HourlyForecast({required this.time, required this.temp, required this.condition, required this.rainProbability, required this.precipitation});
  factory _HourlyForecast.fromJson(Map<String, dynamic> json) => _$HourlyForecastFromJson(json);

@override final  DateTime time;
@override final  double temp;
@override final  String condition;
@override final  int rainProbability;
@override final  double precipitation;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyForecastCopyWith<_HourlyForecast> get copyWith => __$HourlyForecastCopyWithImpl<_HourlyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.rainProbability, rainProbability) || other.rainProbability == rainProbability)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temp,condition,rainProbability,precipitation);

@override
String toString() {
  return 'HourlyForecast(time: $time, temp: $temp, condition: $condition, rainProbability: $rainProbability, precipitation: $precipitation)';
}


}

/// @nodoc
abstract mixin class _$HourlyForecastCopyWith<$Res> implements $HourlyForecastCopyWith<$Res> {
  factory _$HourlyForecastCopyWith(_HourlyForecast value, $Res Function(_HourlyForecast) _then) = __$HourlyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temp, String condition, int rainProbability, double precipitation
});




}
/// @nodoc
class __$HourlyForecastCopyWithImpl<$Res>
    implements _$HourlyForecastCopyWith<$Res> {
  __$HourlyForecastCopyWithImpl(this._self, this._then);

  final _HourlyForecast _self;
  final $Res Function(_HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temp = null,Object? condition = null,Object? rainProbability = null,Object? precipitation = null,}) {
  return _then(_HourlyForecast(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,rainProbability: null == rainProbability ? _self.rainProbability : rainProbability // ignore: cast_nullable_to_non_nullable
as int,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WeatherAlert {

 String get title; String get description; String get severity;// 'low', 'medium', 'high', 'extreme'
 DateTime get effective; DateTime get expires; String get type;
/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherAlertCopyWith<WeatherAlert> get copyWith => _$WeatherAlertCopyWithImpl<WeatherAlert>(this as WeatherAlert, _$identity);

  /// Serializes this WeatherAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherAlert&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.effective, effective) || other.effective == effective)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,severity,effective,expires,type);

@override
String toString() {
  return 'WeatherAlert(title: $title, description: $description, severity: $severity, effective: $effective, expires: $expires, type: $type)';
}


}

/// @nodoc
abstract mixin class $WeatherAlertCopyWith<$Res>  {
  factory $WeatherAlertCopyWith(WeatherAlert value, $Res Function(WeatherAlert) _then) = _$WeatherAlertCopyWithImpl;
@useResult
$Res call({
 String title, String description, String severity, DateTime effective, DateTime expires, String type
});




}
/// @nodoc
class _$WeatherAlertCopyWithImpl<$Res>
    implements $WeatherAlertCopyWith<$Res> {
  _$WeatherAlertCopyWithImpl(this._self, this._then);

  final WeatherAlert _self;
  final $Res Function(WeatherAlert) _then;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? severity = null,Object? effective = null,Object? expires = null,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,effective: null == effective ? _self.effective : effective // ignore: cast_nullable_to_non_nullable
as DateTime,expires: null == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherAlert].
extension WeatherAlertPatterns on WeatherAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherAlert value)  $default,){
final _that = this;
switch (_that) {
case _WeatherAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherAlert value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String severity,  DateTime effective,  DateTime expires,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
return $default(_that.title,_that.description,_that.severity,_that.effective,_that.expires,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String severity,  DateTime effective,  DateTime expires,  String type)  $default,) {final _that = this;
switch (_that) {
case _WeatherAlert():
return $default(_that.title,_that.description,_that.severity,_that.effective,_that.expires,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String severity,  DateTime effective,  DateTime expires,  String type)?  $default,) {final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
return $default(_that.title,_that.description,_that.severity,_that.effective,_that.expires,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherAlert implements WeatherAlert {
  const _WeatherAlert({required this.title, required this.description, required this.severity, required this.effective, required this.expires, required this.type});
  factory _WeatherAlert.fromJson(Map<String, dynamic> json) => _$WeatherAlertFromJson(json);

@override final  String title;
@override final  String description;
@override final  String severity;
// 'low', 'medium', 'high', 'extreme'
@override final  DateTime effective;
@override final  DateTime expires;
@override final  String type;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherAlertCopyWith<_WeatherAlert> get copyWith => __$WeatherAlertCopyWithImpl<_WeatherAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherAlert&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.effective, effective) || other.effective == effective)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,severity,effective,expires,type);

@override
String toString() {
  return 'WeatherAlert(title: $title, description: $description, severity: $severity, effective: $effective, expires: $expires, type: $type)';
}


}

/// @nodoc
abstract mixin class _$WeatherAlertCopyWith<$Res> implements $WeatherAlertCopyWith<$Res> {
  factory _$WeatherAlertCopyWith(_WeatherAlert value, $Res Function(_WeatherAlert) _then) = __$WeatherAlertCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String severity, DateTime effective, DateTime expires, String type
});




}
/// @nodoc
class __$WeatherAlertCopyWithImpl<$Res>
    implements _$WeatherAlertCopyWith<$Res> {
  __$WeatherAlertCopyWithImpl(this._self, this._then);

  final _WeatherAlert _self;
  final $Res Function(_WeatherAlert) _then;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? severity = null,Object? effective = null,Object? expires = null,Object? type = null,}) {
  return _then(_WeatherAlert(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,effective: null == effective ? _self.effective : effective // ignore: cast_nullable_to_non_nullable
as DateTime,expires: null == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
