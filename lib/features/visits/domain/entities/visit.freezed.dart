// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Visit {
  String get id => throw _privateConstructorUsedError;
  Client get client => throw _privateConstructorUsedError;
  DateTime get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get checkOutNotes => throw _privateConstructorUsedError;
  String? get areaName => throw _privateConstructorUsedError;
  String? get areaId => throw _privateConstructorUsedError;
  String? get activityType => throw _privateConstructorUsedError;
  String? get checkInNotes => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  List<String> get occurrenceIds => throw _privateConstructorUsedError;
  Map<String, bool> get checklist => throw _privateConstructorUsedError;
  List<LatLng> get routePoints => throw _privateConstructorUsedError;
  double get distanceTraveled => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  VisitStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitCopyWith<Visit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitCopyWith<$Res> {
  factory $VisitCopyWith(Visit value, $Res Function(Visit) then) =
      _$VisitCopyWithImpl<$Res, Visit>;
  @useResult
  $Res call({
    String id,
    Client client,
    DateTime checkInTime,
    DateTime? checkOutTime,
    double latitude,
    double longitude,
    String? checkOutNotes,
    String? areaName,
    String? areaId,
    String? activityType,
    String? checkInNotes,
    List<String> photos,
    List<String> occurrenceIds,
    Map<String, bool> checklist,
    List<LatLng> routePoints,
    double distanceTraveled,
    String? eventId,
    VisitStatus status,
  });

  $ClientCopyWith<$Res> get client;
}

/// @nodoc
class _$VisitCopyWithImpl<$Res, $Val extends Visit>
    implements $VisitCopyWith<$Res> {
  _$VisitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? checkOutNotes = freezed,
    Object? areaName = freezed,
    Object? areaId = freezed,
    Object? activityType = freezed,
    Object? checkInNotes = freezed,
    Object? photos = null,
    Object? occurrenceIds = null,
    Object? checklist = null,
    Object? routePoints = null,
    Object? distanceTraveled = null,
    Object? eventId = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            client: null == client
                ? _value.client
                : client // ignore: cast_nullable_to_non_nullable
                      as Client,
            checkInTime: null == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            checkOutTime: freezed == checkOutTime
                ? _value.checkOutTime
                : checkOutTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            checkOutNotes: freezed == checkOutNotes
                ? _value.checkOutNotes
                : checkOutNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            areaName: freezed == areaName
                ? _value.areaName
                : areaName // ignore: cast_nullable_to_non_nullable
                      as String?,
            areaId: freezed == areaId
                ? _value.areaId
                : areaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            activityType: freezed == activityType
                ? _value.activityType
                : activityType // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkInNotes: freezed == checkInNotes
                ? _value.checkInNotes
                : checkInNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            occurrenceIds: null == occurrenceIds
                ? _value.occurrenceIds
                : occurrenceIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            checklist: null == checklist
                ? _value.checklist
                : checklist // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
            routePoints: null == routePoints
                ? _value.routePoints
                : routePoints // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            distanceTraveled: null == distanceTraveled
                ? _value.distanceTraveled
                : distanceTraveled // ignore: cast_nullable_to_non_nullable
                      as double,
            eventId: freezed == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VisitStatus,
          )
          as $Val,
    );
  }

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientCopyWith<$Res> get client {
    return $ClientCopyWith<$Res>(_value.client, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VisitImplCopyWith<$Res> implements $VisitCopyWith<$Res> {
  factory _$$VisitImplCopyWith(
    _$VisitImpl value,
    $Res Function(_$VisitImpl) then,
  ) = __$$VisitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Client client,
    DateTime checkInTime,
    DateTime? checkOutTime,
    double latitude,
    double longitude,
    String? checkOutNotes,
    String? areaName,
    String? areaId,
    String? activityType,
    String? checkInNotes,
    List<String> photos,
    List<String> occurrenceIds,
    Map<String, bool> checklist,
    List<LatLng> routePoints,
    double distanceTraveled,
    String? eventId,
    VisitStatus status,
  });

  @override
  $ClientCopyWith<$Res> get client;
}

/// @nodoc
class __$$VisitImplCopyWithImpl<$Res>
    extends _$VisitCopyWithImpl<$Res, _$VisitImpl>
    implements _$$VisitImplCopyWith<$Res> {
  __$$VisitImplCopyWithImpl(
    _$VisitImpl _value,
    $Res Function(_$VisitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? client = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? checkOutNotes = freezed,
    Object? areaName = freezed,
    Object? areaId = freezed,
    Object? activityType = freezed,
    Object? checkInNotes = freezed,
    Object? photos = null,
    Object? occurrenceIds = null,
    Object? checklist = null,
    Object? routePoints = null,
    Object? distanceTraveled = null,
    Object? eventId = freezed,
    Object? status = null,
  }) {
    return _then(
      _$VisitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        client: null == client
            ? _value.client
            : client // ignore: cast_nullable_to_non_nullable
                  as Client,
        checkInTime: null == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        checkOutTime: freezed == checkOutTime
            ? _value.checkOutTime
            : checkOutTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        checkOutNotes: freezed == checkOutNotes
            ? _value.checkOutNotes
            : checkOutNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        areaName: freezed == areaName
            ? _value.areaName
            : areaName // ignore: cast_nullable_to_non_nullable
                  as String?,
        areaId: freezed == areaId
            ? _value.areaId
            : areaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        activityType: freezed == activityType
            ? _value.activityType
            : activityType // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkInNotes: freezed == checkInNotes
            ? _value.checkInNotes
            : checkInNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        occurrenceIds: null == occurrenceIds
            ? _value._occurrenceIds
            : occurrenceIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        checklist: null == checklist
            ? _value._checklist
            : checklist // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
        routePoints: null == routePoints
            ? _value._routePoints
            : routePoints // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        distanceTraveled: null == distanceTraveled
            ? _value.distanceTraveled
            : distanceTraveled // ignore: cast_nullable_to_non_nullable
                  as double,
        eventId: freezed == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VisitStatus,
      ),
    );
  }
}

/// @nodoc

class _$VisitImpl implements _Visit {
  const _$VisitImpl({
    required this.id,
    required this.client,
    required this.checkInTime,
    this.checkOutTime,
    required this.latitude,
    required this.longitude,
    this.checkOutNotes,
    this.areaName,
    this.areaId,
    this.activityType,
    this.checkInNotes,
    final List<String> photos = const [],
    final List<String> occurrenceIds = const [],
    final Map<String, bool> checklist = const {},
    final List<LatLng> routePoints = const [],
    this.distanceTraveled = 0.0,
    this.eventId,
    this.status = VisitStatus.ongoing,
  }) : _photos = photos,
       _occurrenceIds = occurrenceIds,
       _checklist = checklist,
       _routePoints = routePoints;

  @override
  final String id;
  @override
  final Client client;
  @override
  final DateTime checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? checkOutNotes;
  @override
  final String? areaName;
  @override
  final String? areaId;
  @override
  final String? activityType;
  @override
  final String? checkInNotes;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final List<String> _occurrenceIds;
  @override
  @JsonKey()
  List<String> get occurrenceIds {
    if (_occurrenceIds is EqualUnmodifiableListView) return _occurrenceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_occurrenceIds);
  }

  final Map<String, bool> _checklist;
  @override
  @JsonKey()
  Map<String, bool> get checklist {
    if (_checklist is EqualUnmodifiableMapView) return _checklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_checklist);
  }

  final List<LatLng> _routePoints;
  @override
  @JsonKey()
  List<LatLng> get routePoints {
    if (_routePoints is EqualUnmodifiableListView) return _routePoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routePoints);
  }

  @override
  @JsonKey()
  final double distanceTraveled;
  @override
  final String? eventId;
  @override
  @JsonKey()
  final VisitStatus status;

  @override
  String toString() {
    return 'Visit(id: $id, client: $client, checkInTime: $checkInTime, checkOutTime: $checkOutTime, latitude: $latitude, longitude: $longitude, checkOutNotes: $checkOutNotes, areaName: $areaName, areaId: $areaId, activityType: $activityType, checkInNotes: $checkInNotes, photos: $photos, occurrenceIds: $occurrenceIds, checklist: $checklist, routePoints: $routePoints, distanceTraveled: $distanceTraveled, eventId: $eventId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.checkOutNotes, checkOutNotes) ||
                other.checkOutNotes == checkOutNotes) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.checkInNotes, checkInNotes) ||
                other.checkInNotes == checkInNotes) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(
              other._occurrenceIds,
              _occurrenceIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._checklist,
              _checklist,
            ) &&
            const DeepCollectionEquality().equals(
              other._routePoints,
              _routePoints,
            ) &&
            (identical(other.distanceTraveled, distanceTraveled) ||
                other.distanceTraveled == distanceTraveled) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    client,
    checkInTime,
    checkOutTime,
    latitude,
    longitude,
    checkOutNotes,
    areaName,
    areaId,
    activityType,
    checkInNotes,
    const DeepCollectionEquality().hash(_photos),
    const DeepCollectionEquality().hash(_occurrenceIds),
    const DeepCollectionEquality().hash(_checklist),
    const DeepCollectionEquality().hash(_routePoints),
    distanceTraveled,
    eventId,
    status,
  );

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitImplCopyWith<_$VisitImpl> get copyWith =>
      __$$VisitImplCopyWithImpl<_$VisitImpl>(this, _$identity);
}

abstract class _Visit implements Visit {
  const factory _Visit({
    required final String id,
    required final Client client,
    required final DateTime checkInTime,
    final DateTime? checkOutTime,
    required final double latitude,
    required final double longitude,
    final String? checkOutNotes,
    final String? areaName,
    final String? areaId,
    final String? activityType,
    final String? checkInNotes,
    final List<String> photos,
    final List<String> occurrenceIds,
    final Map<String, bool> checklist,
    final List<LatLng> routePoints,
    final double distanceTraveled,
    final String? eventId,
    final VisitStatus status,
  }) = _$VisitImpl;

  @override
  String get id;
  @override
  Client get client;
  @override
  DateTime get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get checkOutNotes;
  @override
  String? get areaName;
  @override
  String? get areaId;
  @override
  String? get activityType;
  @override
  String? get checkInNotes;
  @override
  List<String> get photos;
  @override
  List<String> get occurrenceIds;
  @override
  Map<String, bool> get checklist;
  @override
  List<LatLng> get routePoints;
  @override
  double get distanceTraveled;
  @override
  String? get eventId;
  @override
  VisitStatus get status;

  /// Create a copy of Visit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitImplCopyWith<_$VisitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
