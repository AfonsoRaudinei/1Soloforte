// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  bool get pushNotificationsEnabled => throw _privateConstructorUsedError;
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  bool get automaticAlertsEnabled => throw _privateConstructorUsedError;
  bool get offlineModeEnabled => throw _privateConstructorUsedError;
  bool get autoSyncEnabled => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  String get visualStyle => throw _privateConstructorUsedError;
  String? get farmLogoPath => throw _privateConstructorUsedError;
  String? get farmName => throw _privateConstructorUsedError;
  String? get farmCnpj => throw _privateConstructorUsedError;
  String? get farmAddress => throw _privateConstructorUsedError;
  String? get farmCity => throw _privateConstructorUsedError;
  String? get farmState => throw _privateConstructorUsedError;
  String? get farmPhone => throw _privateConstructorUsedError;
  String? get farmEmail => throw _privateConstructorUsedError;
  List<HarvestSetting> get harvests => throw _privateConstructorUsedError;
  Map<String, bool> get integrations => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    bool pushNotificationsEnabled,
    bool emailNotificationsEnabled,
    bool automaticAlertsEnabled,
    bool offlineModeEnabled,
    bool autoSyncEnabled,
    ThemeMode themeMode,
    String visualStyle,
    String? farmLogoPath,
    String? farmName,
    String? farmCnpj,
    String? farmAddress,
    String? farmCity,
    String? farmState,
    String? farmPhone,
    String? farmEmail,
    List<HarvestSetting> harvests,
    Map<String, bool> integrations,
    String? language,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? automaticAlertsEnabled = null,
    Object? offlineModeEnabled = null,
    Object? autoSyncEnabled = null,
    Object? themeMode = null,
    Object? visualStyle = null,
    Object? farmLogoPath = freezed,
    Object? farmName = freezed,
    Object? farmCnpj = freezed,
    Object? farmAddress = freezed,
    Object? farmCity = freezed,
    Object? farmState = freezed,
    Object? farmPhone = freezed,
    Object? farmEmail = freezed,
    Object? harvests = null,
    Object? integrations = null,
    Object? language = freezed,
  }) {
    return _then(
      _value.copyWith(
            pushNotificationsEnabled: null == pushNotificationsEnabled
                ? _value.pushNotificationsEnabled
                : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            emailNotificationsEnabled: null == emailNotificationsEnabled
                ? _value.emailNotificationsEnabled
                : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            automaticAlertsEnabled: null == automaticAlertsEnabled
                ? _value.automaticAlertsEnabled
                : automaticAlertsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            offlineModeEnabled: null == offlineModeEnabled
                ? _value.offlineModeEnabled
                : offlineModeEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoSyncEnabled: null == autoSyncEnabled
                ? _value.autoSyncEnabled
                : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            visualStyle: null == visualStyle
                ? _value.visualStyle
                : visualStyle // ignore: cast_nullable_to_non_nullable
                      as String,
            farmLogoPath: freezed == farmLogoPath
                ? _value.farmLogoPath
                : farmLogoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmName: freezed == farmName
                ? _value.farmName
                : farmName // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmCnpj: freezed == farmCnpj
                ? _value.farmCnpj
                : farmCnpj // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmAddress: freezed == farmAddress
                ? _value.farmAddress
                : farmAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmCity: freezed == farmCity
                ? _value.farmCity
                : farmCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmState: freezed == farmState
                ? _value.farmState
                : farmState // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmPhone: freezed == farmPhone
                ? _value.farmPhone
                : farmPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmEmail: freezed == farmEmail
                ? _value.farmEmail
                : farmEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            harvests: null == harvests
                ? _value.harvests
                : harvests // ignore: cast_nullable_to_non_nullable
                      as List<HarvestSetting>,
            integrations: null == integrations
                ? _value.integrations
                : integrations // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool pushNotificationsEnabled,
    bool emailNotificationsEnabled,
    bool automaticAlertsEnabled,
    bool offlineModeEnabled,
    bool autoSyncEnabled,
    ThemeMode themeMode,
    String visualStyle,
    String? farmLogoPath,
    String? farmName,
    String? farmCnpj,
    String? farmAddress,
    String? farmCity,
    String? farmState,
    String? farmPhone,
    String? farmEmail,
    List<HarvestSetting> harvests,
    Map<String, bool> integrations,
    String? language,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? automaticAlertsEnabled = null,
    Object? offlineModeEnabled = null,
    Object? autoSyncEnabled = null,
    Object? themeMode = null,
    Object? visualStyle = null,
    Object? farmLogoPath = freezed,
    Object? farmName = freezed,
    Object? farmCnpj = freezed,
    Object? farmAddress = freezed,
    Object? farmCity = freezed,
    Object? farmState = freezed,
    Object? farmPhone = freezed,
    Object? farmEmail = freezed,
    Object? harvests = null,
    Object? integrations = null,
    Object? language = freezed,
  }) {
    return _then(
      _$AppSettingsImpl(
        pushNotificationsEnabled: null == pushNotificationsEnabled
            ? _value.pushNotificationsEnabled
            : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailNotificationsEnabled: null == emailNotificationsEnabled
            ? _value.emailNotificationsEnabled
            : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        automaticAlertsEnabled: null == automaticAlertsEnabled
            ? _value.automaticAlertsEnabled
            : automaticAlertsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        offlineModeEnabled: null == offlineModeEnabled
            ? _value.offlineModeEnabled
            : offlineModeEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoSyncEnabled: null == autoSyncEnabled
            ? _value.autoSyncEnabled
            : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        visualStyle: null == visualStyle
            ? _value.visualStyle
            : visualStyle // ignore: cast_nullable_to_non_nullable
                  as String,
        farmLogoPath: freezed == farmLogoPath
            ? _value.farmLogoPath
            : farmLogoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmName: freezed == farmName
            ? _value.farmName
            : farmName // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmCnpj: freezed == farmCnpj
            ? _value.farmCnpj
            : farmCnpj // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmAddress: freezed == farmAddress
            ? _value.farmAddress
            : farmAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmCity: freezed == farmCity
            ? _value.farmCity
            : farmCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmState: freezed == farmState
            ? _value.farmState
            : farmState // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmPhone: freezed == farmPhone
            ? _value.farmPhone
            : farmPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmEmail: freezed == farmEmail
            ? _value.farmEmail
            : farmEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        harvests: null == harvests
            ? _value._harvests
            : harvests // ignore: cast_nullable_to_non_nullable
                  as List<HarvestSetting>,
        integrations: null == integrations
            ? _value._integrations
            : integrations // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.automaticAlertsEnabled = true,
    this.offlineModeEnabled = false,
    this.autoSyncEnabled = true,
    this.themeMode = ThemeMode.system,
    this.visualStyle = 'ios',
    this.farmLogoPath,
    this.farmName,
    this.farmCnpj,
    this.farmAddress,
    this.farmCity,
    this.farmState,
    this.farmPhone,
    this.farmEmail,
    final List<HarvestSetting> harvests = const [],
    final Map<String, bool> integrations = const {},
    this.language,
  }) : _harvests = harvests,
       _integrations = integrations;

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool pushNotificationsEnabled;
  @override
  @JsonKey()
  final bool emailNotificationsEnabled;
  @override
  @JsonKey()
  final bool automaticAlertsEnabled;
  @override
  @JsonKey()
  final bool offlineModeEnabled;
  @override
  @JsonKey()
  final bool autoSyncEnabled;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final String visualStyle;
  @override
  final String? farmLogoPath;
  @override
  final String? farmName;
  @override
  final String? farmCnpj;
  @override
  final String? farmAddress;
  @override
  final String? farmCity;
  @override
  final String? farmState;
  @override
  final String? farmPhone;
  @override
  final String? farmEmail;
  final List<HarvestSetting> _harvests;
  @override
  @JsonKey()
  List<HarvestSetting> get harvests {
    if (_harvests is EqualUnmodifiableListView) return _harvests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_harvests);
  }

  final Map<String, bool> _integrations;
  @override
  @JsonKey()
  Map<String, bool> get integrations {
    if (_integrations is EqualUnmodifiableMapView) return _integrations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_integrations);
  }

  @override
  final String? language;

  @override
  String toString() {
    return 'AppSettings(pushNotificationsEnabled: $pushNotificationsEnabled, emailNotificationsEnabled: $emailNotificationsEnabled, automaticAlertsEnabled: $automaticAlertsEnabled, offlineModeEnabled: $offlineModeEnabled, autoSyncEnabled: $autoSyncEnabled, themeMode: $themeMode, visualStyle: $visualStyle, farmLogoPath: $farmLogoPath, farmName: $farmName, farmCnpj: $farmCnpj, farmAddress: $farmAddress, farmCity: $farmCity, farmState: $farmState, farmPhone: $farmPhone, farmEmail: $farmEmail, harvests: $harvests, integrations: $integrations, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(
                  other.pushNotificationsEnabled,
                  pushNotificationsEnabled,
                ) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            (identical(
                  other.emailNotificationsEnabled,
                  emailNotificationsEnabled,
                ) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(other.automaticAlertsEnabled, automaticAlertsEnabled) ||
                other.automaticAlertsEnabled == automaticAlertsEnabled) &&
            (identical(other.offlineModeEnabled, offlineModeEnabled) ||
                other.offlineModeEnabled == offlineModeEnabled) &&
            (identical(other.autoSyncEnabled, autoSyncEnabled) ||
                other.autoSyncEnabled == autoSyncEnabled) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.visualStyle, visualStyle) ||
                other.visualStyle == visualStyle) &&
            (identical(other.farmLogoPath, farmLogoPath) ||
                other.farmLogoPath == farmLogoPath) &&
            (identical(other.farmName, farmName) ||
                other.farmName == farmName) &&
            (identical(other.farmCnpj, farmCnpj) ||
                other.farmCnpj == farmCnpj) &&
            (identical(other.farmAddress, farmAddress) ||
                other.farmAddress == farmAddress) &&
            (identical(other.farmCity, farmCity) ||
                other.farmCity == farmCity) &&
            (identical(other.farmState, farmState) ||
                other.farmState == farmState) &&
            (identical(other.farmPhone, farmPhone) ||
                other.farmPhone == farmPhone) &&
            (identical(other.farmEmail, farmEmail) ||
                other.farmEmail == farmEmail) &&
            const DeepCollectionEquality().equals(other._harvests, _harvests) &&
            const DeepCollectionEquality().equals(
              other._integrations,
              _integrations,
            ) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    automaticAlertsEnabled,
    offlineModeEnabled,
    autoSyncEnabled,
    themeMode,
    visualStyle,
    farmLogoPath,
    farmName,
    farmCnpj,
    farmAddress,
    farmCity,
    farmState,
    farmPhone,
    farmEmail,
    const DeepCollectionEquality().hash(_harvests),
    const DeepCollectionEquality().hash(_integrations),
    language,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final bool pushNotificationsEnabled,
    final bool emailNotificationsEnabled,
    final bool automaticAlertsEnabled,
    final bool offlineModeEnabled,
    final bool autoSyncEnabled,
    final ThemeMode themeMode,
    final String visualStyle,
    final String? farmLogoPath,
    final String? farmName,
    final String? farmCnpj,
    final String? farmAddress,
    final String? farmCity,
    final String? farmState,
    final String? farmPhone,
    final String? farmEmail,
    final List<HarvestSetting> harvests,
    final Map<String, bool> integrations,
    final String? language,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  bool get pushNotificationsEnabled;
  @override
  bool get emailNotificationsEnabled;
  @override
  bool get automaticAlertsEnabled;
  @override
  bool get offlineModeEnabled;
  @override
  bool get autoSyncEnabled;
  @override
  ThemeMode get themeMode;
  @override
  String get visualStyle;
  @override
  String? get farmLogoPath;
  @override
  String? get farmName;
  @override
  String? get farmCnpj;
  @override
  String? get farmAddress;
  @override
  String? get farmCity;
  @override
  String? get farmState;
  @override
  String? get farmPhone;
  @override
  String? get farmEmail;
  @override
  List<HarvestSetting> get harvests;
  @override
  Map<String, bool> get integrations;
  @override
  String? get language;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HarvestSetting _$HarvestSettingFromJson(Map<String, dynamic> json) {
  return _HarvestSetting.fromJson(json);
}

/// @nodoc
mixin _$HarvestSetting {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this HarvestSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HarvestSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HarvestSettingCopyWith<HarvestSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HarvestSettingCopyWith<$Res> {
  factory $HarvestSettingCopyWith(
    HarvestSetting value,
    $Res Function(HarvestSetting) then,
  ) = _$HarvestSettingCopyWithImpl<$Res, HarvestSetting>;
  @useResult
  $Res call({String id, String name, bool isActive});
}

/// @nodoc
class _$HarvestSettingCopyWithImpl<$Res, $Val extends HarvestSetting>
    implements $HarvestSettingCopyWith<$Res> {
  _$HarvestSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HarvestSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? isActive = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HarvestSettingImplCopyWith<$Res>
    implements $HarvestSettingCopyWith<$Res> {
  factory _$$HarvestSettingImplCopyWith(
    _$HarvestSettingImpl value,
    $Res Function(_$HarvestSettingImpl) then,
  ) = __$$HarvestSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, bool isActive});
}

/// @nodoc
class __$$HarvestSettingImplCopyWithImpl<$Res>
    extends _$HarvestSettingCopyWithImpl<$Res, _$HarvestSettingImpl>
    implements _$$HarvestSettingImplCopyWith<$Res> {
  __$$HarvestSettingImplCopyWithImpl(
    _$HarvestSettingImpl _value,
    $Res Function(_$HarvestSettingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HarvestSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? isActive = null}) {
    return _then(
      _$HarvestSettingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HarvestSettingImpl implements _HarvestSetting {
  const _$HarvestSettingImpl({
    required this.id,
    required this.name,
    this.isActive = false,
  });

  factory _$HarvestSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$HarvestSettingImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'HarvestSetting(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HarvestSettingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isActive);

  /// Create a copy of HarvestSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HarvestSettingImplCopyWith<_$HarvestSettingImpl> get copyWith =>
      __$$HarvestSettingImplCopyWithImpl<_$HarvestSettingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HarvestSettingImplToJson(this);
  }
}

abstract class _HarvestSetting implements HarvestSetting {
  const factory _HarvestSetting({
    required final String id,
    required final String name,
    final bool isActive,
  }) = _$HarvestSettingImpl;

  factory _HarvestSetting.fromJson(Map<String, dynamic> json) =
      _$HarvestSettingImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isActive;

  /// Create a copy of HarvestSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HarvestSettingImplCopyWith<_$HarvestSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
