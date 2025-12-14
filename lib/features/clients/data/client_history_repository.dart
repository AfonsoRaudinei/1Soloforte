import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/client_history_model.dart';

part 'client_history_repository.g.dart';

abstract class ClientHistoryRepository {
  Future<List<ClientHistory>> getHistoryByClientId(String clientId);
  Future<void> addHistory(ClientHistory history);
  Future<void> deleteHistory(String id);
}

class MockClientHistoryRepository implements ClientHistoryRepository {
  final List<ClientHistory> _history = [
    ClientHistory(
      id: '1',
      clientId: '1',
      actionType: 'visit',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Visita técnica realizada - Inspeção de talhões',
      relatedId: 'visit_001',
      userId: 'user_001',
      metadata: {'duration': '2h30min', 'areas_visited': 3},
    ),
    ClientHistory(
      id: '2',
      clientId: '1',
      actionType: 'call',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Ligação telefônica - Agendamento de visita',
      userId: 'user_001',
      metadata: {'duration': '15min'},
    ),
    ClientHistory(
      id: '3',
      clientId: '1',
      actionType: 'occurrence',
      timestamp: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Ocorrência registrada - Praga detectada',
      relatedId: 'occurrence_001',
      userId: 'user_001',
      metadata: {'severity': 'medium', 'area': 'Talhão 3'},
    ),
    ClientHistory(
      id: '4',
      clientId: '2',
      actionType: 'whatsapp',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      description: 'Mensagem WhatsApp - Envio de relatório',
      userId: 'user_001',
      metadata: {'message_type': 'document'},
    ),
  ];

  @override
  Future<List<ClientHistory>> getHistoryByClientId(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _history.where((h) => h.clientId == clientId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> addHistory(ClientHistory history) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _history.add(history);
  }

  @override
  Future<void> deleteHistory(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _history.removeWhere((h) => h.id == id);
  }
}

@Riverpod(keepAlive: true)
ClientHistoryRepository clientHistoryRepository(
  ClientHistoryRepositoryRef ref,
) {
  return MockClientHistoryRepository();
}
