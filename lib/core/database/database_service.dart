import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/interfaces/service_interfaces.dart';
import 'database_helper.dart';

class DatabaseServiceImpl implements IDatabaseService {
  final DatabaseHelper _helper;

  DatabaseServiceImpl(this._helper);

  @override
  Future<Database> get database => _helper.database;

  @override
  Future<void> close() async {
    if (_helper.isOpen) {
      final db = await _helper.database;
      await db.close();
    }
  }

  @override
  bool get isOpen => _helper.isOpen;
}
