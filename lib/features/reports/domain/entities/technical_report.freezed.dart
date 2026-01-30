// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technical_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TechnicalReport _$TechnicalReportFromJson(Map<String, dynamic> json) {
  return _TechnicalReport.fromJson(json);
}

/// @nodoc
mixin _$TechnicalReport {
  String get id => throw _privateConstructorUsedError;
  String get visitId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientName => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  String get technicalResponsible => throw _privateConstructorUsedError;
  List<ConsolidatedOccurrence> get occurrences =>
      throw _privateConstructorUsedError;
  List<String> get visitPhotos => throw _privateConstructorUsedError;
  String? get visitNotes => throw _privateConstructorUsedError;
  double? get visitLatitude => throw _privateConstructorUsedError;
  double? get visitLongitude => throw _privateConstructorUsedError;

  /// Serializes this TechnicalReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicalReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicalReportCopyWith<TechnicalReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicalReportCopyWith<$Res> {
  factory $TechnicalReportCopyWith(
    TechnicalReport value,
    $Res Function(TechnicalReport) then,
  ) = _$TechnicalReportCopyWithImpl<$Res, TechnicalReport>;
  @useResult
  $Res call({
    String id,
    String visitId,
    String clientId,
    String clientName,
    DateTime generatedAt,
    String technicalResponsible,
    List<ConsolidatedOccurrence> occurrences,
    List<String> visitPhotos,
    String? visitNotes,
    double? visitLatitude,
    double? visitLongitude,
  });
}

/// @nodoc
class _$TechnicalReportCopyWithImpl<$Res, $Val extends TechnicalReport>
    implements $TechnicalReportCopyWith<$Res> {
  _$TechnicalReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicalReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? visitId = null,
    Object? clientId = null,
    Object? clientName = null,
    Object? generatedAt = null,
    Object? technicalResponsible = null,
    Object? occurrences = null,
    Object? visitPhotos = null,
    Object? visitNotes = freezed,
    Object? visitLatitude = freezed,
    Object? visitLongitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            visitId: null == visitId
                ? _value.visitId
                : visitId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientName: null == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            technicalResponsible: null == technicalResponsible
                ? _value.technicalResponsible
                : technicalResponsible // ignore: cast_nullable_to_non_nullable
                      as String,
            occurrences: null == occurrences
                ? _value.occurrences
                : occurrences // ignore: cast_nullable_to_non_nullable
                      as List<ConsolidatedOccurrence>,
            visitPhotos: null == visitPhotos
                ? _value.visitPhotos
                : visitPhotos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            visitNotes: freezed == visitNotes
                ? _value.visitNotes
                : visitNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            visitLatitude: freezed == visitLatitude
                ? _value.visitLatitude
                : visitLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            visitLongitude: freezed == visitLongitude
                ? _value.visitLongitude
                : visitLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicalReportImplCopyWith<$Res>
    implements $TechnicalReportCopyWith<$Res> {
  factory _$$TechnicalReportImplCopyWith(
    _$TechnicalReportImpl value,
    $Res Function(_$TechnicalReportImpl) then,
  ) = __$$TechnicalReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String visitId,
    String clientId,
    String clientName,
    DateTime generatedAt,
    String technicalResponsible,
    List<ConsolidatedOccurrence> occurrences,
    List<String> visitPhotos,
    String? visitNotes,
    double? visitLatitude,
    double? visitLongitude,
  });
}

/// @nodoc
class __$$TechnicalReportImplCopyWithImpl<$Res>
    extends _$TechnicalReportCopyWithImpl<$Res, _$TechnicalReportImpl>
    implements _$$TechnicalReportImplCopyWith<$Res> {
  __$$TechnicalReportImplCopyWithImpl(
    _$TechnicalReportImpl _value,
    $Res Function(_$TechnicalReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicalReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? visitId = null,
    Object? clientId = null,
    Object? clientName = null,
    Object? generatedAt = null,
    Object? technicalResponsible = null,
    Object? occurrences = null,
    Object? visitPhotos = null,
    Object? visitNotes = freezed,
    Object? visitLatitude = freezed,
    Object? visitLongitude = freezed,
  }) {
    return _then(
      _$TechnicalReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        visitId: null == visitId
            ? _value.visitId
            : visitId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientName: null == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        technicalResponsible: null == technicalResponsible
            ? _value.technicalResponsible
            : technicalResponsible // ignore: cast_nullable_to_non_nullable
                  as String,
        occurrences: null == occurrences
            ? _value._occurrences
            : occurrences // ignore: cast_nullable_to_non_nullable
                  as List<ConsolidatedOccurrence>,
        visitPhotos: null == visitPhotos
            ? _value._visitPhotos
            : visitPhotos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        visitNotes: freezed == visitNotes
            ? _value.visitNotes
            : visitNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        visitLatitude: freezed == visitLatitude
            ? _value.visitLatitude
            : visitLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        visitLongitude: freezed == visitLongitude
            ? _value.visitLongitude
            : visitLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicalReportImpl implements _TechnicalReport {
  const _$TechnicalReportImpl({
    required this.id,
    required this.visitId,
    required this.clientId,
    required this.clientName,
    required this.generatedAt,
    required this.technicalResponsible,
    final List<ConsolidatedOccurrence> occurrences = const [],
    final List<String> visitPhotos = const [],
    this.visitNotes,
    this.visitLatitude,
    this.visitLongitude,
  }) : _occurrences = occurrences,
       _visitPhotos = visitPhotos;

  factory _$TechnicalReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicalReportImplFromJson(json);

  @override
  final String id;
  @override
  final String visitId;
  @override
  final String clientId;
  @override
  final String clientName;
  @override
  final DateTime generatedAt;
  @override
  final String technicalResponsible;
  final List<ConsolidatedOccurrence> _occurrences;
  @override
  @JsonKey()
  List<ConsolidatedOccurrence> get occurrences {
    if (_occurrences is EqualUnmodifiableListView) return _occurrences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_occurrences);
  }

  final List<String> _visitPhotos;
  @override
  @JsonKey()
  List<String> get visitPhotos {
    if (_visitPhotos is EqualUnmodifiableListView) return _visitPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_visitPhotos);
  }

  @override
  final String? visitNotes;
  @override
  final double? visitLatitude;
  @override
  final double? visitLongitude;

  @override
  String toString() {
    return 'TechnicalReport(id: $id, visitId: $visitId, clientId: $clientId, clientName: $clientName, generatedAt: $generatedAt, technicalResponsible: $technicalResponsible, occurrences: $occurrences, visitPhotos: $visitPhotos, visitNotes: $visitNotes, visitLatitude: $visitLatitude, visitLongitude: $visitLongitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicalReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.technicalResponsible, technicalResponsible) ||
                other.technicalResponsible == technicalResponsible) &&
            const DeepCollectionEquality().equals(
              other._occurrences,
              _occurrences,
            ) &&
            const DeepCollectionEquality().equals(
              other._visitPhotos,
              _visitPhotos,
            ) &&
            (identical(other.visitNotes, visitNotes) ||
                other.visitNotes == visitNotes) &&
            (identical(other.visitLatitude, visitLatitude) ||
                other.visitLatitude == visitLatitude) &&
            (identical(other.visitLongitude, visitLongitude) ||
                other.visitLongitude == visitLongitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    visitId,
    clientId,
    clientName,
    generatedAt,
    technicalResponsible,
    const DeepCollectionEquality().hash(_occurrences),
    const DeepCollectionEquality().hash(_visitPhotos),
    visitNotes,
    visitLatitude,
    visitLongitude,
  );

  /// Create a copy of TechnicalReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicalReportImplCopyWith<_$TechnicalReportImpl> get copyWith =>
      __$$TechnicalReportImplCopyWithImpl<_$TechnicalReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicalReportImplToJson(this);
  }
}

abstract class _TechnicalReport implements TechnicalReport {
  const factory _TechnicalReport({
    required final String id,
    required final String visitId,
    required final String clientId,
    required final String clientName,
    required final DateTime generatedAt,
    required final String technicalResponsible,
    final List<ConsolidatedOccurrence> occurrences,
    final List<String> visitPhotos,
    final String? visitNotes,
    final double? visitLatitude,
    final double? visitLongitude,
  }) = _$TechnicalReportImpl;

  factory _TechnicalReport.fromJson(Map<String, dynamic> json) =
      _$TechnicalReportImpl.fromJson;

  @override
  String get id;
  @override
  String get visitId;
  @override
  String get clientId;
  @override
  String get clientName;
  @override
  DateTime get generatedAt;
  @override
  String get technicalResponsible;
  @override
  List<ConsolidatedOccurrence> get occurrences;
  @override
  List<String> get visitPhotos;
  @override
  String? get visitNotes;
  @override
  double? get visitLatitude;
  @override
  double? get visitLongitude;

  /// Create a copy of TechnicalReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicalReportImplCopyWith<_$TechnicalReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConsolidatedOccurrence _$ConsolidatedOccurrenceFromJson(
  Map<String, dynamic> json,
) {
  return _ConsolidatedOccurrence.fromJson(json);
}

/// @nodoc
mixin _$ConsolidatedOccurrence {
  String get originalId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  double get severity => throw _privateConstructorUsedError;
  String? get technicalRecommendation => throw _privateConstructorUsedError;
  String get riskLevel => throw _privateConstructorUsedError;

  /// Serializes this ConsolidatedOccurrence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsolidatedOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsolidatedOccurrenceCopyWith<ConsolidatedOccurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsolidatedOccurrenceCopyWith<$Res> {
  factory $ConsolidatedOccurrenceCopyWith(
    ConsolidatedOccurrence value,
    $Res Function(ConsolidatedOccurrence) then,
  ) = _$ConsolidatedOccurrenceCopyWithImpl<$Res, ConsolidatedOccurrence>;
  @useResult
  $Res call({
    String originalId,
    String type,
    String title,
    String description,
    DateTime date,
    double latitude,
    double longitude,
    List<String> photos,
    double severity,
    String? technicalRecommendation,
    String riskLevel,
  });
}

/// @nodoc
class _$ConsolidatedOccurrenceCopyWithImpl<
  $Res,
  $Val extends ConsolidatedOccurrence
>
    implements $ConsolidatedOccurrenceCopyWith<$Res> {
  _$ConsolidatedOccurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsolidatedOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? photos = null,
    Object? severity = null,
    Object? technicalRecommendation = freezed,
    Object? riskLevel = null,
  }) {
    return _then(
      _value.copyWith(
            originalId: null == originalId
                ? _value.originalId
                : originalId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
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
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as double,
            technicalRecommendation: freezed == technicalRecommendation
                ? _value.technicalRecommendation
                : technicalRecommendation // ignore: cast_nullable_to_non_nullable
                      as String?,
            riskLevel: null == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConsolidatedOccurrenceImplCopyWith<$Res>
    implements $ConsolidatedOccurrenceCopyWith<$Res> {
  factory _$$ConsolidatedOccurrenceImplCopyWith(
    _$ConsolidatedOccurrenceImpl value,
    $Res Function(_$ConsolidatedOccurrenceImpl) then,
  ) = __$$ConsolidatedOccurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String originalId,
    String type,
    String title,
    String description,
    DateTime date,
    double latitude,
    double longitude,
    List<String> photos,
    double severity,
    String? technicalRecommendation,
    String riskLevel,
  });
}

/// @nodoc
class __$$ConsolidatedOccurrenceImplCopyWithImpl<$Res>
    extends
        _$ConsolidatedOccurrenceCopyWithImpl<$Res, _$ConsolidatedOccurrenceImpl>
    implements _$$ConsolidatedOccurrenceImplCopyWith<$Res> {
  __$$ConsolidatedOccurrenceImplCopyWithImpl(
    _$ConsolidatedOccurrenceImpl _value,
    $Res Function(_$ConsolidatedOccurrenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConsolidatedOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? photos = null,
    Object? severity = null,
    Object? technicalRecommendation = freezed,
    Object? riskLevel = null,
  }) {
    return _then(
      _$ConsolidatedOccurrenceImpl(
        originalId: null == originalId
            ? _value.originalId
            : originalId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
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
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as double,
        technicalRecommendation: freezed == technicalRecommendation
            ? _value.technicalRecommendation
            : technicalRecommendation // ignore: cast_nullable_to_non_nullable
                  as String?,
        riskLevel: null == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsolidatedOccurrenceImpl implements _ConsolidatedOccurrence {
  const _$ConsolidatedOccurrenceImpl({
    required this.originalId,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
    required final List<String> photos,
    required this.severity,
    this.technicalRecommendation,
    required this.riskLevel,
  }) : _photos = photos;

  factory _$ConsolidatedOccurrenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsolidatedOccurrenceImplFromJson(json);

  @override
  final String originalId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime date;
  @override
  final double latitude;
  @override
  final double longitude;
  final List<String> _photos;
  @override
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final double severity;
  @override
  final String? technicalRecommendation;
  @override
  final String riskLevel;

  @override
  String toString() {
    return 'ConsolidatedOccurrence(originalId: $originalId, type: $type, title: $title, description: $description, date: $date, latitude: $latitude, longitude: $longitude, photos: $photos, severity: $severity, technicalRecommendation: $technicalRecommendation, riskLevel: $riskLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsolidatedOccurrenceImpl &&
            (identical(other.originalId, originalId) ||
                other.originalId == originalId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(
                  other.technicalRecommendation,
                  technicalRecommendation,
                ) ||
                other.technicalRecommendation == technicalRecommendation) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    originalId,
    type,
    title,
    description,
    date,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_photos),
    severity,
    technicalRecommendation,
    riskLevel,
  );

  /// Create a copy of ConsolidatedOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsolidatedOccurrenceImplCopyWith<_$ConsolidatedOccurrenceImpl>
  get copyWith =>
      __$$ConsolidatedOccurrenceImplCopyWithImpl<_$ConsolidatedOccurrenceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsolidatedOccurrenceImplToJson(this);
  }
}

abstract class _ConsolidatedOccurrence implements ConsolidatedOccurrence {
  const factory _ConsolidatedOccurrence({
    required final String originalId,
    required final String type,
    required final String title,
    required final String description,
    required final DateTime date,
    required final double latitude,
    required final double longitude,
    required final List<String> photos,
    required final double severity,
    final String? technicalRecommendation,
    required final String riskLevel,
  }) = _$ConsolidatedOccurrenceImpl;

  factory _ConsolidatedOccurrence.fromJson(Map<String, dynamic> json) =
      _$ConsolidatedOccurrenceImpl.fromJson;

  @override
  String get originalId;
  @override
  String get type;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get date;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  List<String> get photos;
  @override
  double get severity;
  @override
  String? get technicalRecommendation;
  @override
  String get riskLevel;

  /// Create a copy of ConsolidatedOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsolidatedOccurrenceImplCopyWith<_$ConsolidatedOccurrenceImpl>
  get copyWith => throw _privateConstructorUsedError;
}
