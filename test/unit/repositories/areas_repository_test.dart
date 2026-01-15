import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/features/areas/data/areas_repository.dart';
import '../../test_setup.dart';

void main() {
  group('AreasRepository', () {
    late AreasRepository repository;

    setUpAll(() => setupTestEnvironment());

    setUp(() {
      repository = AreasRepository();
    });

    test('getAreas returns list of areas', () async {
      // Act
      final areas = await repository.getAreas();

      // Assert
      expect(areas, isNotEmpty);
      expect(areas.length, equals(3));
      expect(areas.first.name, equals('Talhão Norte'));
    });

    test('getAreas returns areas with correct data', () async {
      // Act
      final areas = await repository.getAreas();
      final firstArea = areas.first;

      // Assert
      expect(firstArea.id, isNotNull);
      expect(firstArea.hectares, greaterThan(0));
      expect(firstArea.clienteNome, isNotEmpty);
      expect(firstArea.fazendaNome, isNotEmpty);
      expect(firstArea.coordinates, isNotEmpty);
    });

    test('getAreas returns areas with different statuses', () async {
      // Act
      final areas = await repository.getAreas();

      // Assert
      final statuses = areas.map((a) => a.status).toSet();
      expect(statuses.contains('active'), isTrue);
      expect(statuses.contains('monitoring'), isTrue);
    });

    test('getAreas simulates network delay', () async {
      // Arrange
      final stopwatch = Stopwatch()..start();

      // Act
      await repository.getAreas();

      // Assert
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(400));
    });
  });
}
