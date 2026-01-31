import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/occurrence.dart';
import '../../data/repositories/occurrence_repository_impl.dart';

part 'occurrence_detail_provider.g.dart';

@riverpod
Future<Occurrence?> occurrenceDetail(Ref ref, String id) async {
  final repository = ref.watch(occurrenceRepositoryProvider);
  return repository.getOccurrenceById(id);
}
