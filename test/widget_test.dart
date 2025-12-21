import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/main.dart';
import 'package:soloforte_app/features/landing/presentation/landing_screen.dart';
import 'package:soloforte_app/features/auth/presentation/auth_provider.dart';

void main() {
  testWidgets('SoloForteApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We get the initial route immediately (LandingScreen) because authState emits null.
    // However, we mock it to be safe and explicit.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const SoloForteApp(),
      ),
    );

    // Trigger a frame to allow router to navigate to initial route and animations to settle
    await tester.pumpAndSettle();

    // Verify that the LandingScreen is displayed
    expect(find.byType(LandingScreen), findsOneWidget);

    // Verify that the text "Acessar Soloforte" is present
    expect(find.text('Acessar Soloforte'), findsOneWidget);
  });
}
