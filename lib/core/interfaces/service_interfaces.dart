import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/features/auth/domain/auth_state.dart';

/// Interface for database service.
///
/// This abstraction allows for easy mocking in tests and
/// supports dependency injection via Riverpod.
abstract interface class IDatabaseService {
  /// Get the database instance.
  Future<Database> get database;

  /// Close the database connection.
  Future<void> close();

  /// Check if the database is open.
  bool get isOpen;
}

/// Interface for authentication service.
///
/// Abstracts authentication operations for testability.
abstract interface class IAuthService {
  /// Stream of authentication state changes.
  Stream<AuthState?> get authStateChanges;

  /// Login with email and password.
  Future<AuthState> login(String email, String password);

  /// Register a new user.
  Future<AuthState> register(String name, String email, String password);

  /// Logout the current user.
  Future<void> logout();

  /// Check current authentication status.
  Future<AuthState?> checkAuth();

  /// Sign in with Google.
  Future<AuthState> signInWithGoogle();

  /// Sign in with Apple.
  Future<AuthState> signInWithApple();

  /// Request password reset.
  Future<void> forgotPassword(String email);

  /// Reset password (after email link).
  Future<void> resetPassword(String code, String newPassword);

  /// Enter demo mode directly without authentication.
  /// This creates a special demo session that bypasses all credential validation.
  Future<AuthState> enterDemoMode();

  /// Update password (requires re-authentication or active session).
  Future<void> updatePassword(String newPassword);

  /// Re-authenticate user with password (for sensitive actions).
  Future<void> reauthenticate(String password);
}

/// Interface for secure storage service.
///
/// Abstracts secure storage operations for testability.
abstract interface class ISecureStorageService {
  /// Save authentication token.
  Future<void> saveAuthToken(String token);

  /// Get authentication token.
  Future<String?> getAuthToken();

  /// Save user ID.
  Future<void> saveUserId(String userId);

  /// Get user ID.
  Future<String?> getUserId();

  /// Save user email.
  Future<void> saveUserEmail(String email);

  /// Get user email.
  Future<String?> getUserEmail();

  /// Clear all session data.
  Future<void> clearSession();
}

/// Interface for location service.
///
/// Abstracts location operations for testability.
abstract interface class ILocationService {
  /// Get current position.
  Future<Position> getCurrentPosition();

  /// Stream of position updates.
  Stream<Position> get positionStream;

  /// Check if location service is enabled.
  Future<bool> isLocationServiceEnabled();

  /// Request location permission.
  Future<LocationPermission> requestPermission();
}

/// Simplified position representation.
class Position {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const Position({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });
}

/// Location permission status.
enum LocationPermission { denied, deniedForever, whileInUse, always }

/// Interface for API client.
///
/// Abstracts HTTP operations for testability.
abstract interface class IApiClient {
  /// Perform GET request.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  });

  /// Perform POST request.
  Future<Map<String, dynamic>> post(String path, {dynamic data});

  /// Perform PUT request.
  Future<Map<String, dynamic>> put(String path, {dynamic data});

  /// Perform DELETE request.
  Future<Map<String, dynamic>> delete(String path);

  /// Perform PATCH request.
  Future<Map<String, dynamic>> patch(String path, {dynamic data});
}

/// Interface for connectivity service.
///
/// Abstracts network connectivity checking.
abstract interface class IConnectivityService {
  /// Check if currently connected.
  Future<bool> get isConnected;

  /// Stream of connectivity changes.
  Stream<bool> get connectivityStream;
}
