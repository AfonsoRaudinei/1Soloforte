import 'package:flutter/foundation.dart';
import 'dart:io'
    show
        Platform; // Conditional import would be better but this works if guarded
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Security Checker Service
/// Detects compromised devices and security threats
class SecurityChecker {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Check if device is rooted/jailbroken
  static Future<bool> isDeviceRooted() async {
    if (kIsWeb) return false;
    try {
      return await FlutterJailbreakDetection.jailbroken;
    } catch (e) {
      return false; // Assume not rooted on error
    }
  }

  /// Check if device is in developer mode
  static Future<bool> isDeveloperMode() async {
    if (kIsWeb) return false;
    try {
      return await FlutterJailbreakDetection.developerMode;
    } catch (e) {
      return false;
    }
  }

  /// Check if device is secure (not rooted and not in dev mode)
  static Future<bool> isDeviceSecure() async {
    final isRooted = await isDeviceRooted();
    final isDevMode = await isDeveloperMode();

    return !isRooted && !isDevMode;
  }

  /// Check if running on emulator
  static Future<bool> isEmulator() async {
    if (kIsWeb) return false;
    if (Platform.isAndroid) {
      return await _isAndroidEmulator();
    } else if (Platform.isIOS) {
      return await _isIOSSimulator();
    }
    return false;
  }

  static Future<bool> _isAndroidEmulator() async {
    if (kIsWeb) return false;
    try {
      final androidInfo = await _deviceInfo.androidInfo;

      return androidInfo.isPhysicalDevice == false ||
          androidInfo.fingerprint.toLowerCase().contains('generic') ||
          androidInfo.model.toLowerCase().contains('emulator') ||
          androidInfo.manufacturer.toLowerCase().contains('genymotion');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _isIOSSimulator() async {
    if (kIsWeb) return false;
    try {
      final iosInfo = await _deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    } catch (e) {
      return false;
    }
  }

  /// Get device security status
  static Future<DeviceSecurityStatus> getSecurityStatus() async {
    final isRooted = await isDeviceRooted();
    final isDevMode = await isDeveloperMode();
    final isEmu = await isEmulator();

    return DeviceSecurityStatus(
      isRooted: isRooted,
      isDeveloperMode: isDevMode,
      isEmulator: isEmu,
      isSecure: !isRooted && !isDevMode,
    );
  }
}

/// Device Security Status
class DeviceSecurityStatus {
  final bool isRooted;
  final bool isDeveloperMode;
  final bool isEmulator;
  final bool isSecure;

  DeviceSecurityStatus({
    required this.isRooted,
    required this.isDeveloperMode,
    required this.isEmulator,
    required this.isSecure,
  });

  String get warningMessage {
    if (isRooted) {
      return 'Dispositivo com root/jailbreak detectado. Isso pode comprometer a segurança dos seus dados.';
    } else if (isDeveloperMode) {
      return 'Modo desenvolvedor ativo. Desative para maior segurança.';
    } else if (isEmulator) {
      return 'Executando em emulador. Algumas funcionalidades podem estar limitadas.';
    }
    return '';
  }

  bool get hasWarning => !isSecure || isEmulator;
}
