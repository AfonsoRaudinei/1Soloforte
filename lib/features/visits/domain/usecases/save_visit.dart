import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/visit.dart';
import '../repositories/visit_repository.dart';
import '../../data/repositories/visit_repository_impl.dart';

part 'save_visit.g.dart';

class SaveVisit {
  final VisitRepository _repository;

  SaveVisit(this._repository);

  Future<void> call(Visit visit) async {
    // Business Logic can be added here (e.g. validade state)
    await _repository.saveVisit(visit);
  }
}

@riverpod
SaveVisit saveVisit(Ref ref) {
  final repository = ref.watch(visitRepositoryProvider);
  return SaveVisit(repository);
}
