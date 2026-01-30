import '../entities/technical_report.dart';

abstract class TechnicalReportRepository {
  Future<void> saveReport(TechnicalReport report);
  Future<TechnicalReport?> getReportByVisitId(String visitId);
}
