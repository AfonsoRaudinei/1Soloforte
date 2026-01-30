import '../entities/occurrence.dart';

abstract class OccurrenceRepository {
  Future<List<Occurrence>> getOccurrences();
  Future<Occurrence?> getOccurrenceById(String id);
  Future<void> createOccurrence(Occurrence occurrence);
  Future<void> updateOccurrence(Occurrence occurrence);
  Future<void> deleteOccurrence(String id);
  Future<List<Occurrence>> getOccurrencesByVisitId(String visitId);
}
