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
    this.language,
  });

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
  final String? language;

  @override
  String toString() {
    return 'AppSettings(pushNotificationsEnabled: $pushNotificationsEnabled, emailNotificationsEnabled: $emailNotificationsEnabled, automaticAlertsEnabled: $automaticAlertsEnabled, offlineModeEnabled: $offlineModeEnabled, autoSyncEnabled: $autoSyncEnabled, themeMode: $themeMode, visualStyle: $visualStyle, farmLogoPath: $farmLogoPath, language: $language)';
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
  String? get language;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
