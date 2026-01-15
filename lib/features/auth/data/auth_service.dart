import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_state.dart' as app;
import '../../../core/services/secure_storage_service.dart';
import '../../../core/config/demo_config.dart';
import '../../../core/interfaces/service_interfaces.dart';
import '../../../core/services/security_service.dart';

/// Authentication Service using Supabase Auth
class AuthService implements IAuthService {
  final SupabaseClient _supabase;

  // Stream Controller for unified Auth State
  final _authStateController = StreamController<app.AuthState?>.broadcast();

  AuthService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client {
    _init();
  }

  void _init() {
    // Listen to Supabase Auth changes
    _supabase.auth.onAuthStateChange.listen((data) {
      _checkAndEmitSupabaseUser(data.session);
    });

    // Check initial state
    checkAuth().then((state) {
      if (!_authStateController.isClosed) {
        _authStateController.add(state);
      }
    });
  }

  Future<void> _checkAndEmitSupabaseUser(Session? session) async {
    if (session == null) {
      // Check persistent mock session if not Supabase
      final mockState = await _checkMockSession();
      if (!_authStateController.isClosed) _authStateController.add(mockState);
    } else {
      // It is a Supabase user
      try {
        final state = await _getSupabaseAuthState(session);
        if (!_authStateController.isClosed) _authStateController.add(state);
      } catch (e) {
        if (!_authStateController.isClosed) _authStateController.add(null);
      }
    }
  }

  Future<app.AuthState?> _checkMockSession() async {
    final token = await SecureStorageService.getAuthToken();
    if (token != null &&
        (token.startsWith('mock-token-') || token.startsWith('demo-token-'))) {
      final userId = await SecureStorageService.getUserId();
      final email = await SecureStorageService.getUserEmail();

      if (userId != null && email != null && DemoConfig.isDemoEnabled) {
        return app.AuthState.authenticated(
          userId: userId,
          email: email,
          name: DemoConfig.demoUserName,
          token: token,
          refreshToken: 'demo-refresh-token',
        );
      }
    }
    return null;
  }

  // Login with email and password using Supabase
  @override
  Future<app.AuthState> login(String email, String password) async {
    // Check demo login first
    if (DemoConfig.isDemoEnabled &&
        DemoConfig.validateDemoCredentials(email, password)) {
      return _demoLogin();
    }

    // Check rate limit: 5 attempts per minute per email
    await SecurityService().validateAction(
      'login',
      userId: email,
      limit: 5,
      window: const Duration(minutes: 1),
    );

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = response.session;
      final user = response.user;

      if (user == null || session == null) throw Exception('Login failed');

      final state = await _getSupabaseAuthState(session);

      // Audit Log
      await SecurityService().logSecurityEvent(user.id, 'login_success');

      return state;
    } on AuthException catch (e) {
      // Try mock login as fallback if not actually a network error but invalid credentials that might match mock
      if (e.message.contains('Invalid login credentials')) {
        // Could check mock here if desired, but general flow is Supabase or Demo.
        // Let's assume strict separation unless demo config.
      }
      throw Exception(e.message);
    } catch (e) {
      // Fallback
      if (DemoConfig.isDemoEnabled) {
        return _mockLogin(email, password);
      }
      throw Exception('Login failed: $e');
    }
  }

  Future<app.AuthState> _getSupabaseAuthState(Session session) async {
    final user = session.user;

    // Get user metadata
    final name =
        user.userMetadata?['name'] ?? user.email?.split('@')[0] ?? 'User';

    // Save to secure storage
    await SecureStorageService.saveAuthToken(session.accessToken);
    await SecureStorageService.saveUserId(user.id);
    await SecureStorageService.saveUserEmail(user.email ?? '');

    return app.AuthState.authenticated(
      userId: user.id,
      email: user.email ?? '',
      name: name,
      token: session.accessToken,
      refreshToken: session.refreshToken ?? '',
    );
  }

  // Register new user using Supabase
  @override
  Future<app.AuthState> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final session = response.session;
      final user = response.user;

      // Ensure session exists (Supabase might require email confirmation)
      if (user != null && session == null) {
        throw Exception('Success! Please verify your email to login.');
      } else if (user != null && session != null) {
        final state = await _getSupabaseAuthState(session);
        return state;
      }
      throw Exception('Registration failed');
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Generic OAuth not fully implemented in this MVP replacement, triggering standard demo fallback or error
  @override
  Future<app.AuthState> signInWithGoogle() async {
    return _demoLogin();
  }

  @override
  Future<app.AuthState> signInWithApple() async {
    return _demoLogin();
  }

  // Logout using Supabase
  @override
  Future<void> logout() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await SecurityService().logSecurityEvent(user.id, 'logout');
    }

    try {
      await _supabase.auth.signOut();
    } catch (e) {
      // Ignore
    }
    await SecureStorageService.clearSession();
    if (!_authStateController.isClosed) _authStateController.add(null);
  }

  // Check current auth status
  @override
  Future<app.AuthState?> checkAuth() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        return _getSupabaseAuthState(session);
      }
      return _checkMockSession();
    } catch (e) {
      return _checkMockSession();
    }
  }

  // Forgot password using Supabase
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Reset/Update password (Supabase uses same updateUser logic usually, but strict reset flow might vary)
  @override
  Future<void> resetPassword(String code, String newPassword) async {
    // Usually via deep link handling in main app, effectively exchanging code for session then updateUser
    // For this simple service method:
    try {
      // This generally requires the session to be established via the code first using a deep link listener.
      // Here we assume session is active or this calls updateUser.
      // If passing 'code', we might use verifyOtp.
      // Supabase 'resetPasswordForEmail' sends a link. The link redirects to app.
      // Use updateUser from there.
      await updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Demo Login Logic (Same as before)
  Future<app.AuthState> _demoLogin() async {
    if (!DemoConfig.isDemoEnabled) throw Exception('Demo mode disabled');

    final token = DemoConfig.generateDemoToken();
    final userId = DemoConfig.demoUserId;
    final email = DemoConfig.demoEmail;
    final name = DemoConfig.demoUserName;

    await SecureStorageService.saveAuthToken(token);
    await SecureStorageService.saveUserId(userId);
    await SecureStorageService.saveUserEmail(email);

    final state = app.AuthState.authenticated(
      userId: userId,
      email: email,
      name: name,
      token: token,
      refreshToken: 'demo-refresh-token',
      isDemo: true,
    );

    if (!_authStateController.isClosed) _authStateController.add(state);
    return state;
  }

  @override
  Future<app.AuthState> enterDemoMode() => _demoLogin();

  Future<app.AuthState> _mockLogin(String email, String password) async {
    if (!DemoConfig.validateDemoCredentials(email, password)) {
      throw Exception('Invalid credentials');
    }
    return _demoLogin();
  }

  // --- New Methods ---

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await SecurityService().validateAction(
        'change_password',
        userId: user.id,
        limit: 3,
        window: const Duration(hours: 24),
      );
    }

    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (response.user == null) throw Exception('Update failed');

      if (user != null) {
        await SecurityService().logSecurityEvent(user.id, 'password_change');
      }
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    // Supabase doesn't have a direct "reauthenticate".
    // We simulate by trying to signIn with EMAIL (from current user) + Password.
    // If successful, it means password is correct.
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      throw Exception('No active user to reauthenticate');
    }

    await SecurityService().validateAction(
      'reauth',
      userId: currentUser.id,
      limit: 3,
      window: const Duration(minutes: 10),
    );

    try {
      final email = currentUser.email!;
      await _supabase.auth.signInWithPassword(email: email, password: password);
      // If success, we are good. Session might refresh but that's fine.
    } on AuthException catch (_) {
      throw Exception('Senha incorreta.');
    } catch (_) {
      throw Exception('Falha na reautenticação');
    }
  }

  // Close controller on dispose if needed (usually service singleton)
  void dispose() {
    _authStateController.close();
  }

  @override
  Stream<app.AuthState?> get authStateChanges => _authStateController.stream;
}
