import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/clients_repository.dart';
import '../../domain/client_model.dart';

final clientsRepositoryProvider = Provider<ClientsRepository>((ref) {
  return SqliteClientsRepository();
});

final clientsProvider = FutureProvider<List<Client>>((ref) async {
  final repository = ref.watch(clientsRepositoryProvider);
  return await repository.getClients();
});
