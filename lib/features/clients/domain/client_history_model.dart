import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_history_model.freezed.dart';
part 'client_history_model.g.dart';

@freezed
class ClientHistory with _$ClientHistory {
  const factory ClientHistory({
    required String id,
    required String clientId,
    required String
    actionType, // 'visit', 'occurrence', 'report', 'call', 'whatsapp', 'email', 'created', 'updated'
    required DateTime timestamp,
    required String description,
    String? relatedId, // ID da visita, ocorrência, relatório, etc.
    String? userId, // Quem executou a ação
    Map<String, dynamic>? metadata, // Dados adicionais específicos da ação
  }) = _ClientHistory;

  factory ClientHistory.fromJson(Map<String, dynamic> json) =>
      _$ClientHistoryFromJson(json);
}
