import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/features/occurrences/presentation/widgets/report_modal/report_form_fields.dart';

void main() {
  group('ReportFormFields Tests', () {
    // --- ReportTextInput Tests ---
    testWidgets('ReportTextInput displays label and hint', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportTextInput(
              label: 'Nome do Produtor',
              controller: controller,
              hint: 'Digite o nome',
            ),
          ),
        ),
      );

      expect(find.text('Nome do Produtor'), findsOneWidget);
      expect(find.text('Digite o nome'), findsOneWidget);
    });

    testWidgets('ReportTextInput updates controller', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportTextInput(
              label: 'Test',
              controller: controller,
              hint: 'Hint',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Valor Teste');
      expect(controller.text, 'Valor Teste');
    });

    // --- ReportTextArea Tests ---
    testWidgets('ReportTextArea displays hint and works', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportTextArea(controller: controller, hint: 'Descreva aqui'),
          ),
        ),
      );

      expect(find.text('Descreva aqui'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Texto longo');
      expect(controller.text, 'Texto longo');
    });

    // --- ReportDateInput Tests ---
    testWidgets('ReportDateInput displays formatted date when provided', (
      WidgetTester tester,
    ) async {
      final date = DateTime(2023, 10, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportDateInput(label: 'Data', date: date, onSelect: (_) {}),
          ),
        ),
      );

      expect(find.text('Data'), findsOneWidget);
      // Expect format used in widget (dd/MM/yyyy)
      expect(find.text('15/10/2023'), findsOneWidget);
    });

    testWidgets('ReportDateInput displays placeholder when date is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportDateInput(
              label: 'Data',
              date: null,
              onSelect: (_) {},
              placeholder: 'Selecione uma data',
            ),
          ),
        ),
      );

      expect(find.text('Selecione uma data'), findsOneWidget);
    });
  });
}
