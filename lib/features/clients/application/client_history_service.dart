import 'package:soloforte_app/features/clients/domain/client_history_model.dart';
import 'package:soloforte_app/features/clients/data/client_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ClientHistoryService {
  final ClientHistoryRepository _repository;

  ClientHistoryService(this._repository);

  Future<void> recordCall({
    required String clientId,
    required String phone,
    String? userId,
    String? duration,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'call',
      timestamp: DateTime.now(),
      description: 'Ligação telefônica realizada',
      userId: userId,
      metadata: {'phone': phone, if (duration != null) 'duration': duration},
    );

    await _repository.addHistory(history);
  }

  Future<void> recordWhatsApp({
    required String clientId,
    required String phone,
    String? userId,
    String? messageType,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'whatsapp',
      timestamp: DateTime.now(),
      description: 'Mensagem WhatsApp enviada',
      userId: userId,
      metadata: {
        'phone': phone,
        if (messageType != null) 'message_type': messageType,
      },
    );

    await _repository.addHistory(history);
  }

  Future<void> recordEmail({
    required String clientId,
    required String email,
    String? userId,
    String? subject,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'email',
      timestamp: DateTime.now(),
      description: 'Email enviado',
      userId: userId,
      metadata: {'email': email, if (subject != null) 'subject': subject},
    );

    await _repository.addHistory(history);
  }

  Future<void> recordVisit({
    required String clientId,
    required String description,
    String? userId,
    String? visitId,
    Map<String, dynamic>? additionalData,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'visit',
      timestamp: DateTime.now(),
      description: description,
      relatedId: visitId,
      userId: userId,
      metadata: additionalData,
    );

    await _repository.addHistory(history);
  }

  Future<void> recordOccurrence({
    required String clientId,
    required String description,
    String? userId,
    String? occurrenceId,
    Map<String, dynamic>? additionalData,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'occurrence',
      timestamp: DateTime.now(),
      description: description,
      relatedId: occurrenceId,
      userId: userId,
      metadata: additionalData,
    );

    await _repository.addHistory(history);
  }

  Future<void> recordReport({
    required String clientId,
    required String description,
    String? userId,
    String? reportId,
    Map<String, dynamic>? additionalData,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'report',
      timestamp: DateTime.now(),
      description: description,
      relatedId: reportId,
      userId: userId,
      metadata: additionalData,
    );

    await _repository.addHistory(history);
  }

  Future<void> recordClientCreated({
    required String clientId,
    required String clientName,
    String? userId,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'created',
      timestamp: DateTime.now(),
      description: 'Cliente "$clientName" criado',
      userId: userId,
    );

    await _repository.addHistory(history);
  }

  Future<void> recordClientUpdated({
    required String clientId,
    required String clientName,
    String? userId,
    List<String>? changedFields,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: 'updated',
      timestamp: DateTime.now(),
      description: 'Cliente "$clientName" atualizado',
      userId: userId,
      metadata: {if (changedFields != null) 'changed_fields': changedFields},
    );

    await _repository.addHistory(history);
  }

  Future<void> recordCustomAction({
    required String clientId,
    required String actionType,
    required String description,
    String? userId,
    String? relatedId,
    Map<String, dynamic>? metadata,
  }) async {
    final history = ClientHistory(
      id: const Uuid().v4(),
      clientId: clientId,
      actionType: actionType,
      timestamp: DateTime.now(),
      description: description,
      relatedId: relatedId,
      userId: userId,
      metadata: metadata,
    );

    await _repository.addHistory(history);
  }
}

// Provider
final clientHistoryServiceProvider = Provider<ClientHistoryService>((ref) {
  final repository = ref.watch(clientHistoryRepositoryProvider);
  return ClientHistoryService(repository);
});
