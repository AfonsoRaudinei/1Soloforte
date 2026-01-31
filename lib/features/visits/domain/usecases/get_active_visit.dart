import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/visit.dart';
import '../repositories/visit_repository.dart';
import '../../data/repositories/visit_repository_impl.dart'; // Import provider

part 'get_active_visit.g.dart';

class GetActiveVisit {
  final VisitRepository _repository;

  GetActiveVisit(this._repository);

  Future<Visit?> call() async {
    return _repository.getActiveVisit();
  }
}

@riverpod
GetActiveVisit getActiveVisit(Ref ref) {
  final repository = ref.watch(visitRepositoryProvider);
  return GetActiveVisit(repository);
}
