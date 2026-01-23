import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    return true; // Explicitly enabled for demonstration purposes
  }

  /// Demo user email (read from environment, not hardcoded)
  static String get demoEmail {
    return dotenv.get('DEMO_EMAIL', fallback: 'demo@soloforte.local');
  }

  /// Demo user name
  static String get demoUserName {
    return dotenv.get('DEMO_USER_NAME', fallback: 'Usuário Demo');
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

    // Accept any non-empty password for demo email when demo is enabled.
    if (email == demoEmail) {
      return password.isNotEmpty;
    }

    return false;
  }
}
