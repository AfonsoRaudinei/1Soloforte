import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import '../domain/client_model.dart';

part 'clients_repository.g.dart';

abstract class ClientsRepository {
  Future<List<Client>> getClients();
  Future<Client?> getClientById(String id);
  Future<void> addClient(Client client);
  Future<void> updateClient(Client client);
  Future<void> deleteClient(String id);
}

class SqliteClientsRepository implements ClientsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Client>> getClients() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableClients,
      orderBy: 'updated_at DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((row) {
      final jsonStr = row['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Client.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addClient(Client client) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableClients,
      _toRow(client),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateClient(Client client) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableClients,
      _toRow(client),
      where: 'id = ?',
      whereArgs: [client.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteClient(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableClients,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Client?> getClientById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableClients,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final jsonStr = maps.first['json_data'] as String;
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return Client.fromJson(data);
  }

  Map<String, Object?> _toRow(Client client) {
    return {
      'id': client.id,
      'status': client.status,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'json_data': jsonEncode(client.toJson()),
    };
  }
}

@Riverpod(keepAlive: true)
ClientsRepository clientsRepository(Ref ref) {
  return SqliteClientsRepository();
}
