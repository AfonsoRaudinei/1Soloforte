import 'dart:async';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> syncAll() async {
    // 1. Visits
    await _syncVisits();
    // 2. Areas
    await _syncAreas();
    // 3. Occurrences
    await _syncOccurrences();
  }

  Future<void> _syncVisits() async {
    final db = await _dbHelper.database;
    final dirtyRows = await db.query(
      'visits',
      where: 'is_dirty = ?',
      whereArgs: [1],
    );

    for (var row in dirtyRows) {
      final id = row['id'] as String;
      try {
        // Simulate Remote API Push
        await Future.delayed(const Duration(milliseconds: 500));

        // On success, mark as synced
        await db.update(
          'visits',
          {'is_dirty': 0, 'status': 'synced'},
          where: 'id = ?',
          whereArgs: [id],
        );
      } catch (e) {
        // Handle error (retry later)
        LoggerService.e('Error syncing visit $id', error: e, tag: 'SYNC');
      }
    }
  }

  Future<void> _syncAreas() async {
    final db = await _dbHelper.database;
    final dirtyRows = await db.query(
      'areas',
      where: 'is_dirty = ?',
      whereArgs: [1],
    );

    for (var row in dirtyRows) {
      final id = row['id'] as String;
      try {
        await Future.delayed(const Duration(milliseconds: 500));

        await db.update(
          'areas',
          {'is_dirty': 0},
          where: 'id = ?',
          whereArgs: [id],
        );
      } catch (e) {
        LoggerService.e('Error syncing area $id', error: e, tag: 'SYNC');
      }
    }
  }

  Future<void> _syncOccurrences() async {
    final db = await _dbHelper.database;
    final dirtyRows = await db.query(
      'occurrences',
      where: 'is_dirty = ?',
      whereArgs: [1],
    );

    for (var row in dirtyRows) {
      final id = row['id'] as String;
      try {
        await Future.delayed(const Duration(milliseconds: 500));

        await db.update(
          'occurrences',
          {'is_dirty': 0, 'status': 'monitoring'}, // or whatever status logic
          where: 'id = ?',
          whereArgs: [id],
        );
      } catch (e) {
        LoggerService.e('Error syncing occurrence $id', error: e, tag: 'SYNC');
      }
    }
  }
}
