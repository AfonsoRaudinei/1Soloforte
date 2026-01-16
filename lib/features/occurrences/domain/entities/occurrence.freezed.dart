// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Occurrence {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get severity => throw _privateConstructorUsedError;
  String get areaName => throw _privateConstructorUsedError;
  String? get areaId => throw _privateConstructorUsedError;
  String? get clientId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  List<TimelineEvent> get timeline => throw _privateConstructorUsedError;
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

  /// Create a copy of Occurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccurrenceCopyWith<Occurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccurrenceCopyWith<$Res> {
  factory $OccurrenceCopyWith(
    Occurrence value,
    $Res Function(Occurrence) then,
  ) = _$OccurrenceCopyWithImpl<$Res, Occurrence>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String type,
    double severity,
    String areaName,
    String? areaId,
    String? clientId,
    DateTime date,
    String status,
    List<String> images,
    double latitude,
    double longitude,
    List<TimelineEvent> timeline,
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
class _$OccurrenceCopyWithImpl<$Res, $Val extends Occurrence>
    implements $OccurrenceCopyWith<$Res> {
  _$OccurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Occurrence
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
    Object? areaId = freezed,
    Object? clientId = freezed,
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
            areaId: freezed == areaId
                ? _value.areaId
                : areaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientId: freezed == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
                      as List<TimelineEvent>,
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
abstract class _$$OccurrenceImplCopyWith<$Res>
    implements $OccurrenceCopyWith<$Res> {
  factory _$$OccurrenceImplCopyWith(
    _$OccurrenceImpl value,
    $Res Function(_$OccurrenceImpl) then,
  ) = __$$OccurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String type,
    double severity,
    String areaName,
    String? areaId,
    String? clientId,
    DateTime date,
    String status,
    List<String> images,
    double latitude,
    double longitude,
    List<TimelineEvent> timeline,
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
class __$$OccurrenceImplCopyWithImpl<$Res>
    extends _$OccurrenceCopyWithImpl<$Res, _$OccurrenceImpl>
    implements _$$OccurrenceImplCopyWith<$Res> {
  __$$OccurrenceImplCopyWithImpl(
    _$OccurrenceImpl _value,
    $Res Function(_$OccurrenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Occurrence
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
    Object? areaId = freezed,
    Object? clientId = freezed,
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
      _$OccurrenceImpl(
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
        areaId: freezed == areaId
            ? _value.areaId
            : areaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientId: freezed == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
                  as List<TimelineEvent>,
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

class _$OccurrenceImpl implements _Occurrence {
  const _$OccurrenceImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.areaName,
    this.areaId,
    this.clientId,
    required this.date,
    required this.status,
    required final List<String> images,
    required this.latitude,
    required this.longitude,
    final List<TimelineEvent> timeline = const [],
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
       _categoryImages = categoryImages;

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
  final String? areaId;
  @override
  final String? clientId;
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
  final List<TimelineEvent> _timeline;
  @override
  @JsonKey()
  List<TimelineEvent> get timeline {
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
    return 'Occurrence(id: $id, title: $title, description: $description, type: $type, severity: $severity, areaName: $areaName, areaId: $areaId, clientId: $clientId, date: $date, status: $status, images: $images, latitude: $latitude, longitude: $longitude, timeline: $timeline, assignedTo: $assignedTo, recommendations: $recommendations, phenologicalStage: $phenologicalStage, categorySeverities: $categorySeverities, categoryImages: $categoryImages, technicalRecommendation: $technicalRecommendation, technicalResponsible: $technicalResponsible, temporalType: $temporalType, hasSoilSample: $hasSoilSample)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccurrenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
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

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    type,
    severity,
    areaName,
    areaId,
    clientId,
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

  /// Create a copy of Occurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccurrenceImplCopyWith<_$OccurrenceImpl> get copyWith =>
      __$$OccurrenceImplCopyWithImpl<_$OccurrenceImpl>(this, _$identity);
}

abstract class _Occurrence implements Occurrence {
  const factory _Occurrence({
    required final String id,
    required final String title,
    required final String description,
    required final String type,
    required final double severity,
    required final String areaName,
    final String? areaId,
    final String? clientId,
    required final DateTime date,
    required final String status,
    required final List<String> images,
    required final double latitude,
    required final double longitude,
    final List<TimelineEvent> timeline,
    final String? assignedTo,
    final List<String> recommendations,
    final String phenologicalStage,
    final Map<String, double> categorySeverities,
    final Map<String, List<String>> categoryImages,
    final String technicalRecommendation,
    final String technicalResponsible,
    final String temporalType,
    final bool hasSoilSample,
  }) = _$OccurrenceImpl;

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
  String? get areaId;
  @override
  String? get clientId;
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
  List<TimelineEvent> get timeline;
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

  /// Create a copy of Occurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccurrenceImplCopyWith<_$OccurrenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TimelineEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;

  /// Create a copy of TimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineEventCopyWith<TimelineEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineEventCopyWith<$Res> {
  factory $TimelineEventCopyWith(
    TimelineEvent value,
    $Res Function(TimelineEvent) then,
  ) = _$TimelineEventCopyWithImpl<$Res, TimelineEvent>;
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
class _$TimelineEventCopyWithImpl<$Res, $Val extends TimelineEvent>
    implements $TimelineEventCopyWith<$Res> {
  _$TimelineEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineEvent
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
abstract class _$$TimelineEventImplCopyWith<$Res>
    implements $TimelineEventCopyWith<$Res> {
  factory _$$TimelineEventImplCopyWith(
    _$TimelineEventImpl value,
    $Res Function(_$TimelineEventImpl) then,
  ) = __$$TimelineEventImplCopyWithImpl<$Res>;
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
class __$$TimelineEventImplCopyWithImpl<$Res>
    extends _$TimelineEventCopyWithImpl<$Res, _$TimelineEventImpl>
    implements _$$TimelineEventImplCopyWith<$Res> {
  __$$TimelineEventImplCopyWithImpl(
    _$TimelineEventImpl _value,
    $Res Function(_$TimelineEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimelineEvent
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
      _$TimelineEventImpl(
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

class _$TimelineEventImpl implements _TimelineEvent {
  const _$TimelineEventImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.authorName,
  });

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
    return 'TimelineEvent(id: $id, title: $title, description: $description, date: $date, type: $type, authorName: $authorName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, date, type, authorName);

  /// Create a copy of TimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineEventImplCopyWith<_$TimelineEventImpl> get copyWith =>
      __$$TimelineEventImplCopyWithImpl<_$TimelineEventImpl>(this, _$identity);
}

abstract class _TimelineEvent implements TimelineEvent {
  const factory _TimelineEvent({
    required final String id,
    required final String title,
    required final String description,
    required final DateTime date,
    required final String type,
    required final String authorName,
  }) = _$TimelineEventImpl;

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

  /// Create a copy of TimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineEventImplCopyWith<_$TimelineEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
