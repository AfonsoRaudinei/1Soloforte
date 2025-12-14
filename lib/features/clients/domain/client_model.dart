import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class Client with _$Client {
  const Client._();

  const factory Client({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? cpfCnpj,
    required String address,
    required String city,
    required String state,
    required String type, // 'producer', 'consultant'
    required String status, // 'active', 'inactive'
    required DateTime lastActivity,
    String? avatarUrl,
    String? notes,
    @Default([]) List<String> farmIds, // IDs das fazendas vinculadas
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  // Computed getters - serão calculados baseado nas fazendas
  // Por enquanto retornam valores padrão, serão implementados com a integração
  int get totalFarms => farmIds.length;

  // Estes valores virão da agregação das fazendas
  // Por enquanto mantemos compatibilidade com código existente
  int get totalAreas => 0; // TODO: Calcular das fazendas
  double get totalHectares => 0.0; // TODO: Calcular das fazendas

  // Helper para obter iniciais do nome para avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  // Helper para verificar se é produtor
  bool get isProducer => type == 'producer';

  // Helper para verificar se está ativo
  bool get isActive => status == 'active';
}
