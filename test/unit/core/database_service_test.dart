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
    test('isOpen returns helper status', () {
      when(mockHelper.isOpen).thenReturn(true);
      expect(service.isOpen, true);

      when(mockHelper.isOpen).thenReturn(false);
      expect(service.isOpen, false);
    });

    test('database getter returns helper database', () async {
      when(mockHelper.database).thenAnswer((_) async => mockDb);
      final db = await service.database;
      expect(db, mockDb);
      verify(mockHelper.database).called(1);
    });

    test('close closes database if open', () async {
      when(mockHelper.isOpen).thenReturn(true);
      when(mockHelper.database).thenAnswer((_) async => mockDb);

      await service.close();

      verify(mockDb.close()).called(1);
    });

    test('close does not close if not open', () async {
      when(mockHelper.isOpen).thenReturn(false);

      await service.close();

      // Since database is not even accessed if not open (in implementation logic),
      // we verify database getter was not called ideally, but implementation might differ.
      // Based on my implementation: if (_helper.isOpen) { final db = await _helper.database; ... }
      // So verifyNever(mockHelper.database) is tricky if isOpen is checked first.

      verifyNever(mockDb.close());
    });
  });
}
