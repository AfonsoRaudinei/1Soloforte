import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// App Settings Entity
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(true) bool pushNotificationsEnabled,
    @Default(true) bool emailNotificationsEnabled,
    @Default(true) bool automaticAlertsEnabled,
    @Default(false) bool offlineModeEnabled,
    @Default(true) bool autoSyncEnabled,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default('ios') String visualStyle,
    String? farmLogoPath,
    String? language,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
