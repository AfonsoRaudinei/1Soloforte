// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occurrence_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OccurrenceDto _$OccurrenceDtoFromJson(Map<String, dynamic> json) {
  return _OccurrenceDto.fromJson(json);
}

/// @nodoc
mixin _$OccurrenceDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get severity => throw _privateConstructorUsedError;
  String get areaName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  List<TimelineEventDto> get timeline => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  String get phenologicalStage => throw _privateConstructorUsedError;
  Map<String, double> get categorySeverities =>
      throw _privateConstructorUsedError;
  Map<String, List<String>> get categoryImages =>
      throw _privateConstructorUsedError;
  String get technicalRecommendation => throw _privateConstructorUsedError;
  String get technicalResponsible => throw _privateConstructorUsedError;
  String get temporalType => throw _privateConstructorUsedError;
  bool get hasSoilSample => throw _privateConstructorUsedError;

  /// Serializes this OccurrenceDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OccurrenceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccurrenceDtoCopyWith<OccurrenceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccurrenceDtoCopyWith<$Res> {
  factory $OccurrenceDtoCopyWith(
    OccurrenceDto value,
    $Res Function(OccurrenceDto) then,
  ) = _$OccurrenceDtoCopyWithImpl<$Res, OccurrenceDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String type,
    double severity,
    String areaName,
    DateTime date,
    String status,
    List<String> images,
    double latitude,
    double longitude,
    List<TimelineEventDto> timeline,
    String? assignedTo,
    List<String> recommendations,
    String phenologicalStage,
    Map<String, double> categorySeverities,
    Map<String, List<String>> categoryImages,
    String technicalRecommendation,
    String technicalResponsible,
    String temporalType,
    bool hasSoilSample,
  });
}

/// @nodoc
class _$OccurrenceDtoCopyWithImpl<$Res, $Val extends OccurrenceDto>
    implements $OccurrenceDtoCopyWith<$Res> {
  _$OccurrenceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OccurrenceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? severity = null,
    Object? areaName = null,
    Object? date = null,
    Object? status = null,
    Object? images = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? timeline = null,
    Object? assignedTo = freezed,
    Object? recommendations = null,
    Object? phenologicalStage = null,
    Object? categorySeverities = null,
    Object? categoryImages = null,
    Object? technicalRecommendation = null,
    Object? technicalResponsible = null,
    Object? temporalType = null,
    Object? hasSoilSample = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as double,
            areaName: null == areaName
                ? _value.areaName
                : areaName // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            timeline: null == timeline
                ? _value.timeline
                : timeline // ignore: cast_nullable_to_non_nullable
                      as List<TimelineEventDto>,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            phenologicalStage: null == phenologicalStage
                ? _value.phenologicalStage
                : phenologicalStage // ignore: cast_nullable_to_non_nullable
                      as String,
            categorySeverities: null == categorySeverities
                ? _value.categorySeverities
                : categorySeverities // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            categoryImages: null == categoryImages
                ? _value.categoryImages
                : categoryImages // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<String>>,
            technicalRecommendation: null == technicalRecommendation
                ? _value.technicalRecommendation
                : technicalRecommendation // ignore: cast_nullable_to_non_nullable
                      as String,
            technicalResponsible: null == technicalResponsible
                ? _value.technicalResponsible
                : technicalResponsible // ignore: cast_nullable_to_non_nullable
                      as String,
            temporalType: null == temporalType
                ? _value.temporalType
                : temporalType // ignore: cast_nullable_to_non_nullable
                      as String,
            hasSoilSample: null == hasSoilSample
                ? _value.hasSoilSample
                : hasSoilSample // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OccurrenceDtoImplCopyWith<$Res>
    implements $OccurrenceDtoCopyWith<$Res> {
  factory _$$OccurrenceDtoImplCopyWith(
    _$OccurrenceDtoImpl value,
    $Res Function(_$OccurrenceDtoImpl) then,
  ) = __$$OccurrenceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String type,
    double severity,
    String areaName,
    DateTime date,
    String status,
    List<String> images,
    double latitude,
    double longitude,
    List<TimelineEventDto> timeline,
    String? assignedTo,
    List<String> recommendations,
    String phenologicalStage,
    Map<String, double> categorySeverities,
    Map<String, List<String>> categoryImages,
    String technicalRecommendation,
    String technicalResponsible,
    String temporalType,
    bool hasSoilSample,
  });
}

/// @nodoc
class __$$OccurrenceDtoImplCopyWithImpl<$Res>
    extends _$OccurrenceDtoCopyWithImpl<$Res, _$OccurrenceDtoImpl>
    implements _$$OccurrenceDtoImplCopyWith<$Res> {
  __$$OccurrenceDtoImplCopyWithImpl(
    _$OccurrenceDtoImpl _value,
    $Res Function(_$OccurrenceDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OccurrenceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? severity = null,
    Object? areaName = null,
    Object? date = null,
    Object? status = null,
    Object? images = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? timeline = null,
    Object? assignedTo = freezed,
    Object? recommendations = null,
    Object? phenologicalStage = null,
    Object? categorySeverities = null,
    Object? categoryImages = null,
    Object? technicalRecommendation = null,
    Object? technicalResponsible = null,
    Object? temporalType = null,
    Object? hasSoilSample = null,
  }) {
    return _then(
      _$OccurrenceDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as double,
        areaName: null == areaName
            ? _value.areaName
            : areaName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        timeline: null == timeline
            ? _value._timeline
            : timeline // ignore: cast_nullable_to_non_nullable
                  as List<TimelineEventDto>,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        phenologicalStage: null == phenologicalStage
            ? _value.phenologicalStage
            : phenologicalStage // ignore: cast_nullable_to_non_nullable
                  as String,
        categorySeverities: null == categorySeverities
            ? _value._categorySeverities
            : categorySeverities // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        categoryImages: null == categoryImages
            ? _value._categoryImages
            : categoryImages // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        technicalRecommendation: null == technicalRecommendation
            ? _value.technicalRecommendation
            : technicalRecommendation // ignore: cast_nullable_to_non_nullable
                  as String,
        technicalResponsible: null == technicalResponsible
            ? _value.technicalResponsible
            : technicalResponsible // ignore: cast_nullable_to_non_nullable
                  as String,
        temporalType: null == temporalType
            ? _value.temporalType
            : temporalType // ignore: cast_nullable_to_non_nullable
                  as String,
        hasSoilSample: null == hasSoilSample
            ? _value.hasSoilSample
            : hasSoilSample // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OccurrenceDtoImpl extends _OccurrenceDto {
  const _$OccurrenceDtoImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.areaName,
    required this.date,
    required this.status,
    required final List<String> images,
    required this.latitude,
    required this.longitude,
    final List<TimelineEventDto> timeline = const [],
    this.assignedTo,
    final List<String> recommendations = const [],
    this.phenologicalStage = 'VE - Emergência',
    final Map<String, double> categorySeverities = const {},
    final Map<String, List<String>> categoryImages = const {},
    this.technicalRecommendation = '',
    this.technicalResponsible = '',
    this.temporalType = 'Sazonal',
    this.hasSoilSample = false,
  }) : _images = images,
       _timeline = timeline,
       _recommendations = recommendations,
       _categorySeverities = categorySeverities,
       _categoryImages = categoryImages,
       super._();

  factory _$OccurrenceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccurrenceDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String type;
  @override
  final double severity;
  @override
  final String areaName;
  @override
  final DateTime date;
  @override
  final String status;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final double latitude;
  @override
  final double longitude;
  final List<TimelineEventDto> _timeline;
  @override
  @JsonKey()
  List<TimelineEventDto> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  final String? assignedTo;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  @JsonKey()
  final String phenologicalStage;
  final Map<String, double> _categorySeverities;
  @override
  @JsonKey()
  Map<String, double> get categorySeverities {
    if (_categorySeverities is EqualUnmodifiableMapView)
      return _categorySeverities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categorySeverities);
  }

  final Map<String, List<String>> _categoryImages;
  @override
  @JsonKey()
  Map<String, List<String>> get categoryImages {
    if (_categoryImages is EqualUnmodifiableMapView) return _categoryImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryImages);
  }

  @override
  @JsonKey()
  final String technicalRecommendation;
  @override
  @JsonKey()
  final String technicalResponsible;
  @override
  @JsonKey()
  final String temporalType;
  @override
  @JsonKey()
  final bool hasSoilSample;

  @override
  String toString() {
    return 'OccurrenceDto(id: $id, title: $title, description: $description, type: $type, severity: $severity, areaName: $areaName, date: $date, status: $status, images: $images, latitude: $latitude, longitude: $longitude, timeline: $timeline, assignedTo: $assignedTo, recommendations: $recommendations, phenologicalStage: $phenologicalStage, categorySeverities: $categorySeverities, categoryImages: $categoryImages, technicalRecommendation: $technicalRecommendation, technicalResponsible: $technicalResponsible, temporalType: $temporalType, hasSoilSample: $hasSoilSample)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccurrenceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.phenologicalStage, phenologicalStage) ||
                other.phenologicalStage == phenologicalStage) &&
            const DeepCollectionEquality().equals(
              other._categorySeverities,
              _categorySeverities,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryImages,
              _categoryImages,
            ) &&
            (identical(
                  other.technicalRecommendation,
                  technicalRecommendation,
                ) ||
                other.technicalRecommendation == technicalRecommendation) &&
            (identical(other.technicalResponsible, technicalResponsible) ||
                other.technicalResponsible == technicalResponsible) &&
            (identical(other.temporalType, temporalType) ||
                other.temporalType == temporalType) &&
            (identical(other.hasSoilSample, hasSoilSample) ||
                other.hasSoilSample == hasSoilSample));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    type,
    severity,
    areaName,
    date,
    status,
    const DeepCollectionEquality().hash(_images),
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_timeline),
    assignedTo,
    const DeepCollectionEquality().hash(_recommendations),
    phenologicalStage,
    const DeepCollectionEquality().hash(_categorySeverities),
    const DeepCollectionEquality().hash(_categoryImages),
    technicalRecommendation,
    technicalResponsible,
    temporalType,
    hasSoilSample,
  ]);

  /// Create a copy of OccurrenceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccurrenceDtoImplCopyWith<_$OccurrenceDtoImpl> get copyWith =>
      __$$OccurrenceDtoImplCopyWithImpl<_$OccurrenceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccurrenceDtoImplToJson(this);
  }
}

abstract class _OccurrenceDto extends OccurrenceDto {
  const factory _OccurrenceDto({
    required final String id,
    required final String title,
    required final String description,
    required final String type,
    required final double severity,
    required final String areaName,
    required final DateTime date,
    required final String status,
    required final List<String> images,
    required final double latitude,
    required final double longitude,
    final List<TimelineEventDto> timeline,
    final String? assignedTo,
    final List<String> recommendations,
    final String phenologicalStage,
    final Map<String, double> categorySeverities,
    final Map<String, List<String>> categoryImages,
    final String technicalRecommendation,
    final String technicalResponsible,
    final String temporalType,
    final bool hasSoilSample,
  }) = _$OccurrenceDtoImpl;
  const _OccurrenceDto._() : super._();

  factory _OccurrenceDto.fromJson(Map<String, dynamic> json) =
      _$OccurrenceDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get type;
  @override
  double get severity;
  @override
  String get areaName;
  @override
  DateTime get date;
  @override
  String get status;
  @override
  List<String> get images;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  List<TimelineEventDto> get timeline;
  @override
  String? get assignedTo;
  @override
  List<String> get recommendations;
  @override
  String get phenologicalStage;
  @override
  Map<String, double> get categorySeverities;
  @override
  Map<String, List<String>> get categoryImages;
  @override
  String get technicalRecommendation;
  @override
  String get technicalResponsible;
  @override
  String get temporalType;
  @override
  bool get hasSoilSample;

  /// Create a copy of OccurrenceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccurrenceDtoImplCopyWith<_$OccurrenceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineEventDto _$TimelineEventDtoFromJson(Map<String, dynamic> json) {
  return _TimelineEventDto.fromJson(json);
}

/// @nodoc
mixin _$TimelineEventDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;

  /// Serializes this TimelineEventDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineEventDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineEventDtoCopyWith<TimelineEventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineEventDtoCopyWith<$Res> {
  factory $TimelineEventDtoCopyWith(
    TimelineEventDto value,
    $Res Function(TimelineEventDto) then,
  ) = _$TimelineEventDtoCopyWithImpl<$Res, TimelineEventDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime date,
    String type,
    String authorName,
  });
}

/// @nodoc
class _$TimelineEventDtoCopyWithImpl<$Res, $Val extends TimelineEventDto>
    implements $TimelineEventDtoCopyWith<$Res> {
  _$TimelineEventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineEventDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? authorName = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimelineEventDtoImplCopyWith<$Res>
    implements $TimelineEventDtoCopyWith<$Res> {
  factory _$$TimelineEventDtoImplCopyWith(
    _$TimelineEventDtoImpl value,
    $Res Function(_$TimelineEventDtoImpl) then,
  ) = __$$TimelineEventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime date,
    String type,
    String authorName,
  });
}

/// @nodoc
class __$$TimelineEventDtoImplCopyWithImpl<$Res>
    extends _$TimelineEventDtoCopyWithImpl<$Res, _$TimelineEventDtoImpl>
    implements _$$TimelineEventDtoImplCopyWith<$Res> {
  __$$TimelineEventDtoImplCopyWithImpl(
    _$TimelineEventDtoImpl _value,
    $Res Function(_$TimelineEventDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimelineEventDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? authorName = null,
  }) {
    return _then(
      _$TimelineEventDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineEventDtoImpl extends _TimelineEventDto {
  const _$TimelineEventDtoImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.authorName,
  }) : super._();

  factory _$TimelineEventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineEventDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime date;
  @override
  final String type;
  @override
  final String authorName;

  @override
  String toString() {
    return 'TimelineEventDto(id: $id, title: $title, description: $description, date: $date, type: $type, authorName: $authorName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineEventDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, date, type, authorName);

  /// Create a copy of TimelineEventDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineEventDtoImplCopyWith<_$TimelineEventDtoImpl> get copyWith =>
      __$$TimelineEventDtoImplCopyWithImpl<_$TimelineEventDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineEventDtoImplToJson(this);
  }
}

abstract class _TimelineEventDto extends TimelineEventDto {
  const factory _TimelineEventDto({
    required final String id,
    required final String title,
    required final String description,
    required final DateTime date,
    required final String type,
    required final String authorName,
  }) = _$TimelineEventDtoImpl;
  const _TimelineEventDto._() : super._();

  factory _TimelineEventDto.fromJson(Map<String, dynamic> json) =
      _$TimelineEventDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get date;
  @override
  String get type;
  @override
  String get authorName;

  /// Create a copy of TimelineEventDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineEventDtoImplCopyWith<_$TimelineEventDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
