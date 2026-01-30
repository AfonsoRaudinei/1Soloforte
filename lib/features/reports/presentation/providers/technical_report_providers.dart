import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/technical_report_repository_impl.dart';
import '../../domain/repositories/technical_report_repository.dart';
import '../../domain/usecases/generate_report_use_case.dart';
import 'package:soloforte_app/features/visits/data/repositories/visit_repository_impl.dart';
import 'package:soloforte_app/features/occurrences/data/repositories/occurrence_repository_impl.dart';

// Repository Provider
final technicalReportRepositoryProvider = Provider<TechnicalReportRepository>((
  ref,
) {
  return TechnicalReportRepositoryImpl();
});

// Use Case Provider
final generateReportUseCaseProvider = Provider<GenerateReportUseCase>((ref) {
  final visitRepository = ref.watch(visitRepositoryProvider);
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final reportRepository = ref.watch(technicalReportRepositoryProvider);

  return GenerateReportUseCase(
    visitRepository,
    occurrenceRepository,
    reportRepository,
  );
});
