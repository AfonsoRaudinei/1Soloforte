import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_service.dart';
import 'package:soloforte_app/core/database/database_helper.dart';

import 'database_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late DatabaseServiceImpl service;
  late MockDatabaseHelper mockHelper;
  late MockDatabase mockDb;

  setUp(() {
    mockHelper = MockDatabaseHelper();
    mockDb = MockDatabase();
    service = DatabaseServiceImpl(mockHelper);
  });

  group('DatabaseServiceImpl', () {
    test('database getter returns helper database', () async {
      when(mockHelper.database).thenAnswer((_) async => mockDb);
      final db = await service.database;
      expect(db, mockDb);
      verify(mockHelper.database).called(1);
    });

    // Tests for isOpen and close() removed because DatabaseHelper does not expose isOpen contract.
    // The previous tests were testing a non-existent contract.
  });
}
