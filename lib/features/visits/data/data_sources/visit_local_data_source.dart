import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/config/platform_capabilities.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import '../dtos/visit_dto.dart';

abstract class VisitLocalDataSource {
  Future<void> saveVisit(VisitDto visit);
  Future<List<VisitDto>> getVisits();
  Future<VisitDto?> getActiveVisit();
  Future<VisitDto?> getVisitById(String id);
}

class VisitLocalDataSourceImpl implements VisitLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> saveVisit(VisitDto visit) async {
    if (!PlatformCapabilities.supportsLocalDatabase) return;
    final db = await _dbHelper.database;
    await db.insert('visits', {
      'id': visit.id,
      'check_in_time': visit.checkInTime.millisecondsSinceEpoch,
      'status': visit.status.name,
      'is_dirty': 1,
      'json_data': jsonEncode(visit.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<VisitDto>> getVisits() async {
    if (!PlatformCapabilities.supportsLocalDatabase) return [];
    final db = await _dbHelper.database;
    final maps = await db.query('visits', orderBy: 'check_in_time DESC');
    return maps.map((e) {
      final jsonStr = e['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return VisitDto.fromJson(data);
    }).toList();
  }

  @override
  Future<VisitDto?> getActiveVisit() async {
    if (!PlatformCapabilities.supportsLocalDatabase) return null;
    final db = await _dbHelper.database;
    final maps = await db.query(
      'visits',
      where: 'status = ?',
      whereArgs: ['ongoing'], // Using string match for enum name
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final jsonStr = maps.first['json_data'] as String;
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return VisitDto.fromJson(data);
  }

  @override
  Future<VisitDto?> getVisitById(String id) async {
    if (!PlatformCapabilities.supportsLocalDatabase) return null;
    final db = await _dbHelper.database;
    final maps = await db.query(
      'visits',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final jsonStr = maps.first['json_data'] as String;
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return VisitDto.fromJson(data);
  }
}
