import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soloforte_app/features/harvests/data/harvest_repository.dart';
import 'package:soloforte_app/features/harvests/domain/harvest_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class FirestoreHarvestRepository implements HarvestRepository {
  final FirebaseFirestore _firestore;

  FirestoreHarvestRepository(this._firestore);

  @override
  Future<List<Harvest>> getHarvests() async {
    try {
      final snapshot = await _firestore
          .collection('harvests')
          .orderBy('plantedDate', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Robustly handle Timestamps
        if (data['plantedDate'] is Timestamp) {
          data['plantedDate'] = (data['plantedDate'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        if (data['harvestDate'] is Timestamp) {
          data['harvestDate'] = (data['harvestDate'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        return Harvest.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      LoggerService.e('Error fetching harvests', error: e, tag: 'HARVESTS');
      return [];
    }
  }

  @override
  Future<Harvest?> getHarvestById(String id) async {
    try {
      final doc = await _firestore.collection('harvests').doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        // Robustly handle Timestamps
        if (data['plantedDate'] is Timestamp) {
          data['plantedDate'] = (data['plantedDate'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        if (data['harvestDate'] is Timestamp) {
          data['harvestDate'] = (data['harvestDate'] as Timestamp)
              .toDate()
              .toIso8601String();
        }
        return Harvest.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      LoggerService.e('Error fetching harvest $id', error: e, tag: 'HARVESTS');
      return null;
    }
  }

  @override
  Future<void> saveHarvest(Harvest harvest) async {
    if (harvest.id.isNotEmpty) {
      await _firestore
          .collection('harvests')
          .doc(harvest.id)
          .set(harvest.toJson());
    } else {
      await _firestore.collection('harvests').add(harvest.toJson());
    }
  }
}

// Provider
final harvestRepositoryProvider = Provider<HarvestRepository>((ref) {
  return FirestoreHarvestRepository(FirebaseFirestore.instance);
});
