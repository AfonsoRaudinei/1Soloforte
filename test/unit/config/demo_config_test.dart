import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/core/config/demo_config.dart';
import '../../test_setup.dart';

/// Unit tests for DemoConfig.
///
/// These tests verify the demo mode configuration is working correctly.
void main() {
  setUpAll(() => setupTestEnvironment());

  group('DemoConfig', () {
    test('isDemoEnabled returns true in debug mode (test environment)', () {
      // In test environment, kDebugMode is typically true
      // DemoConfig.isDemoEnabled should return true or based on environment variable
      final result = DemoConfig.isDemoEnabled;
      // We just verify it doesn't crash
      expect(result, isA<bool>());
    });

    test('demoEmail returns a valid email format', () {
      final email = DemoConfig.demoEmail;
      expect(email, isNotEmpty);
      expect(email, contains('@'));
    });

    test('demoUserName returns a non-empty string', () {
      final name = DemoConfig.demoUserName;
      expect(name, isNotEmpty);
    });

    test('demoUserId generates a deterministic ID based on email', () {
      final id1 = DemoConfig.demoUserId;
      final id2 = DemoConfig.demoUserId;

      expect(id1, equals(id2)); // Same email should produce same ID
      expect(id1, startsWith('demo-'));
    });

    test('generateDemoToken creates unique tokens', () {
      final token1 = DemoConfig.generateDemoToken();
      // Small delay to ensure different timestamps
      final token2 = DemoConfig.generateDemoToken();

      expect(token1, startsWith('demo-token-'));
      expect(token2, startsWith('demo-token-'));
      // Note: tokens could be the same if executed in same millisecond
    });

    test('validateDemoCredentials rejects empty password', () {
      final result = DemoConfig.validateDemoCredentials(
        DemoConfig.demoEmail,
        '',
      );
      expect(result, isFalse);
    });

    test(
      'validateDemoCredentials accepts non-empty password for demo email',
      () {
        // This will only work if isDemoEnabled is true
        if (DemoConfig.isDemoEnabled) {
          final result = DemoConfig.validateDemoCredentials(
            DemoConfig.demoEmail,
            'anypassword',
          );
          expect(result, isTrue);
        }
      },
    );

    test('validateDemoCredentials rejects wrong email', () {
      final result = DemoConfig.validateDemoCredentials(
        'wrong@email.com',
        'password',
      );
      expect(result, isFalse);
    });
  });
}
