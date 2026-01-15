// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventRecurrence _$EventRecurrenceFromJson(Map<String, dynamic> json) {
  return _EventRecurrence.fromJson(json);
}

/// @nodoc
mixin _$EventRecurrence {
  String get frequency =>
      throw _privateConstructorUsedError; // 'daily', 'weekly', 'monthly'
  int get interval => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<DateTime> get exceptionDates => throw _privateConstructorUsedError;

  /// Serializes this EventRecurrence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventRecurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventRecurrenceCopyWith<EventRecurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventRecurrenceCopyWith<$Res> {
  factory $EventRecurrenceCopyWith(
    EventRecurrence value,
    $Res Function(EventRecurrence) then,
  ) = _$EventRecurrenceCopyWithImpl<$Res, EventRecurrence>;
  @useResult
  $Res call({
    String frequency,
    int interval,
    DateTime? endDate,
    List<DateTime> exceptionDates,
  });
}

/// @nodoc
class _$EventRecurrenceCopyWithImpl<$Res, $Val extends EventRecurrence>
    implements $EventRecurrenceCopyWith<$Res> {
  _$EventRecurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventRecurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? exceptionDates = null,
  }) {
    return _then(
      _value.copyWith(
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            exceptionDates: null == exceptionDates
                ? _value.exceptionDates
                : exceptionDates // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventRecurrenceImplCopyWith<$Res>
    implements $EventRecurrenceCopyWith<$Res> {
  factory _$$EventRecurrenceImplCopyWith(
    _$EventRecurrenceImpl value,
    $Res Function(_$EventRecurrenceImpl) then,
  ) = __$$EventRecurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String frequency,
    int interval,
    DateTime? endDate,
    List<DateTime> exceptionDates,
  });
}

/// @nodoc
class __$$EventRecurrenceImplCopyWithImpl<$Res>
    extends _$EventRecurrenceCopyWithImpl<$Res, _$EventRecurrenceImpl>
    implements _$$EventRecurrenceImplCopyWith<$Res> {
  __$$EventRecurrenceImplCopyWithImpl(
    _$EventRecurrenceImpl _value,
    $Res Function(_$EventRecurrenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventRecurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? exceptionDates = null,
  }) {
    return _then(
      _$EventRecurrenceImpl(
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        exceptionDates: null == exceptionDates
            ? _value._exceptionDates
            : exceptionDates // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventRecurrenceImpl implements _EventRecurrence {
  const _$EventRecurrenceImpl({
    required this.frequency,
    required this.interval,
    this.endDate,
    final List<DateTime> exceptionDates = const [],
  }) : _exceptionDates = exceptionDates;

  factory _$EventRecurrenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRecurrenceImplFromJson(json);

  @override
  final String frequency;
  // 'daily', 'weekly', 'monthly'
  @override
  final int interval;
  @override
  final DateTime? endDate;
  final List<DateTime> _exceptionDates;
  @override
  @JsonKey()
  List<DateTime> get exceptionDates {
    if (_exceptionDates is EqualUnmodifiableListView) return _exceptionDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exceptionDates);
  }

  @override
  String toString() {
    return 'EventRecurrence(frequency: $frequency, interval: $interval, endDate: $endDate, exceptionDates: $exceptionDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRecurrenceImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(
              other._exceptionDates,
              _exceptionDates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    frequency,
    interval,
    endDate,
    const DeepCollectionEquality().hash(_exceptionDates),
  );

  /// Create a copy of EventRecurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRecurrenceImplCopyWith<_$EventRecurrenceImpl> get copyWith =>
      __$$EventRecurrenceImplCopyWithImpl<_$EventRecurrenceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRecurrenceImplToJson(this);
  }
}

abstract class _EventRecurrence implements EventRecurrence {
  const factory _EventRecurrence({
    required final String frequency,
    required final int interval,
    final DateTime? endDate,
    final List<DateTime> exceptionDates,
  }) = _$EventRecurrenceImpl;

  factory _EventRecurrence.fromJson(Map<String, dynamic> json) =
      _$EventRecurrenceImpl.fromJson;

  @override
  String get frequency; // 'daily', 'weekly', 'monthly'
  @override
  int get interval;
  @override
  DateTime? get endDate;
  @override
  List<DateTime> get exceptionDates;

  /// Create a copy of EventRecurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventRecurrenceImplCopyWith<_$EventRecurrenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) {
  return _ChecklistItem.fromJson(json);
}

/// @nodoc
mixin _$ChecklistItem {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistItemCopyWith<ChecklistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistItemCopyWith<$Res> {
  factory $ChecklistItemCopyWith(
    ChecklistItem value,
    $Res Function(ChecklistItem) then,
  ) = _$ChecklistItemCopyWithImpl<$Res, ChecklistItem>;
  @useResult
  $Res call({String id, String label, bool isCompleted});
}

/// @nodoc
class _$ChecklistItemCopyWithImpl<$Res, $Val extends ChecklistItem>
    implements $ChecklistItemCopyWith<$Res> {
  _$ChecklistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChecklistItemImplCopyWith<$Res>
    implements $ChecklistItemCopyWith<$Res> {
  factory _$$ChecklistItemImplCopyWith(
    _$ChecklistItemImpl value,
    $Res Function(_$ChecklistItemImpl) then,
  ) = __$$ChecklistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, bool isCompleted});
}

/// @nodoc
class __$$ChecklistItemImplCopyWithImpl<$Res>
    extends _$ChecklistItemCopyWithImpl<$Res, _$ChecklistItemImpl>
    implements _$$ChecklistItemImplCopyWith<$Res> {
  __$$ChecklistItemImplCopyWithImpl(
    _$ChecklistItemImpl _value,
    $Res Function(_$ChecklistItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _$ChecklistItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistItemImpl implements _ChecklistItem {
  const _$ChecklistItemImpl({
    required this.id,
    required this.label,
    this.isCompleted = false,
  });

  factory _$ChecklistItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistItemImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'ChecklistItem(id: $id, label: $label, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, isCompleted);

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistItemImplCopyWith<_$ChecklistItemImpl> get copyWith =>
      __$$ChecklistItemImplCopyWithImpl<_$ChecklistItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistItemImplToJson(this);
  }
}

abstract class _ChecklistItem implements ChecklistItem {
  const factory _ChecklistItem({
    required final String id,
    required final String label,
    final bool isCompleted,
  }) = _$ChecklistItemImpl;

  factory _ChecklistItem.fromJson(Map<String, dynamic> json) =
      _$ChecklistItemImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  bool get isCompleted;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistItemImplCopyWith<_$ChecklistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  EventType get type => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError; // Relations
  String? get clientId => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get areaId => throw _privateConstructorUsedError;
  String? get areaName => throw _privateConstructorUsedError; // Details
  List<String> get participants => throw _privateConstructorUsedError;
  List<ChecklistItem> get checklist => throw _privateConstructorUsedError;
  List<String> get attachmentUrls => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Recurrence
  EventRecurrence? get recurrence =>
      throw _privateConstructorUsedError; // Integrations & Metadata
  Map<String, dynamic>? get weatherForecast =>
      throw _privateConstructorUsedError;
  Map<String, double>? get locationCoordinates =>
      throw _privateConstructorUsedError; // Added for Map integration
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    EventType type,
    EventStatus status,
    String location,
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,
    List<String> participants,
    List<ChecklistItem> checklist,
    List<String> attachmentUrls,
    String? notes,
    EventRecurrence? recurrence,
    Map<String, dynamic>? weatherForecast,
    Map<String, double>? locationCoordinates,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $EventRecurrenceCopyWith<$Res>? get recurrence;
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? status = null,
    Object? location = null,
    Object? clientId = freezed,
    Object? clientName = freezed,
    Object? areaId = freezed,
    Object? areaName = freezed,
    Object? participants = null,
    Object? checklist = null,
    Object? attachmentUrls = null,
    Object? notes = freezed,
    Object? recurrence = freezed,
    Object? weatherForecast = freezed,
    Object? locationCoordinates = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as EventType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EventStatus,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: freezed == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientName: freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            areaId: freezed == areaId
                ? _value.areaId
                : areaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            areaName: freezed == areaName
                ? _value.areaName
                : areaName // ignore: cast_nullable_to_non_nullable
                      as String?,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            checklist: null == checklist
                ? _value.checklist
                : checklist // ignore: cast_nullable_to_non_nullable
                      as List<ChecklistItem>,
            attachmentUrls: null == attachmentUrls
                ? _value.attachmentUrls
                : attachmentUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            recurrence: freezed == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                      as EventRecurrence?,
            weatherForecast: freezed == weatherForecast
                ? _value.weatherForecast
                : weatherForecast // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            locationCoordinates: freezed == locationCoordinates
                ? _value.locationCoordinates
                : locationCoordinates // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventRecurrenceCopyWith<$Res>? get recurrence {
    if (_value.recurrence == null) {
      return null;
    }

    return $EventRecurrenceCopyWith<$Res>(_value.recurrence!, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
    _$EventImpl value,
    $Res Function(_$EventImpl) then,
  ) = __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    EventType type,
    EventStatus status,
    String location,
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,
    List<String> participants,
    List<ChecklistItem> checklist,
    List<String> attachmentUrls,
    String? notes,
    EventRecurrence? recurrence,
    Map<String, dynamic>? weatherForecast,
    Map<String, double>? locationCoordinates,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $EventRecurrenceCopyWith<$Res>? get recurrence;
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
    _$EventImpl _value,
    $Res Function(_$EventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? status = null,
    Object? location = null,
    Object? clientId = freezed,
    Object? clientName = freezed,
    Object? areaId = freezed,
    Object? areaName = freezed,
    Object? participants = null,
    Object? checklist = null,
    Object? attachmentUrls = null,
    Object? notes = freezed,
    Object? recurrence = freezed,
    Object? weatherForecast = freezed,
    Object? locationCoordinates = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$EventImpl(
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
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as EventType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EventStatus,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: freezed == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientName: freezed == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        areaId: freezed == areaId
            ? _value.areaId
            : areaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        areaName: freezed == areaName
            ? _value.areaName
            : areaName // ignore: cast_nullable_to_non_nullable
                  as String?,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        checklist: null == checklist
            ? _value._checklist
            : checklist // ignore: cast_nullable_to_non_nullable
                  as List<ChecklistItem>,
        attachmentUrls: null == attachmentUrls
            ? _value._attachmentUrls
            : attachmentUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        recurrence: freezed == recurrence
            ? _value.recurrence
            : recurrence // ignore: cast_nullable_to_non_nullable
                  as EventRecurrence?,
        weatherForecast: freezed == weatherForecast
            ? _value._weatherForecast
            : weatherForecast // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        locationCoordinates: freezed == locationCoordinates
            ? _value._locationCoordinates
            : locationCoordinates // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.status = EventStatus.scheduled,
    required this.location,
    this.clientId,
    this.clientName,
    this.areaId,
    this.areaName,
    final List<String> participants = const [],
    final List<ChecklistItem> checklist = const [],
    final List<String> attachmentUrls = const [],
    this.notes,
    this.recurrence,
    final Map<String, dynamic>? weatherForecast,
    final Map<String, double>? locationCoordinates,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  }) : _participants = participants,
       _checklist = checklist,
       _attachmentUrls = attachmentUrls,
       _weatherForecast = weatherForecast,
       _locationCoordinates = locationCoordinates;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final EventType type;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  final String location;
  // Relations
  @override
  final String? clientId;
  @override
  final String? clientName;
  @override
  final String? areaId;
  @override
  final String? areaName;
  // Details
  final List<String> _participants;
  // Details
  @override
  @JsonKey()
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<ChecklistItem> _checklist;
  @override
  @JsonKey()
  List<ChecklistItem> get checklist {
    if (_checklist is EqualUnmodifiableListView) return _checklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checklist);
  }

  final List<String> _attachmentUrls;
  @override
  @JsonKey()
  List<String> get attachmentUrls {
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachmentUrls);
  }

  @override
  final String? notes;
  // Recurrence
  @override
  final EventRecurrence? recurrence;
  // Integrations & Metadata
  final Map<String, dynamic>? _weatherForecast;
  // Integrations & Metadata
  @override
  Map<String, dynamic>? get weatherForecast {
    final value = _weatherForecast;
    if (value == null) return null;
    if (_weatherForecast is EqualUnmodifiableMapView) return _weatherForecast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, double>? _locationCoordinates;
  @override
  Map<String, double>? get locationCoordinates {
    final value = _locationCoordinates;
    if (value == null) return null;
    if (_locationCoordinates is EqualUnmodifiableMapView)
      return _locationCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Added for Map integration
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, type: $type, status: $status, location: $location, clientId: $clientId, clientName: $clientName, areaId: $areaId, areaName: $areaName, participants: $participants, checklist: $checklist, attachmentUrls: $attachmentUrls, notes: $notes, recurrence: $recurrence, weatherForecast: $weatherForecast, locationCoordinates: $locationCoordinates, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            const DeepCollectionEquality().equals(
              other._checklist,
              _checklist,
            ) &&
            const DeepCollectionEquality().equals(
              other._attachmentUrls,
              _attachmentUrls,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            const DeepCollectionEquality().equals(
              other._weatherForecast,
              _weatherForecast,
            ) &&
            const DeepCollectionEquality().equals(
              other._locationCoordinates,
              _locationCoordinates,
            ) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    startTime,
    endTime,
    type,
    status,
    location,
    clientId,
    clientName,
    areaId,
    areaName,
    const DeepCollectionEquality().hash(_participants),
    const DeepCollectionEquality().hash(_checklist),
    const DeepCollectionEquality().hash(_attachmentUrls),
    notes,
    recurrence,
    const DeepCollectionEquality().hash(_weatherForecast),
    const DeepCollectionEquality().hash(_locationCoordinates),
    completedAt,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(this);
  }
}

abstract class _Event implements Event {
  const factory _Event({
    required final String id,
    required final String title,
    required final String description,
    required final DateTime startTime,
    required final DateTime endTime,
    required final EventType type,
    final EventStatus status,
    required final String location,
    final String? clientId,
    final String? clientName,
    final String? areaId,
    final String? areaName,
    final List<String> participants,
    final List<ChecklistItem> checklist,
    final List<String> attachmentUrls,
    final String? notes,
    final EventRecurrence? recurrence,
    final Map<String, dynamic>? weatherForecast,
    final Map<String, double>? locationCoordinates,
    final DateTime? completedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  EventType get type;
  @override
  EventStatus get status;
  @override
  String get location; // Relations
  @override
  String? get clientId;
  @override
  String? get clientName;
  @override
  String? get areaId;
  @override
  String? get areaName; // Details
  @override
  List<String> get participants;
  @override
  List<ChecklistItem> get checklist;
  @override
  List<String> get attachmentUrls;
  @override
  String? get notes; // Recurrence
  @override
  EventRecurrence? get recurrence; // Integrations & Metadata
  @override
  Map<String, dynamic>? get weatherForecast;
  @override
  Map<String, double>? get locationCoordinates; // Added for Map integration
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
