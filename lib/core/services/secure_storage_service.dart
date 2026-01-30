import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soloforte_app/core/config/platform_capabilities.dart';
import 'dart:convert';

/// Secure storage service for sensitive data
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  // Auth Token
  static Future<void> saveAuthToken(String token) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: _authTokenKey, value: token);
  }

  static Future<String?> getAuthToken() async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: _authTokenKey);
  }

  static Future<void> deleteAuthToken() async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.delete(key: _authTokenKey);
  }

  // Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: _refreshTokenKey);
  }

  // User Data
  static Future<void> saveUserId(String userId) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: _userIdKey);
  }

  static Future<void> saveUserEmail(String email) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: _userEmailKey, value: email);
  }

  static Future<String?> getUserEmail() async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: _userEmailKey);
  }

  // Remember Me (Login screen)
  static const String _rememberedEmailKey = 'remembered_email';

  static Future<void> saveRememberedEmail(String email) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: _rememberedEmailKey, value: email);
  }

  static Future<String?> getRememberedEmail() async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: _rememberedEmailKey);
  }

  static Future<void> clearRememberedEmail() async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.delete(key: _rememberedEmailKey);
  }

  // Generic secure storage
  static Future<void> write(String key, String value) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.delete(key: key);
  }

  // Store JSON securely
  static Future<void> writeJson(String key, Map<String, dynamic> json) async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    final jsonString = jsonEncode(json);
    await _storage.write(key: key, value: jsonString);
  }

  static Future<Map<String, dynamic>?> readJson(String key) async {
    if (!PlatformCapabilities.supportsSecureStorage) return null;
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // Clear all secure storage
  static Future<void> clearAll() async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.deleteAll();
  }

  // Clear session (keep remembered email)
  static Future<void> clearSession() async {
    if (!PlatformCapabilities.supportsSecureStorage) return;
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
    // Do not delete _rememberedEmailKey
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    if (!PlatformCapabilities.supportsSecureStorage) return false;
    final value = await _storage.read(key: key);
    return value != null;
  }

  // Get all keys
  static Future<Map<String, String>> readAll() async {
    if (!PlatformCapabilities.supportsSecureStorage) return {};
    return await _storage.readAll();
  }
}
