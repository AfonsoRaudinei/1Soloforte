// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketing_publication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PublicationPhoto _$PublicationPhotoFromJson(Map<String, dynamic> json) {
  return _PublicationPhoto.fromJson(json);
}

/// @nodoc
mixin _$PublicationPhoto {
  String get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  bool get isCover => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PublicationPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicationPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicationPhotoCopyWith<PublicationPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicationPhotoCopyWith<$Res> {
  factory $PublicationPhotoCopyWith(
    PublicationPhoto value,
    $Res Function(PublicationPhoto) then,
  ) = _$PublicationPhotoCopyWithImpl<$Res, PublicationPhoto>;
  @useResult
  $Res call({
    String id,
    String path,
    String caption,
    bool isCover,
    int order,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$PublicationPhotoCopyWithImpl<$Res, $Val extends PublicationPhoto>
    implements $PublicationPhotoCopyWith<$Res> {
  _$PublicationPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicationPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? caption = null,
    Object? isCover = null,
    Object? order = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            isCover: null == isCover
                ? _value.isCover
                : isCover // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicationPhotoImplCopyWith<$Res>
    implements $PublicationPhotoCopyWith<$Res> {
  factory _$$PublicationPhotoImplCopyWith(
    _$PublicationPhotoImpl value,
    $Res Function(_$PublicationPhotoImpl) then,
  ) = __$$PublicationPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String path,
    String caption,
    bool isCover,
    int order,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$PublicationPhotoImplCopyWithImpl<$Res>
    extends _$PublicationPhotoCopyWithImpl<$Res, _$PublicationPhotoImpl>
    implements _$$PublicationPhotoImplCopyWith<$Res> {
  __$$PublicationPhotoImplCopyWithImpl(
    _$PublicationPhotoImpl _value,
    $Res Function(_$PublicationPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicationPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? caption = null,
    Object? isCover = null,
    Object? order = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PublicationPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        isCover: null == isCover
            ? _value.isCover
            : isCover // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicationPhotoImpl implements _PublicationPhoto {
  const _$PublicationPhotoImpl({
    required this.id,
    required this.path,
    this.caption = '',
    this.isCover = false,
    this.order = 0,
    this.createdAt,
  });

  factory _$PublicationPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicationPhotoImplFromJson(json);

  @override
  final String id;
  @override
  final String path;
  @override
  @JsonKey()
  final String caption;
  @override
  @JsonKey()
  final bool isCover;
  @override
  @JsonKey()
  final int order;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PublicationPhoto(id: $id, path: $path, caption: $caption, isCover: $isCover, order: $order, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicationPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.isCover, isCover) || other.isCover == isCover) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, path, caption, isCover, order, createdAt);

  /// Create a copy of PublicationPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicationPhotoImplCopyWith<_$PublicationPhotoImpl> get copyWith =>
      __$$PublicationPhotoImplCopyWithImpl<_$PublicationPhotoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicationPhotoImplToJson(this);
  }
}

abstract class _PublicationPhoto implements PublicationPhoto {
  const factory _PublicationPhoto({
    required final String id,
    required final String path,
    final String caption,
    final bool isCover,
    final int order,
    final DateTime? createdAt,
  }) = _$PublicationPhotoImpl;

  factory _PublicationPhoto.fromJson(Map<String, dynamic> json) =
      _$PublicationPhotoImpl.fromJson;

  @override
  String get id;
  @override
  String get path;
  @override
  String get caption;
  @override
  bool get isCover;
  @override
  int get order;
  @override
  DateTime? get createdAt;

  /// Create a copy of PublicationPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicationPhotoImplCopyWith<_$PublicationPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComparisonEntry _$ComparisonEntryFromJson(Map<String, dynamic> json) {
  return _ComparisonEntry.fromJson(json);
}

/// @nodoc
mixin _$ComparisonEntry {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<PublicationPhoto> get photos => throw _privateConstructorUsedError;
  double? get productivity => throw _privateConstructorUsedError;
  double? get ndvi => throw _privateConstructorUsedError;
  double? get biomass => throw _privateConstructorUsedError;
  String get productivityUnit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this ComparisonEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonEntryCopyWith<ComparisonEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonEntryCopyWith<$Res> {
  factory $ComparisonEntryCopyWith(
    ComparisonEntry value,
    $Res Function(ComparisonEntry) then,
  ) = _$ComparisonEntryCopyWithImpl<$Res, ComparisonEntry>;
  @useResult
  $Res call({
    String id,
    String label,
    List<PublicationPhoto> photos,
    double? productivity,
    double? ndvi,
    double? biomass,
    String productivityUnit,
    String? notes,
    int order,
  });
}

/// @nodoc
class _$ComparisonEntryCopyWithImpl<$Res, $Val extends ComparisonEntry>
    implements $ComparisonEntryCopyWith<$Res> {
  _$ComparisonEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? photos = null,
    Object? productivity = freezed,
    Object? ndvi = freezed,
    Object? biomass = freezed,
    Object? productivityUnit = null,
    Object? notes = freezed,
    Object? order = null,
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
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<PublicationPhoto>,
            productivity: freezed == productivity
                ? _value.productivity
                : productivity // ignore: cast_nullable_to_non_nullable
                      as double?,
            ndvi: freezed == ndvi
                ? _value.ndvi
                : ndvi // ignore: cast_nullable_to_non_nullable
                      as double?,
            biomass: freezed == biomass
                ? _value.biomass
                : biomass // ignore: cast_nullable_to_non_nullable
                      as double?,
            productivityUnit: null == productivityUnit
                ? _value.productivityUnit
                : productivityUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComparisonEntryImplCopyWith<$Res>
    implements $ComparisonEntryCopyWith<$Res> {
  factory _$$ComparisonEntryImplCopyWith(
    _$ComparisonEntryImpl value,
    $Res Function(_$ComparisonEntryImpl) then,
  ) = __$$ComparisonEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    List<PublicationPhoto> photos,
    double? productivity,
    double? ndvi,
    double? biomass,
    String productivityUnit,
    String? notes,
    int order,
  });
}

/// @nodoc
class __$$ComparisonEntryImplCopyWithImpl<$Res>
    extends _$ComparisonEntryCopyWithImpl<$Res, _$ComparisonEntryImpl>
    implements _$$ComparisonEntryImplCopyWith<$Res> {
  __$$ComparisonEntryImplCopyWithImpl(
    _$ComparisonEntryImpl _value,
    $Res Function(_$ComparisonEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComparisonEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? photos = null,
    Object? productivity = freezed,
    Object? ndvi = freezed,
    Object? biomass = freezed,
    Object? productivityUnit = null,
    Object? notes = freezed,
    Object? order = null,
  }) {
    return _then(
      _$ComparisonEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<PublicationPhoto>,
        productivity: freezed == productivity
            ? _value.productivity
            : productivity // ignore: cast_nullable_to_non_nullable
                  as double?,
        ndvi: freezed == ndvi
            ? _value.ndvi
            : ndvi // ignore: cast_nullable_to_non_nullable
                  as double?,
        biomass: freezed == biomass
            ? _value.biomass
            : biomass // ignore: cast_nullable_to_non_nullable
                  as double?,
        productivityUnit: null == productivityUnit
            ? _value.productivityUnit
            : productivityUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonEntryImpl implements _ComparisonEntry {
  const _$ComparisonEntryImpl({
    required this.id,
    required this.label,
    final List<PublicationPhoto> photos = const [],
    this.productivity,
    this.ndvi,
    this.biomass,
    this.productivityUnit = 'sc/ha',
    this.notes,
    this.order = 0,
  }) : _photos = photos;

  factory _$ComparisonEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  final List<PublicationPhoto> _photos;
  @override
  @JsonKey()
  List<PublicationPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final double? productivity;
  @override
  final double? ndvi;
  @override
  final double? biomass;
  @override
  @JsonKey()
  final String productivityUnit;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'ComparisonEntry(id: $id, label: $label, photos: $photos, productivity: $productivity, ndvi: $ndvi, biomass: $biomass, productivityUnit: $productivityUnit, notes: $notes, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.productivity, productivity) ||
                other.productivity == productivity) &&
            (identical(other.ndvi, ndvi) || other.ndvi == ndvi) &&
            (identical(other.biomass, biomass) || other.biomass == biomass) &&
            (identical(other.productivityUnit, productivityUnit) ||
                other.productivityUnit == productivityUnit) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    const DeepCollectionEquality().hash(_photos),
    productivity,
    ndvi,
    biomass,
    productivityUnit,
    notes,
    order,
  );

  /// Create a copy of ComparisonEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonEntryImplCopyWith<_$ComparisonEntryImpl> get copyWith =>
      __$$ComparisonEntryImplCopyWithImpl<_$ComparisonEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonEntryImplToJson(this);
  }
}

abstract class _ComparisonEntry implements ComparisonEntry {
  const factory _ComparisonEntry({
    required final String id,
    required final String label,
    final List<PublicationPhoto> photos,
    final double? productivity,
    final double? ndvi,
    final double? biomass,
    final String productivityUnit,
    final String? notes,
    final int order,
  }) = _$ComparisonEntryImpl;

  factory _ComparisonEntry.fromJson(Map<String, dynamic> json) =
      _$ComparisonEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  List<PublicationPhoto> get photos;
  @override
  double? get productivity;
  @override
  double? get ndvi;
  @override
  double? get biomass;
  @override
  String get productivityUnit;
  @override
  String? get notes;
  @override
  int get order;

  /// Create a copy of ComparisonEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonEntryImplCopyWith<_$ComparisonEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketingPin _$MarketingPinFromJson(Map<String, dynamic> json) {
  return _MarketingPin.fromJson(json);
}

/// @nodoc
mixin _$MarketingPin {
  String get id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get publicationId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MarketingPin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketingPin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketingPinCopyWith<MarketingPin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketingPinCopyWith<$Res> {
  factory $MarketingPinCopyWith(
    MarketingPin value,
    $Res Function(MarketingPin) then,
  ) = _$MarketingPinCopyWithImpl<$Res, MarketingPin>;
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String publicationId,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$MarketingPinCopyWithImpl<$Res, $Val extends MarketingPin>
    implements $MarketingPinCopyWith<$Res> {
  _$MarketingPinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketingPin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? publicationId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            publicationId: null == publicationId
                ? _value.publicationId
                : publicationId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketingPinImplCopyWith<$Res>
    implements $MarketingPinCopyWith<$Res> {
  factory _$$MarketingPinImplCopyWith(
    _$MarketingPinImpl value,
    $Res Function(_$MarketingPinImpl) then,
  ) = __$$MarketingPinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String publicationId,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$MarketingPinImplCopyWithImpl<$Res>
    extends _$MarketingPinCopyWithImpl<$Res, _$MarketingPinImpl>
    implements _$$MarketingPinImplCopyWith<$Res> {
  __$$MarketingPinImplCopyWithImpl(
    _$MarketingPinImpl _value,
    $Res Function(_$MarketingPinImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketingPin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? publicationId = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$MarketingPinImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        publicationId: null == publicationId
            ? _value.publicationId
            : publicationId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketingPinImpl implements _MarketingPin {
  const _$MarketingPinImpl({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.publicationId,
    this.createdAt,
  });

  factory _$MarketingPinImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketingPinImplFromJson(json);

  @override
  final String id;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String publicationId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MarketingPin(id: $id, latitude: $latitude, longitude: $longitude, publicationId: $publicationId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketingPinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.publicationId, publicationId) ||
                other.publicationId == publicationId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    latitude,
    longitude,
    publicationId,
    createdAt,
  );

  /// Create a copy of MarketingPin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketingPinImplCopyWith<_$MarketingPinImpl> get copyWith =>
      __$$MarketingPinImplCopyWithImpl<_$MarketingPinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketingPinImplToJson(this);
  }
}

abstract class _MarketingPin implements MarketingPin {
  const factory _MarketingPin({
    required final String id,
    required final double latitude,
    required final double longitude,
    required final String publicationId,
    final DateTime? createdAt,
  }) = _$MarketingPinImpl;

  factory _MarketingPin.fromJson(Map<String, dynamic> json) =
      _$MarketingPinImpl.fromJson;

  @override
  String get id;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get publicationId;
  @override
  DateTime? get createdAt;

  /// Create a copy of MarketingPin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketingPinImplCopyWith<_$MarketingPinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketingPublication _$MarketingPublicationFromJson(Map<String, dynamic> json) {
  return _MarketingPublication.fromJson(json);
}

/// @nodoc
mixin _$MarketingPublication {
  String get id => throw _privateConstructorUsedError; // Localização
  double get latitude => throw _privateConstructorUsedError;
  double get longitude =>
      throw _privateConstructorUsedError; // Metadados do Case
  String? get clientId => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get areaId => throw _privateConstructorUsedError;
  String? get areaName => throw _privateConstructorUsedError;
  PublicationType get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get product => throw _privateConstructorUsedError;
  String? get campaign => throw _privateConstructorUsedError;
  String? get harvest =>
      throw _privateConstructorUsedError; // Vendedor/Consultor
  String? get sellerName => throw _privateConstructorUsedError;
  String? get sellerPhone => throw _privateConstructorUsedError;
  String? get companyName =>
      throw _privateConstructorUsedError; // Comparações Dinâmicas (fonte de verdade para "Antes e Depois")
  List<ComparisonEntry> get comparisons => throw _privateConstructorUsedError;
  String get comparisonType =>
      throw _privateConstructorUsedError; // Fotos gerais (não vinculadas a comparações)
  List<PublicationPhoto> get photos =>
      throw _privateConstructorUsedError; // Resultado/Destaque
  String? get highlightMetric => throw _privateConstructorUsedError;
  double? get highlightValue => throw _privateConstructorUsedError;
  String get highlightUnit => throw _privateConstructorUsedError;
  bool get showPercentage =>
      throw _privateConstructorUsedError; // Configurações de card
  String get investmentLevel => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError; // Observações
  String? get notes => throw _privateConstructorUsedError; // Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError; // Status
  String get status => throw _privateConstructorUsedError;

  /// Serializes this MarketingPublication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketingPublication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketingPublicationCopyWith<MarketingPublication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketingPublicationCopyWith<$Res> {
  factory $MarketingPublicationCopyWith(
    MarketingPublication value,
    $Res Function(MarketingPublication) then,
  ) = _$MarketingPublicationCopyWithImpl<$Res, MarketingPublication>;
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,
    PublicationType type,
    String? title,
    String? description,
    String? product,
    String? campaign,
    String? harvest,
    String? sellerName,
    String? sellerPhone,
    String? companyName,
    List<ComparisonEntry> comparisons,
    String comparisonType,
    List<PublicationPhoto> photos,
    String? highlightMetric,
    double? highlightValue,
    String highlightUnit,
    bool showPercentage,
    String investmentLevel,
    bool isVisible,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    String status,
  });
}

/// @nodoc
class _$MarketingPublicationCopyWithImpl<
  $Res,
  $Val extends MarketingPublication
>
    implements $MarketingPublicationCopyWith<$Res> {
  _$MarketingPublicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketingPublication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? clientId = freezed,
    Object? clientName = freezed,
    Object? areaId = freezed,
    Object? areaName = freezed,
    Object? type = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? product = freezed,
    Object? campaign = freezed,
    Object? harvest = freezed,
    Object? sellerName = freezed,
    Object? sellerPhone = freezed,
    Object? companyName = freezed,
    Object? comparisons = null,
    Object? comparisonType = null,
    Object? photos = null,
    Object? highlightMetric = freezed,
    Object? highlightValue = freezed,
    Object? highlightUnit = null,
    Object? showPercentage = null,
    Object? investmentLevel = null,
    Object? isVisible = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PublicationType,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as String?,
            campaign: freezed == campaign
                ? _value.campaign
                : campaign // ignore: cast_nullable_to_non_nullable
                      as String?,
            harvest: freezed == harvest
                ? _value.harvest
                : harvest // ignore: cast_nullable_to_non_nullable
                      as String?,
            sellerName: freezed == sellerName
                ? _value.sellerName
                : sellerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sellerPhone: freezed == sellerPhone
                ? _value.sellerPhone
                : sellerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            comparisons: null == comparisons
                ? _value.comparisons
                : comparisons // ignore: cast_nullable_to_non_nullable
                      as List<ComparisonEntry>,
            comparisonType: null == comparisonType
                ? _value.comparisonType
                : comparisonType // ignore: cast_nullable_to_non_nullable
                      as String,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<PublicationPhoto>,
            highlightMetric: freezed == highlightMetric
                ? _value.highlightMetric
                : highlightMetric // ignore: cast_nullable_to_non_nullable
                      as String?,
            highlightValue: freezed == highlightValue
                ? _value.highlightValue
                : highlightValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            highlightUnit: null == highlightUnit
                ? _value.highlightUnit
                : highlightUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            showPercentage: null == showPercentage
                ? _value.showPercentage
                : showPercentage // ignore: cast_nullable_to_non_nullable
                      as bool,
            investmentLevel: null == investmentLevel
                ? _value.investmentLevel
                : investmentLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketingPublicationImplCopyWith<$Res>
    implements $MarketingPublicationCopyWith<$Res> {
  factory _$$MarketingPublicationImplCopyWith(
    _$MarketingPublicationImpl value,
    $Res Function(_$MarketingPublicationImpl) then,
  ) = __$$MarketingPublicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,
    PublicationType type,
    String? title,
    String? description,
    String? product,
    String? campaign,
    String? harvest,
    String? sellerName,
    String? sellerPhone,
    String? companyName,
    List<ComparisonEntry> comparisons,
    String comparisonType,
    List<PublicationPhoto> photos,
    String? highlightMetric,
    double? highlightValue,
    String highlightUnit,
    bool showPercentage,
    String investmentLevel,
    bool isVisible,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    String status,
  });
}

/// @nodoc
class __$$MarketingPublicationImplCopyWithImpl<$Res>
    extends _$MarketingPublicationCopyWithImpl<$Res, _$MarketingPublicationImpl>
    implements _$$MarketingPublicationImplCopyWith<$Res> {
  __$$MarketingPublicationImplCopyWithImpl(
    _$MarketingPublicationImpl _value,
    $Res Function(_$MarketingPublicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketingPublication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? clientId = freezed,
    Object? clientName = freezed,
    Object? areaId = freezed,
    Object? areaName = freezed,
    Object? type = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? product = freezed,
    Object? campaign = freezed,
    Object? harvest = freezed,
    Object? sellerName = freezed,
    Object? sellerPhone = freezed,
    Object? companyName = freezed,
    Object? comparisons = null,
    Object? comparisonType = null,
    Object? photos = null,
    Object? highlightMetric = freezed,
    Object? highlightValue = freezed,
    Object? highlightUnit = null,
    Object? showPercentage = null,
    Object? investmentLevel = null,
    Object? isVisible = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
    Object? status = null,
  }) {
    return _then(
      _$MarketingPublicationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
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
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PublicationType,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as String?,
        campaign: freezed == campaign
            ? _value.campaign
            : campaign // ignore: cast_nullable_to_non_nullable
                  as String?,
        harvest: freezed == harvest
            ? _value.harvest
            : harvest // ignore: cast_nullable_to_non_nullable
                  as String?,
        sellerName: freezed == sellerName
            ? _value.sellerName
            : sellerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sellerPhone: freezed == sellerPhone
            ? _value.sellerPhone
            : sellerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        comparisons: null == comparisons
            ? _value._comparisons
            : comparisons // ignore: cast_nullable_to_non_nullable
                  as List<ComparisonEntry>,
        comparisonType: null == comparisonType
            ? _value.comparisonType
            : comparisonType // ignore: cast_nullable_to_non_nullable
                  as String,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<PublicationPhoto>,
        highlightMetric: freezed == highlightMetric
            ? _value.highlightMetric
            : highlightMetric // ignore: cast_nullable_to_non_nullable
                  as String?,
        highlightValue: freezed == highlightValue
            ? _value.highlightValue
            : highlightValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        highlightUnit: null == highlightUnit
            ? _value.highlightUnit
            : highlightUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        showPercentage: null == showPercentage
            ? _value.showPercentage
            : showPercentage // ignore: cast_nullable_to_non_nullable
                  as bool,
        investmentLevel: null == investmentLevel
            ? _value.investmentLevel
            : investmentLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketingPublicationImpl extends _MarketingPublication {
  const _$MarketingPublicationImpl({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.clientId,
    this.clientName,
    this.areaId,
    this.areaName,
    this.type = PublicationType.caseSucesso,
    this.title,
    this.description,
    this.product,
    this.campaign,
    this.harvest,
    this.sellerName,
    this.sellerPhone,
    this.companyName,
    final List<ComparisonEntry> comparisons = const [],
    this.comparisonType = 'custom',
    final List<PublicationPhoto> photos = const [],
    this.highlightMetric,
    this.highlightValue,
    this.highlightUnit = 'sc/ha',
    this.showPercentage = true,
    this.investmentLevel = 'prata',
    this.isVisible = true,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.status = 'draft',
  }) : _comparisons = comparisons,
       _photos = photos,
       super._();

  factory _$MarketingPublicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketingPublicationImplFromJson(json);

  @override
  final String id;
  // Localização
  @override
  final double latitude;
  @override
  final double longitude;
  // Metadados do Case
  @override
  final String? clientId;
  @override
  final String? clientName;
  @override
  final String? areaId;
  @override
  final String? areaName;
  @override
  @JsonKey()
  final PublicationType type;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? product;
  @override
  final String? campaign;
  @override
  final String? harvest;
  // Vendedor/Consultor
  @override
  final String? sellerName;
  @override
  final String? sellerPhone;
  @override
  final String? companyName;
  // Comparações Dinâmicas (fonte de verdade para "Antes e Depois")
  final List<ComparisonEntry> _comparisons;
  // Comparações Dinâmicas (fonte de verdade para "Antes e Depois")
  @override
  @JsonKey()
  List<ComparisonEntry> get comparisons {
    if (_comparisons is EqualUnmodifiableListView) return _comparisons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comparisons);
  }

  @override
  @JsonKey()
  final String comparisonType;
  // Fotos gerais (não vinculadas a comparações)
  final List<PublicationPhoto> _photos;
  // Fotos gerais (não vinculadas a comparações)
  @override
  @JsonKey()
  List<PublicationPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  // Resultado/Destaque
  @override
  final String? highlightMetric;
  @override
  final double? highlightValue;
  @override
  @JsonKey()
  final String highlightUnit;
  @override
  @JsonKey()
  final bool showPercentage;
  // Configurações de card
  @override
  @JsonKey()
  final String investmentLevel;
  @override
  @JsonKey()
  final bool isVisible;
  // Observações
  @override
  final String? notes;
  // Timestamps
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? publishedAt;
  // Status
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'MarketingPublication(id: $id, latitude: $latitude, longitude: $longitude, clientId: $clientId, clientName: $clientName, areaId: $areaId, areaName: $areaName, type: $type, title: $title, description: $description, product: $product, campaign: $campaign, harvest: $harvest, sellerName: $sellerName, sellerPhone: $sellerPhone, companyName: $companyName, comparisons: $comparisons, comparisonType: $comparisonType, photos: $photos, highlightMetric: $highlightMetric, highlightValue: $highlightValue, highlightUnit: $highlightUnit, showPercentage: $showPercentage, investmentLevel: $investmentLevel, isVisible: $isVisible, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, publishedAt: $publishedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketingPublicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.campaign, campaign) ||
                other.campaign == campaign) &&
            (identical(other.harvest, harvest) || other.harvest == harvest) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.sellerPhone, sellerPhone) ||
                other.sellerPhone == sellerPhone) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            const DeepCollectionEquality().equals(
              other._comparisons,
              _comparisons,
            ) &&
            (identical(other.comparisonType, comparisonType) ||
                other.comparisonType == comparisonType) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.highlightMetric, highlightMetric) ||
                other.highlightMetric == highlightMetric) &&
            (identical(other.highlightValue, highlightValue) ||
                other.highlightValue == highlightValue) &&
            (identical(other.highlightUnit, highlightUnit) ||
                other.highlightUnit == highlightUnit) &&
            (identical(other.showPercentage, showPercentage) ||
                other.showPercentage == showPercentage) &&
            (identical(other.investmentLevel, investmentLevel) ||
                other.investmentLevel == investmentLevel) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    latitude,
    longitude,
    clientId,
    clientName,
    areaId,
    areaName,
    type,
    title,
    description,
    product,
    campaign,
    harvest,
    sellerName,
    sellerPhone,
    companyName,
    const DeepCollectionEquality().hash(_comparisons),
    comparisonType,
    const DeepCollectionEquality().hash(_photos),
    highlightMetric,
    highlightValue,
    highlightUnit,
    showPercentage,
    investmentLevel,
    isVisible,
    notes,
    createdAt,
    updatedAt,
    publishedAt,
    status,
  ]);

  /// Create a copy of MarketingPublication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketingPublicationImplCopyWith<_$MarketingPublicationImpl>
  get copyWith =>
      __$$MarketingPublicationImplCopyWithImpl<_$MarketingPublicationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketingPublicationImplToJson(this);
  }
}

abstract class _MarketingPublication extends MarketingPublication {
  const factory _MarketingPublication({
    required final String id,
    required final double latitude,
    required final double longitude,
    final String? clientId,
    final String? clientName,
    final String? areaId,
    final String? areaName,
    final PublicationType type,
    final String? title,
    final String? description,
    final String? product,
    final String? campaign,
    final String? harvest,
    final String? sellerName,
    final String? sellerPhone,
    final String? companyName,
    final List<ComparisonEntry> comparisons,
    final String comparisonType,
    final List<PublicationPhoto> photos,
    final String? highlightMetric,
    final double? highlightValue,
    final String highlightUnit,
    final bool showPercentage,
    final String investmentLevel,
    final bool isVisible,
    final String? notes,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? publishedAt,
    final String status,
  }) = _$MarketingPublicationImpl;
  const _MarketingPublication._() : super._();

  factory _MarketingPublication.fromJson(Map<String, dynamic> json) =
      _$MarketingPublicationImpl.fromJson;

  @override
  String get id; // Localização
  @override
  double get latitude;
  @override
  double get longitude; // Metadados do Case
  @override
  String? get clientId;
  @override
  String? get clientName;
  @override
  String? get areaId;
  @override
  String? get areaName;
  @override
  PublicationType get type;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get product;
  @override
  String? get campaign;
  @override
  String? get harvest; // Vendedor/Consultor
  @override
  String? get sellerName;
  @override
  String? get sellerPhone;
  @override
  String? get companyName; // Comparações Dinâmicas (fonte de verdade para "Antes e Depois")
  @override
  List<ComparisonEntry> get comparisons;
  @override
  String get comparisonType; // Fotos gerais (não vinculadas a comparações)
  @override
  List<PublicationPhoto> get photos; // Resultado/Destaque
  @override
  String? get highlightMetric;
  @override
  double? get highlightValue;
  @override
  String get highlightUnit;
  @override
  bool get showPercentage; // Configurações de card
  @override
  String get investmentLevel;
  @override
  bool get isVisible; // Observações
  @override
  String? get notes; // Timestamps
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get publishedAt; // Status
  @override
  String get status;

  /// Create a copy of MarketingPublication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketingPublicationImplCopyWith<_$MarketingPublicationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
