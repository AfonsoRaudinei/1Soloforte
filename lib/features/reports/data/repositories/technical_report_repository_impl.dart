import 'dart:convert';
import 'package:soloforte_app/core/config/platform_capabilities.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import '../../domain/entities/technical_report.dart';
import '../../domain/repositories/technical_report_repository.dart';

class TechnicalReportRepositoryImpl implements TechnicalReportRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> saveReport(TechnicalReport report) async {
    try {
      if (!PlatformCapabilities.supportsLocalDatabase) {
        LoggerService.i('Web: Saving report mock ${report.id}');
        return;
      }

      final db = await _dbHelper.database;
      await db.insert(
        DatabaseHelper.tableTechnicalReports,
        {
          'id': report.id,
          'visit_id': report.visitId,
          'client_id': report.clientId,
          'generated_at': report.generatedAt.millisecondsSinceEpoch,
          'json_data': jsonEncode(report.toJson()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      LoggerService.i('Replaced/Inserted technical report ${report.id}');
    } catch (e, s) {
      LoggerService.e(
        'Failed to save technical report',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<TechnicalReport?> getReportByVisitId(String visitId) async {
    try {
      if (!PlatformCapabilities.supportsLocalDatabase) return null;

      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tableTechnicalReports,
        where: 'visit_id = ?',
        whereArgs: [visitId],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final jsonStr = maps.first['json_data'] as String;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return TechnicalReport.fromJson(data);
    } catch (e, s) {
      LoggerService.e(
        'Failed to get report by visitId $visitId',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
