import '../domain/client_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clients_repository.g.dart';

abstract class ClientsRepository {
  Future<List<Client>> getClients();
  Future<void> addClient(Client client);
  Future<void> updateClient(Client client);
  Future<void> deleteClient(String id);
}

class MockClientsRepository implements ClientsRepository {
  final List<Client> _clients = [
    Client(
      id: '1',
      name: 'João da Silva',
      email: 'joao@fazenda.com',
      phone: '(66) 99999-0000',
      cpfCnpj: '123.456.789-00',
      address: 'Sorriso - MT',
      city: 'Sorriso',
      state: 'MT',
      type: 'producer',
      status: 'active',
      lastActivity: DateTime.now().subtract(const Duration(days: 2)),
      farmIds: ['1', '2'], // Fazendas vinculadas
      notes: 'Cliente desde 2020. Produção focada em soja e milho.',
    ),
    Client(
      id: '2',
      name: 'Agropecuária Boi Gordo',
      email: 'contato@boigordo.com.br',
      phone: '(65) 3333-4444',
      cpfCnpj: '12.345.678/0001-90',
      address: 'Cuiabá - MT',
      city: 'Cuiabá',
      state: 'MT',
      type: 'producer',
      status: 'active',
      lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      farmIds: ['3'], // Fazenda vinculada
      notes: 'Grande produtor de gado de corte.',
    ),
  ];

  @override
  Future<List<Client>> getClients() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return [..._clients];
  }

  @override
  Future<void> addClient(Client client) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _clients.add(client);
  }

  @override
  Future<void> updateClient(Client client) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = client;
    }
  }

  @override
  Future<void> deleteClient(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _clients.removeWhere((c) => c.id == id);
  }
}

@Riverpod(keepAlive: true)
ClientsRepository clientsRepository(Ref ref) {
  return MockClientsRepository();
}
