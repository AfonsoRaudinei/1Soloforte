import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/auth_state.dart' as app;
import '../../../core/services/secure_storage_service.dart';
import '../../../core/config/demo_config.dart';
import '../../../core/interfaces/service_interfaces.dart';

/// Authentication Service with Mock Fallback
class AuthService implements IAuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Stream Controller for unified Auth State (valid for both Firebase and Mock)
  final _authStateController = StreamController<app.AuthState?>.broadcast();

  // Demo mode is now controlled via DemoConfig
  // No more hardcoded credentials!

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance {
    _init();
  }

  void _init() {
    // Listen to Firebase Auth changes and propagate
    _auth.authStateChanges().listen((User? user) {
      _checkAndEmitFirebaseUser(user);
    });

    // Check initial state (could be mock or firebase)
    checkAuth().then((state) {
      _authStateController.add(state);
    });
  }

  Future<void> _checkAndEmitFirebaseUser(User? user) async {
    if (user == null) {
      // If Firebase user is null, checking if there is a persistent mock session
      final mockState = await _checkMockSession();
      _authStateController.add(mockState);
    } else {
      // It is a Firebase user
      try {
        final state = await _getFirebaseAuthState(user);
        _authStateController.add(state);
      } catch (e) {
        _authStateController.add(null);
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

  // Login with email and password
  @override
  Future<app.AuthState> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Login failed');

      final state = await _getFirebaseAuthState(user);
      _authStateController.add(state);
      return state;
    } on FirebaseAuthException {
      // Try mock login as fallback
      return _mockLogin(email, password);
    } catch (e) {
      // Try mock login as fallback
      return _mockLogin(email, password);
    }
  }

  Future<app.AuthState> _getFirebaseAuthState(User user) async {
    // Get user data from Firestore
    final userData = await _firestore.collection('users').doc(user.uid).get();
    final name = userData.data()?['name'] ?? user.displayName ?? 'User';

    // Get token
    final token = await user.getIdToken();

    // Save to secure storage
    await SecureStorageService.saveAuthToken(token ?? '');
    await SecureStorageService.saveUserId(user.uid);
    await SecureStorageService.saveUserEmail(user.email ?? '');

    return app.AuthState.authenticated(
      userId: user.uid,
      email: user.email ?? '',
      name: name,
      token: token ?? '',
      refreshToken: user.refreshToken ?? '',
    );
  }

  // Register new user
  @override
  Future<app.AuthState> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Registration failed');

      // Update display name
      await user.updateDisplayName(name);

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
      });

      // Force token refresh to get new claims if any
      final token = await user.getIdToken(true);

      // Save to secure storage
      await SecureStorageService.saveAuthToken(token ?? '');
      await SecureStorageService.saveUserId(user.uid);
      await SecureStorageService.saveUserEmail(email);

      final state = app.AuthState.authenticated(
        userId: user.uid,
        email: email,
        name: name,
        token: token ?? '',
        refreshToken: user.refreshToken ?? '',
      );

      _authStateController.add(state);
      return state;
    } on FirebaseAuthException {
      // Try mock register as fallback
      return _mockRegister(name, email, password);
    } catch (e) {
      // Try mock register as fallback
      return _mockRegister(name, email, password);
    }
  }

  // Google Sign In
  @override
  Future<app.AuthState> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final UserCredential credential = await _auth.signInWithPopup(
        googleProvider,
      );
      return _processUserCredential(credential);
    } catch (e) {
      // Fallback to demo login if enabled
      return _demoLogin();
    }
  }

  // Apple Sign In
  @override
  Future<app.AuthState> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final UserCredential credential = await _auth.signInWithPopup(
        appleProvider,
      );
      return _processUserCredential(credential);
    } catch (e) {
      // Fallback to demo login if enabled
      return _demoLogin();
    }
  }

  Future<app.AuthState> _processUserCredential(
    UserCredential credential,
  ) async {
    final user = credential.user;
    if (user == null) throw Exception('Authentication failed');

    // Check if user exists in Firestore, if not create
    final docKey = _firestore.collection('users').doc(user.uid);
    final snapshot = await docKey.get();

    String name = user.displayName ?? 'User';

    if (!snapshot.exists) {
      await docKey.set({
        'name': name,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
        'photoUrl': user.photoURL,
      });
    } else {
      name = snapshot.data()?['name'] ?? name;
    }

    final state = await _getFirebaseAuthState(user);
    _authStateController.add(state);
    return state;
  }

  /// Demo login using DemoConfig (no hardcoded credentials)
  Future<app.AuthState> _demoLogin() async {
    if (!DemoConfig.isDemoEnabled) {
      throw Exception('Demo mode is not enabled');
    }

    final token = DemoConfig.generateDemoToken();
    final userId = DemoConfig.demoUserId;
    final email = DemoConfig.demoEmail;
    final name = DemoConfig.demoUserName;

    // Save to secure storage
    await SecureStorageService.saveAuthToken(token);
    await SecureStorageService.saveUserId(userId);
    await SecureStorageService.saveUserEmail(email);

    final state = app.AuthState.authenticated(
      userId: userId,
      email: email,
      name: name,
      token: token,
      refreshToken: 'demo-refresh-token',
    );

    _authStateController.add(state);
    return state;
  }

  /// Mock login - validates using DemoConfig
  Future<app.AuthState> _mockLogin(String email, String password) async {
    // Use DemoConfig for validation instead of hardcoded map
    if (!DemoConfig.validateDemoCredentials(email, password)) {
      throw Exception('Credenciais inválidas ou modo demo desabilitado');
    }

    return _demoLogin();
  }

  // Mock register (fallback) - for demo mode only
  Future<app.AuthState> _mockRegister(
    String name,
    String email,
    String password,
  ) async {
    if (!DemoConfig.isDemoEnabled) {
      throw Exception('Demo mode is not enabled');
    }

    // In demo mode, we just create a demo session
    final token = DemoConfig.generateDemoToken();
    final userId = 'demo-user-${DateTime.now().millisecondsSinceEpoch}';

    // Save to secure storage
    await SecureStorageService.saveAuthToken(token);
    await SecureStorageService.saveUserId(userId);
    await SecureStorageService.saveUserEmail(email);

    final state = app.AuthState.authenticated(
      userId: userId,
      email: email,
      name: name,
      token: token,
      refreshToken: 'demo-refresh-token',
    );

    _authStateController.add(state);
    return state;
  }

  // Logout
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Ignore Firebase errors on logout
    }
    await SecureStorageService.clearSession();
    _authStateController.add(null);
  }

  // Check current auth status
  @override
  Future<app.AuthState?> checkAuth() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return _getFirebaseAuthState(user);
      }
      return _checkMockSession();
    } catch (e) {
      return _checkMockSession();
    }
  }

  // Forgot password
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception(
        'Funcionalidade disponível apenas com Firebase configurado',
      );
    }
  }

  // Reset password (after email link)
  @override
  Future<void> resetPassword(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Usuário não encontrado');
      case 'wrong-password':
        return Exception('Senha incorreta');
      case 'email-already-in-use':
        return Exception('Email já cadastrado');
      case 'weak-password':
        return Exception('Senha muito fraca');
      case 'invalid-email':
        return Exception('Email inválido');
      case 'user-disabled':
        return Exception('Usuário desabilitado');
      case 'too-many-requests':
        return Exception('Muitas tentativas. Tente mais tarde.');
      default:
        return Exception('Erro de autenticação: ${e.message}');
    }
  }

  // Listen to auth state changes
  @override
  Stream<app.AuthState?> get authStateChanges => _authStateController.stream;
}
