import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'marketing_publication.freezed.dart';
part 'marketing_publication.g.dart';

/// Tipo de publicação de marketing
enum PublicationType {
  @JsonValue('antes_depois')
  antesDepois,
  @JsonValue('aplicacao')
  aplicacao,
  @JsonValue('resultado')
  resultado,
  @JsonValue('comparativo')
  comparativo,
  @JsonValue('case_sucesso')
  caseSucesso,
}

/// Representa uma foto associada a uma publicação
@freezed
class PublicationPhoto with _$PublicationPhoto {
  const factory PublicationPhoto({
    required String id,
    required String path,
    @Default('') String caption,
    @Default(false) bool isCover,
    @Default(0) int order,
    DateTime? createdAt,
  }) = _PublicationPhoto;

  factory PublicationPhoto.fromJson(Map<String, dynamic> json) =>
      _$PublicationPhotoFromJson(json);

  factory PublicationPhoto.create({
    required String path,
    String? caption,
    bool isCover = false,
    int order = 0,
  }) => PublicationPhoto(
    id: const Uuid().v4(),
    path: path,
    caption: caption ?? '',
    isCover: isCover,
    order: order,
    createdAt: DateTime.now(),
  );
}

/// Representa uma comparação (item dinâmico: pode ser "Antes", "Depois", "Tratamento A", etc.)
@freezed
class ComparisonEntry with _$ComparisonEntry {
  const factory ComparisonEntry({
    required String id,
    required String label,
    @Default([]) List<PublicationPhoto> photos,
    double? productivity,
    double? ndvi,
    double? biomass,
    @Default('sc/ha') String productivityUnit,
    String? notes,
    @Default(0) int order,
  }) = _ComparisonEntry;

  factory ComparisonEntry.fromJson(Map<String, dynamic> json) =>
      _$ComparisonEntryFromJson(json);

  factory ComparisonEntry.create({required String label, int order = 0}) =>
      ComparisonEntry(id: const Uuid().v4(), label: label, order: order);
}

/// Representa um pin geográfico de marketing no mapa
/// O pin é APENAS o ponto geográfico - a publicação é a entidade completa
@freezed
class MarketingPin with _$MarketingPin {
  const factory MarketingPin({
    required String id,
    required double latitude,
    required double longitude,
    required String publicationId,
    DateTime? createdAt,
  }) = _MarketingPin;

  factory MarketingPin.fromJson(Map<String, dynamic> json) =>
      _$MarketingPinFromJson(json);

  factory MarketingPin.create({
    required double latitude,
    required double longitude,
    required String publicationId,
  }) => MarketingPin(
    id: const Uuid().v4(),
    latitude: latitude,
    longitude: longitude,
    publicationId: publicationId,
    createdAt: DateTime.now(),
  );
}

/// Entidade principal: Publicação de Marketing
/// Esta é a FONTE DA VERDADE para todos os dados de uma publicação
@freezed
class MarketingPublication with _$MarketingPublication {
  const MarketingPublication._();

  const factory MarketingPublication({
    required String id,

    // Localização
    required double latitude,
    required double longitude,

    // Metadados do Case
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,
    @Default(PublicationType.caseSucesso) PublicationType type,
    String? title,
    String? description,
    String? product,
    String? campaign,
    String? harvest,

    // Vendedor/Consultor
    String? sellerName,
    String? sellerPhone,
    String? companyName,

    // Comparações Dinâmicas (fonte de verdade para "Antes e Depois")
    @Default([]) List<ComparisonEntry> comparisons,
    @Default('custom') String comparisonType,

    // Fotos gerais (não vinculadas a comparações)
    @Default([]) List<PublicationPhoto> photos,

    // Resultado/Destaque
    String? highlightMetric,
    double? highlightValue,
    @Default('sc/ha') String highlightUnit,
    @Default(true) bool showPercentage,

    // Configurações de card
    @Default('prata') String investmentLevel,
    @Default(true) bool isVisible,

    // Observações
    String? notes,

    // Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,

    // Status
    @Default('draft') String status,
  }) = _MarketingPublication;

  factory MarketingPublication.fromJson(Map<String, dynamic> json) =>
      _$MarketingPublicationFromJson(json);

  /// Cria uma nova publicação com dados mínimos
  factory MarketingPublication.create({
    required double latitude,
    required double longitude,
    PublicationType type = PublicationType.caseSucesso,
    String? clientId,
    String? areaId,
  }) {
    final now = DateTime.now();
    return MarketingPublication(
      id: const Uuid().v4(),
      latitude: latitude,
      longitude: longitude,
      type: type,
      clientId: clientId,
      areaId: areaId,
      createdAt: now,
      // Inicializa com comparações padrão "Antes" e "Depois"
      comparisons: [
        ComparisonEntry.create(label: 'Antes', order: 0),
        ComparisonEntry.create(label: 'Depois', order: 1),
      ],
      comparisonType: 'before_after',
    );
  }

  /// Verifica se a publicação tem comparações válidas
  bool get hasComparisons => comparisons.length >= 2;

  /// Verifica se tem pelo menos uma foto
  bool get hasPhotos =>
      photos.isNotEmpty || comparisons.any((c) => c.photos.isNotEmpty);

  /// Foto de capa (prioridade: foto marcada como cover > primeira foto)
  PublicationPhoto? get coverPhoto {
    // Primeiro, verificar fotos gerais
    final generalCover = photos.where((p) => p.isCover).firstOrNull;
    if (generalCover != null) return generalCover;

    // Depois, verificar fotos de comparações
    for (final comparison in comparisons) {
      final compCover = comparison.photos.where((p) => p.isCover).firstOrNull;
      if (compCover != null) return compCover;
    }

    // Fallback: primeira foto disponível
    if (photos.isNotEmpty) return photos.first;
    for (final comparison in comparisons) {
      if (comparison.photos.isNotEmpty) return comparison.photos.first;
    }

    return null;
  }

  /// Calcula o ganho de produtividade entre comparações
  double calculateProductivityGain({int indexA = 0, int indexB = 1}) {
    if (comparisons.length < 2) return 0;
    if (indexA >= comparisons.length || indexB >= comparisons.length) return 0;

    final valueA = comparisons[indexA].productivity;
    final valueB = comparisons[indexB].productivity;

    if (valueA == null || valueB == null || valueA == 0) return 0;
    return ((valueB - valueA) / valueA) * 100;
  }

  /// Label para exibição do tipo
  String get typeLabel {
    switch (type) {
      case PublicationType.antesDepois:
        return 'Antes e Depois';
      case PublicationType.aplicacao:
        return 'Aplicação';
      case PublicationType.resultado:
        return 'Resultado';
      case PublicationType.comparativo:
        return 'Comparativo';
      case PublicationType.caseSucesso:
        return 'Case de Sucesso';
    }
  }

  /// Retorna a publicação com updatedAt atualizado
  MarketingPublication touch() => copyWith(updatedAt: DateTime.now());
}
