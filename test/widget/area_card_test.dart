import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/features/areas/presentation/widgets/area_card.dart';
import 'package:soloforte_app/features/areas/domain/entities/area.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('AreaCard Widget', () {
    final testArea = Area(
      id: '1',
      name: 'Test Area',
      hectares: 50.5,
      clientId: 'client-1',
      clienteNome: 'Test Client',
      fazendaNome: 'Test Farm',
      status: 'active',
      coordinates: [
        const LatLng(-23.5, -46.6),
        const LatLng(-23.6, -46.6),
        const LatLng(-23.6, -46.7),
      ],
      culture: 'Soja',
      ndviAverage: 0.75,
    );

    testWidgets('renders area information', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AreaCard(area: testArea)),
        ),
      );

      // Assert
      expect(find.text('Test Area'), findsOneWidget);
      expect(find.text('Test Client • Test Farm'), findsOneWidget);
      expect(find.text('50.5 ha'), findsOneWidget);
      expect(find.text('Soja'), findsOneWidget);
    });

    testWidgets('shows status badge', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AreaCard(area: testArea)),
        ),
      );

      // Assert
      expect(find.text('Ativa'), findsOneWidget);
    });

    testWidgets('calls onTap callback', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AreaCard(area: testArea, onTap: () => tapped = true),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(AreaCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('displays NDVI value', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AreaCard(area: testArea)),
        ),
      );

      // Assert
      expect(find.text('0.75'), findsOneWidget);
    });
  });
}
