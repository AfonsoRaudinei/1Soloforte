import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_service.dart';
import 'package:soloforte_app/core/interfaces/service_interfaces.dart';
import '../../domain/auth_state.dart' as app;

// Auth Service Provider
final authServiceProvider = Provider<IAuthService>((ref) {
  return AuthService();
});

// Auth State Provider
final authStateProvider = StreamProvider<app.AuthState?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Auth Controller Provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  IAuthService get _authService => _ref.read(authServiceProvider);

  // Login
  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
  }

  // Register
  Future<void> register(String name, String email, String password) async {
    await _authService.register(name, email, password);
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
    await _authService.signInWithApple();
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }

  // Reset Password
  Future<void> resetPassword(String code, String newPassword) async {
    await _authService.resetPassword(code, newPassword);
  }
}
