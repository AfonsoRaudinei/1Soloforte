import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/data/clients_repository.dart';
import 'package:soloforte_app/features/clients/domain/client_history_model.dart';
import 'package:soloforte_app/features/clients/data/client_history_repository.dart';
import 'package:soloforte_app/features/farms/domain/farm_model.dart';
import 'package:soloforte_app/features/farms/data/farms_repository.dart';

part 'client_detail_controller.g.dart';

@riverpod
Future<Client?> clientById(ClientByIdRef ref, String clientId) async {
  final clients = await ref.watch(clientsControllerProvider.future);
  try {
    return clients.firstWhere((c) => c.id == clientId);
  } catch (e) {
    return null;
  }
}

@riverpod
Future<List<Farm>> clientFarms(ClientFarmsRef ref, String clientId) async {
  return ref.watch(farmsRepositoryProvider).getFarmsByClientId(clientId);
}

@riverpod
Future<List<ClientHistory>> clientHistory(
  ClientHistoryRef ref,
  String clientId,
) async {
  return ref
      .watch(clientHistoryRepositoryProvider)
      .getHistoryByClientId(clientId);
}

// Provider para estatísticas agregadas do cliente
@riverpod
Future<ClientStats> clientStats(ClientStatsRef ref, String clientId) async {
  final farms = await ref.watch(clientFarmsProvider(clientId).future);
  final history = await ref.watch(clientHistoryProvider(clientId).future);

  // Calcular estatísticas
  final totalFarms = farms.length;
  final totalAreaHa = farms.fold<double>(
    0.0,
    (sum, farm) => sum + (farm.totalAreaHa ?? 0.0),
  );
  final totalAreas = farms.fold<int>(
    0,
    (sum, farm) => sum + (farm.totalAreas ?? 0),
  );

  // Contar tipos de ações no histórico
  final visits = history.where((h) => h.actionType == 'visit').length;
  final occurrences = history.where((h) => h.actionType == 'occurrence').length;
  final reports = history.where((h) => h.actionType == 'report').length;
  final calls = history.where((h) => h.actionType == 'call').length;
  final whatsappMessages = history
      .where((h) => h.actionType == 'whatsapp')
      .length;

  return ClientStats(
    totalFarms: totalFarms,
    totalAreaHa: totalAreaHa,
    totalAreas: totalAreas,
    totalVisits: visits,
    totalOccurrences: occurrences,
    totalReports: reports,
    totalCalls: calls,
    totalWhatsappMessages: whatsappMessages,
    totalInteractions: history.length,
  );
}

class ClientStats {
  final int totalFarms;
  final double totalAreaHa;
  final int totalAreas;
  final int totalVisits;
  final int totalOccurrences;
  final int totalReports;
  final int totalCalls;
  final int totalWhatsappMessages;
  final int totalInteractions;

  ClientStats({
    required this.totalFarms,
    required this.totalAreaHa,
    required this.totalAreas,
    required this.totalVisits,
    required this.totalOccurrences,
    required this.totalReports,
    required this.totalCalls,
    required this.totalWhatsappMessages,
    required this.totalInteractions,
  });
}
