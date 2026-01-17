import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/features/settings/domain/entities/marketing_plan.dart';

class MarketingPlansRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<MarketingPlan> _defaultPlans() {
    return const [
      MarketingPlan(
        level: MarketingPlanLevel.bronze,
        description: '',
        price: 0,
        unit: MarketingBillingUnit.perPublication,
        isActive: true,
      ),
      MarketingPlan(
        level: MarketingPlanLevel.prata,
        description: '',
        price: 0,
        unit: MarketingBillingUnit.perPublication,
        isActive: true,
      ),
      MarketingPlan(
        level: MarketingPlanLevel.ouro,
        description: '',
        price: 0,
        unit: MarketingBillingUnit.perPublication,
        isActive: true,
      ),
    ];
  }

  Future<List<MarketingPlan>> getPlans() async {
    final db = await _dbHelper.database;
    final rows = await db.query(DatabaseHelper.tableMarketingPlans);
    if (rows.isEmpty) {
      return _defaultPlans();
    }

    final byLevel = <MarketingPlanLevel, MarketingPlan>{};
    for (final row in rows) {
      final level = _levelFromDb(row['level'] as String?);
      if (level == null) continue;
      byLevel[level] = MarketingPlan(
        level: level,
        description: (row['description'] as String?) ?? '',
        price: (row['price'] as num?)?.toDouble() ?? 0,
        unit: _unitFromDb(row['unit'] as String?) ??
            MarketingBillingUnit.perPublication,
        isActive: (row['active'] as int? ?? 0) == 1,
      );
    }

    return _defaultPlans()
        .map((plan) => byLevel[plan.level] ?? plan)
        .toList();
  }

  Future<void> savePlans(List<MarketingPlan> plans) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final plan in plans) {
      batch.insert(
        DatabaseHelper.tableMarketingPlans,
        {
          'level': _levelToDb(plan.level),
          'description': plan.description,
          'price': plan.price,
          'unit': _unitToDb(plan.unit),
          'active': plan.isActive ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  String _levelToDb(MarketingPlanLevel level) {
    switch (level) {
      case MarketingPlanLevel.bronze:
        return 'bronze';
      case MarketingPlanLevel.prata:
        return 'prata';
      case MarketingPlanLevel.ouro:
        return 'ouro';
    }
  }

  MarketingPlanLevel? _levelFromDb(String? value) {
    switch (value) {
      case 'bronze':
        return MarketingPlanLevel.bronze;
      case 'prata':
        return MarketingPlanLevel.prata;
      case 'ouro':
        return MarketingPlanLevel.ouro;
      default:
        return null;
    }
  }

  String _unitToDb(MarketingBillingUnit unit) {
    switch (unit) {
      case MarketingBillingUnit.perPublication:
        return 'por_publicacao';
      case MarketingBillingUnit.perPeriod:
        return 'por_periodo';
    }
  }

  MarketingBillingUnit? _unitFromDb(String? value) {
    switch (value) {
      case 'por_publicacao':
        return MarketingBillingUnit.perPublication;
      case 'por_periodo':
        return MarketingBillingUnit.perPeriod;
      default:
        return null;
    }
  }
}
