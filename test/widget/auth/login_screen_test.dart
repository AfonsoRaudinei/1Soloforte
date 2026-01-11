import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:soloforte_app/features/auth/presentation/login_screen.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:soloforte_app/core/interfaces/service_interfaces.dart';
import 'package:soloforte_app/features/auth/domain/auth_state.dart' as domain;

import 'login_screen_test.mocks.dart';

@GenerateMocks([IAuthService])
void main() {
  late MockIAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockIAuthService();
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('LoginScreen renders correctly', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('SoloForte'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);

    // Check for inputs by label text only, as widgetWithText is tricky with decorations
    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(2));
  });

  testWidgets('LoginScreen performs login interaction', (tester) async {
    // Setup Mock
    when(mockAuthService.login(any, any)).thenAnswer(
      (_) async => domain.AuthState.authenticated(
        userId: '123',
        email: 'test@email.com',
        name: 'Test User',
        token: 'token',
        refreshToken: 'refresh',
      ),
    );

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // Enter text
    final textFields = find.byType(TextField);
    expect(textFields, findsAtLeastNWidgets(2));

    await tester.enterText(
      textFields.at(0),
      'test@email.com',
    ); // First is Email
    await tester.enterText(
      textFields.at(1),
      'password123',
    ); // Second is Password

    // Tap login button
    await tester.tap(find.text('Entrar'));
    await tester.pump(); // Start process

    // Wait for async logic and animations
    // Using explicit pumps instead of pumpAndSettle to avoid infinite animation timeouts
    await tester.pump(const Duration(milliseconds: 100)); // async gap
    await tester.pump(const Duration(seconds: 1)); // allow logic to complete

    // Verify service call
    verify(mockAuthService.login('test@email.com', 'password123')).called(1);

    // Verify success message
    await tester.pump(); // Ensure UI update
    expect(find.text('Login realizado com sucesso!'), findsOneWidget);
  });

  testWidgets('LoginScreen performs demo mode interactions', (tester) async {
    // Setup Mock for demo mode
    when(mockAuthService.enterDemoMode()).thenAnswer(
      (_) async => domain.AuthState.authenticated(
        userId: 'demo-123',
        email: 'demo@soloforte.local',
        name: 'Usuário Demo',
        token: 'demo-token',
        refreshToken: 'demo-refresh',
        isDemo: true,
      ),
    );

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // Find and tap demo button
    final demoButton = find.text('Experimentar Modo Demo');
    expect(demoButton, findsOneWidget);
    await tester.tap(demoButton);
    await tester.pump(); // Start process

    // Wait for async logic and animations
    await tester.pump(const Duration(milliseconds: 100)); // async gap
    await tester.pump(const Duration(seconds: 1)); // allow logic to complete

    // Verify service call
    verify(mockAuthService.enterDemoMode()).called(1);

    // Verify success message
    await tester.pump(); // Ensure UI update
    expect(find.text('Bem-vindo ao Modo Demonstração!'), findsOneWidget);
  });
}
