import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/features/areas/domain/area_model.dart';

class AreasRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> saveArea(Area area) async {
    if (area.clientId.isEmpty) {
      throw StateError('clientId obrigatório para salvar área.');
    }
    final db = await _dbHelper.database;
    await db.insert('areas', {
      'id': area.id,
      'name': area.name,
      'status': area.status,
      'is_dirty': 1,
      'json_data': jsonEncode(area.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Area>> getAreas() async {
    final db = await _dbHelper.database;
    final maps = await db.query('areas');

    if (maps.isEmpty) {
      // Seed mock data if empty for dev purposes
      final mocks = _getMockAreas();
      for (var area in mocks) {
        await saveArea(area);
      }
      return mocks;
    }

    return maps.map((e) {
      final jsonStr = e['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Area.fromJson(data);
    }).toList();
  }

  // Mock data preserved for seed
  List<Area> _getMockAreas() {
    return [
      Area(
        id: '1',
        name: 'Talhão Norte',
        hectares: 45.5,
        clientId: 'client_1',
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
      Area(
        id: '2',
        name: 'Talhão Sul',
        hectares: 32.8,
        clientId: 'client_1',
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
      Area(
        id: '3',
        name: 'Área Experimental',
        hectares: 12.3,
        clientId: 'client_2',
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
