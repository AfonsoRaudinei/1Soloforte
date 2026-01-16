import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';

abstract class AgendaLocalDataSource {
  Future<List<Event>> getEvents();
  Future<void> upsertEvent(Event event);
  Future<void> deleteEvent(String id);
}

class AgendaLocalDataSourceImpl implements AgendaLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Event>> getEvents() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableAgendaEvents,
      orderBy: 'start_time ASC',
    );
    if (maps.isEmpty) return [];
    return maps.map((row) {
      final jsonStr = row['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Event.fromJson(data);
    }).toList();
  }

  @override
  Future<void> upsertEvent(Event event) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableAgendaEvents,
      _toRow(event),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteEvent(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableAgendaEvents,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, Object?> _toRow(Event event) {
    return {
      'id': event.id,
      'start_time': event.startTime.millisecondsSinceEpoch,
      'status': event.status.name,
      'json_data': jsonEncode(event.toJson()),
    };
  }
}
