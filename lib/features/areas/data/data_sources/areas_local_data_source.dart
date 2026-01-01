import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import '../dtos/area_dto.dart';
import 'package:latlong2/latlong.dart';

abstract class AreasLocalDataSource {
  Future<void> saveArea(AreaDto area);
  Future<List<AreaDto>> getAreas();
  Future<AreaDto?> getAreaById(String id);
}

class AreasLocalDataSourceImpl implements AreasLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> saveArea(AreaDto area) async {
    if (kIsWeb) return;
    final db = await _dbHelper.database;
    await db.insert('areas', {
      'id': area.id,
      'name': area.name,
      'status': area.status,
      'is_dirty': 1,
      'json_data': jsonEncode(area.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<AreaDto>> getAreas() async {
    if (kIsWeb) return _getMockAreas();

    final db = await _dbHelper.database;
    final maps = await db.query('areas');

    if (maps.isEmpty) {
      final mocks = _getMockAreas();
      for (var area in mocks) {
        await saveArea(area);
      }
      return mocks;
    }

    return maps.map((e) {
      final jsonStr = e['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AreaDto.fromJson(data);
    }).toList();
  }

  @override
  Future<AreaDto?> getAreaById(String id) async {
    if (kIsWeb) {
      return _getMockAreas().firstWhere(
        (e) => e.id == id,
        orElse: () => _getMockAreas().first,
      );
    }
    final db = await _dbHelper.database;
    final maps = await db.query(
      'areas',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    final jsonStr = maps.first['json_data'] as String;
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return AreaDto.fromJson(data);
  }

  List<AreaDto> _getMockAreas() {
    return [
      AreaDto(
        id: '1',
        name: 'Talhão Norte',
        hectares: 45.5,
        clienteNome: 'João Silva',
        fazendaNome: 'Fazenda Esperança',
        status: 'active',
        culture: 'Soja',
        safra: '2024/2025',
        ndviAverage: 0.72,
        coordinates: [
          const LatLng(-23.5505, -46.6333),
          const LatLng(-23.5515, -46.6333),
          const LatLng(-23.5515, -46.6343),
          const LatLng(-23.5505, -46.6343),
        ],
        lastUpdate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      AreaDto(
        id: '2',
        name: 'Talhão Sul',
        hectares: 32.8,
        clienteNome: 'João Silva',
        fazendaNome: 'Fazenda Esperança',
        status: 'monitoring',
        culture: 'Milho',
        safra: '2024/2025',
        ndviAverage: 0.58,
        coordinates: [
          const LatLng(-23.5525, -46.6333),
          const LatLng(-23.5535, -46.6333),
          const LatLng(-23.5535, -46.6343),
          const LatLng(-23.5525, -46.6343),
        ],
        lastUpdate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      AreaDto(
        id: '3',
        name: 'Área Experimental',
        hectares: 12.3,
        clienteNome: 'Maria Santos',
        fazendaNome: 'Fazenda Vista Alegre',
        status: 'active',
        culture: 'Algodão',
        safra: '2024/2025',
        ndviAverage: 0.81,
        coordinates: [
          const LatLng(-23.5545, -46.6333),
          const LatLng(-23.5555, -46.6333),
          const LatLng(-23.5555, -46.6343),
          const LatLng(-23.5545, -46.6343),
        ],
        lastUpdate: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
