import 'package:flutter/foundation.dart';

/// Demo mode configuration.
///
/// In production, demo mode should be controlled via Firebase Remote Config
/// or environment variables. This class provides a centralized way to manage
/// demo/mock authentication without hardcoding credentials.
class DemoConfig {
  // Private constructor to prevent instantiation
  DemoConfig._();

  /// Whether demo mode is enabled.
  /// In production, this should be false or controlled via Remote Config.
  static bool get isDemoEnabled {
    // Check environment variable first (set via --dart-define)
    const envDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

    // Allow demo in debug mode OR if explicitly enabled via environment
    if (kDebugMode) return true;
    if (envDemoMode) return true;

    // TODO: Replace with Firebase Remote Config check in production
    // return FirebaseRemoteConfig.instance.getBool('demo_mode_enabled');
    return false;
  }

  /// Demo user email (read from environment, not hardcoded)
  static String get demoEmail {
    return const String.fromEnvironment(
      'DEMO_EMAIL',
      defaultValue: 'demo@soloforte.local', // Local-only default
    );
  }

  /// Demo user name
  static String get demoUserName {
    return const String.fromEnvironment(
      'DEMO_USER_NAME',
      defaultValue: 'Usuário Demo',
    );
  }

  /// Generate a demo user ID (deterministic based on email)
  static String get demoUserId {
    return 'demo-${demoEmail.hashCode.abs()}';
  }

  /// Generate a demo token (NOT a real secret, just for mock flow)
  static String generateDemoToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'demo-token-$timestamp';
  }

  /// Validate demo credentials.
  /// Returns true if demo mode is enabled and credentials match.
  ///
  /// NOTE: In a real app, you would NEVER validate passwords client-side.
  /// This is purely for demo/development purposes.
  static bool validateDemoCredentials(String email, String password) {
    if (!isDemoEnabled) return false;

    // Accept any password for demo mode in debug builds
    // This is intentional - we're not validating real credentials
    if (kDebugMode && email == demoEmail) {
      return password.isNotEmpty;
    }

    return false;
  }
}
