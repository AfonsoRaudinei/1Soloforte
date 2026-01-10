import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Global test setup for SoloForte tests.
///
/// This file provides common test utilities and initialization
/// for all test files in the project.

/// Initialize the test environment.
/// Call this in setUpAll() of each test file that needs database access.
void setupTestEnvironment() {
  // Initialize FFI for SQLite in tests
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Disable debug prints during tests
  debugPrint = (String? message, {int? wrapWidth}) {};
}

/// Reset the test environment.
/// Call this in tearDownAll() if needed.
void teardownTestEnvironment() {
  // Any cleanup needed
}

/// Create a mock container for tests with commonly needed overrides.
///
/// Example usage:
/// ```dart
/// void main() {
///   setUpAll(() => setupTestEnvironment());
///
///   testWidgets('my test', (tester) async {
///     await tester.pumpWidget(
///       ProviderScope(
///         overrides: createTestOverrides(),
///         child: MyWidget(),
///       ),
///     );
///   });
/// }
/// ```
// List<Override> createTestOverrides() {
//   return [
//     // Add common overrides here
//   ];
// }

/// Test utilities for async operations
extension TestFutures<T> on Future<T> {
  /// Expect this future to complete successfully.
  Future<T> shouldSucceed() async {
    final result = await this;
    return result;
  }

  /// Expect this future to throw an exception.
  Future<void> shouldThrow<E extends Exception>() async {
    try {
      await this;
      fail('Expected to throw $E but completed successfully');
    } on E {
      // Expected
    }
  }
}

/// Test utilities for delays
Future<void> pumpAndSettle(WidgetTester tester, {Duration? delay}) async {
  await tester.pumpAndSettle();
  if (delay != null) {
    await tester.pump(delay);
  }
}
