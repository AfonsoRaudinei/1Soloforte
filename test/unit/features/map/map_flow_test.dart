import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:soloforte_app/features/dashboard/presentation/providers/dashboard_state.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('Map Flow & Dashboard Controller', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be neutral', () {
      final state = container.read(dashboardControllerProvider);
      expect(state.activeMode, MapMode.neutral);
      expect(state.tempPin, isNull);
    });

    test('Activate Occurrence Mode', () {
      final controller = container.read(dashboardControllerProvider.notifier);
      controller.setMode(MapMode.occurrence);

      final state = container.read(dashboardControllerProvider);
      expect(state.activeMode, MapMode.occurrence);
      expect(state.tempPin, isNull);
    });

    test('Set Temp Pin in Occurrence Mode', () {
      final controller = container.read(dashboardControllerProvider.notifier);
      controller.setMode(MapMode.occurrence);

      final point = LatLng(-10, -50);
      controller.setTempPin(point);

      final state = container.read(dashboardControllerProvider);
      expect(state.tempPin, point);
    });

    test('Switching mode clears Temp Pin', () {
      final controller = container.read(dashboardControllerProvider.notifier);
      controller.setMode(MapMode.occurrence);
      controller.setTempPin(LatLng(-10, -50));

      // Switch to Marketing
      controller.setMode(MapMode.marketing);

      final state = container.read(dashboardControllerProvider);
      expect(state.activeMode, MapMode.marketing);
      expect(state.tempPin, isNull);
    });

    test('Toggle Occurrence Mode returns to Neutral', () {
      final controller = container.read(dashboardControllerProvider.notifier);
      controller.setMode(MapMode.occurrence);
      expect(
        container.read(dashboardControllerProvider).activeMode,
        MapMode.occurrence,
      );

      // Toggle
      controller.setMode(MapMode.occurrence);

      final state = container.read(dashboardControllerProvider);
      expect(state.activeMode, MapMode.neutral);
    });

    test('Finish Occurrence Flow (Reset to Neutral) clears pin', () {
      final controller = container.read(dashboardControllerProvider.notifier);
      controller.setMode(MapMode.occurrence);
      controller.setTempPin(LatLng(-10, -50));

      // Simulate Save/Cancel -> Reset
      controller.setMode(MapMode.neutral);

      final state = container.read(dashboardControllerProvider);
      expect(state.activeMode, MapMode.neutral);
      expect(state.tempPin, isNull);
    });
  });
}
