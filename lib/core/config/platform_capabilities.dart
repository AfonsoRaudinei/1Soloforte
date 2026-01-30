import 'package:flutter/foundation.dart' show kIsWeb;

/// Centralized source of truth for platform capabilities.
/// This replaces scattered `kIsWeb` checks to ensure consistent "Web Mode" behavior.
class PlatformCapabilities {
  // Prevent instantiation
  PlatformCapabilities._();

  /// Whether the current platform is Web.
  ///
  /// ⚠️ PREFER USING SPECIFIC CAPABILITY FLAGS BELOW.
  /// Use this only when a capability flag doesn't cover the specific need
  /// (e.g. platform-specific UI rendering).
  static const bool isWeb = kIsWeb;

  /// Whether the platform supports local SQLite database persistence.
  ///
  /// - Web: False (In-memory or empty behavior)
  /// - Mobile/Desktop: True (SQLite)
  static const bool supportsLocalDatabase = !kIsWeb;

  /// Whether the platform supports encrypted secure storage.
  ///
  /// - Web: False (No-op)
  /// - Mobile/Desktop: True (Keychain/Keystore)
  static const bool supportsSecureStorage = !kIsWeb;

  /// Whether the platform supports custom SSL certificate pinning.
  ///
  /// - Web: False (Browser handles SSL)
  /// - Mobile/Desktop: True (Dio/HttpClient)
  static const bool supportsCertPinning = !kIsWeb;

  /// Whether the platform supports device security checks (Root/Jailbreak).
  ///
  /// - Web: False (Not applicable/Sandboxed)
  /// - Mobile: True
  static const bool supportsDeviceSecurityChecks = !kIsWeb;
}
