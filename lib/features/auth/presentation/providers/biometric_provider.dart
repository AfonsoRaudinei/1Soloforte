import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:soloforte_app/core/services/biometric_service.dart';

// Biometric Service Provider
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

// Biometric Availability Provider
final biometricAvailabilityProvider = FutureProvider<bool>((ref) async {
  final biometric = ref.watch(biometricServiceProvider);
  return await biometric.canAuthenticate();
});

// Available Biometrics Provider
final availableBiometricsProvider = FutureProvider<List<BiometricType>>((
  ref,
) async {
  final biometric = ref.watch(biometricServiceProvider);
  return await biometric.getAvailableBiometrics();
});
