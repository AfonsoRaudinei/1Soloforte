import 'package:mockito/mockito.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<Database> get database => super.noSuchMethod(
    Invocation.getter(#database),
    returnValue: Future.value(MockDatabase()),
    returnValueForMissingStub: Future.value(MockDatabase()),
  );
}

class MockDatabase extends Mock implements Database {
  @override
  Future<int> insert(
    String? table,
    Map<String, Object?>? values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => super.noSuchMethod(
    Invocation.method(
      #insert,
      [table, values],
      {#nullColumnHack: nullColumnHack, #conflictAlgorithm: conflictAlgorithm},
    ),
    returnValue: Future.value(1),
    returnValueForMissingStub: Future.value(1),
  );

  @override
  Future<List<Map<String, Object?>>> query(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) => super.noSuchMethod(
    Invocation.method(
      #query,
      [table],
      {
        #distinct: distinct,
        #columns: columns,
        #where: where,
        #whereArgs: whereArgs,
        #groupBy: groupBy,
        #having: having,
        #orderBy: orderBy,
        #limit: limit,
        #offset: offset,
      },
    ),
    returnValue: Future.value(<Map<String, Object?>>[]),
    returnValueForMissingStub: Future.value(<Map<String, Object?>>[]),
  );
}
