import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';

/// Provider para o repositório de publicações
final marketingPublicationRepositoryProvider =
    Provider<MarketingPublicationRepository>((ref) {
      return MarketingPublicationRepository();
    });

/// Repositório para CRUD de MarketingPublication
/// Persiste publicações no SQLite local
class MarketingPublicationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Cache local para acesso rápido
  List<MarketingPublication>? _cachedPublications;

  // Singleton
  static final MarketingPublicationRepository _instance =
      MarketingPublicationRepository._internal();
  factory MarketingPublicationRepository() => _instance;
  MarketingPublicationRepository._internal();

  /// Obtém todas as publicações
  Future<List<MarketingPublication>> getAll() async {
    if (_cachedPublications != null) {
      return List.from(_cachedPublications!);
    }

    final db = await _dbHelper.database;
    final rows = await db.query(
      'marketing_publications',
      orderBy: 'created_at DESC',
    );

    _cachedPublications = rows
        .map((row) => _fromRow(row))
        .whereType<MarketingPublication>()
        .toList();

    return List.from(_cachedPublications!);
  }

  /// Obtém uma publicação pelo ID
  Future<MarketingPublication?> getById(String id) async {
    // Primeiro, verifica no cache
    if (_cachedPublications != null) {
      final cached = _cachedPublications!.where((p) => p.id == id).firstOrNull;
      if (cached != null) return cached;
    }

    final db = await _dbHelper.database;
    final rows = await db.query(
      'marketing_publications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// Cria uma nova publicação (CREATE)
  Future<MarketingPublication> create(MarketingPublication publication) async {
    final db = await _dbHelper.database;
    final row = _toRow(publication);

    await db.insert(
      'marketing_publications',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Atualiza cache
    _cachedPublications ??= [];
    _cachedPublications!.insert(0, publication);

    return publication;
  }

  /// Atualiza uma publicação existente (UPDATE)
  Future<MarketingPublication> update(MarketingPublication publication) async {
    final updated = publication.touch();
    final db = await _dbHelper.database;
    final row = _toRow(updated);

    await db.update(
      'marketing_publications',
      row,
      where: 'id = ?',
      whereArgs: [updated.id],
    );

    // Atualiza cache
    if (_cachedPublications != null) {
      final index = _cachedPublications!.indexWhere((p) => p.id == updated.id);
      if (index >= 0) {
        _cachedPublications![index] = updated;
      } else {
        _cachedPublications!.insert(0, updated);
      }
    }

    return updated;
  }

  /// Salva uma publicação (create ou update)
  Future<MarketingPublication> save(MarketingPublication publication) async {
    final existing = await getById(publication.id);
    if (existing != null) {
      return update(publication);
    }
    return create(publication);
  }

  /// Remove uma publicação (DELETE)
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;

    await db.delete('marketing_publications', where: 'id = ?', whereArgs: [id]);

    // Atualiza cache
    _cachedPublications?.removeWhere((p) => p.id == id);
  }

  /// Publica uma publicação (muda status para 'published')
  Future<MarketingPublication> publish(String id) async {
    final publication = await getById(id);
    if (publication == null) {
      throw Exception('Publication not found: $id');
    }

    final published = publication.copyWith(
      status: 'published',
      publishedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return update(published);
  }

  /// Obtém publicações por cliente
  Future<List<MarketingPublication>> getByClientId(String clientId) async {
    final all = await getAll();
    return all.where((p) => p.clientId == clientId).toList();
  }

  /// Obtém publicações por área
  Future<List<MarketingPublication>> getByAreaId(String areaId) async {
    final all = await getAll();
    return all.where((p) => p.areaId == areaId).toList();
  }

  /// Obtém publicações por status
  Future<List<MarketingPublication>> getByStatus(String status) async {
    final all = await getAll();
    return all.where((p) => p.status == status).toList();
  }

  /// Limpa o cache (forçar reload do banco)
  void clearCache() {
    _cachedPublications = null;
  }

  /// Converte uma publicação para row do banco
  Map<String, dynamic> _toRow(MarketingPublication publication) {
    // Serializa comparações
    final comparisonsJson = publication.comparisons.map((c) {
      return {
        'id': c.id,
        'label': c.label,
        'photos': c.photos
            .map(
              (p) => {
                'id': p.id,
                'path': p.path,
                'caption': p.caption,
                'isCover': p.isCover,
                'order': p.order,
                'createdAt': p.createdAt?.toIso8601String(),
              },
            )
            .toList(),
        'productivity': c.productivity,
        'ndvi': c.ndvi,
        'biomass': c.biomass,
        'productivityUnit': c.productivityUnit,
        'notes': c.notes,
        'order': c.order,
      };
    }).toList();

    // Serializa fotos gerais
    final photosJson = publication.photos.map((p) {
      return {
        'id': p.id,
        'path': p.path,
        'caption': p.caption,
        'isCover': p.isCover,
        'order': p.order,
        'createdAt': p.createdAt?.toIso8601String(),
      };
    }).toList();

    final data = {
      'id': publication.id,
      'latitude': publication.latitude,
      'longitude': publication.longitude,
      'clientId': publication.clientId,
      'clientName': publication.clientName,
      'areaId': publication.areaId,
      'areaName': publication.areaName,
      'type': publication.type.name,
      'title': publication.title,
      'description': publication.description,
      'product': publication.product,
      'campaign': publication.campaign,
      'harvest': publication.harvest,
      'sellerName': publication.sellerName,
      'sellerPhone': publication.sellerPhone,
      'companyName': publication.companyName,
      'comparisons': comparisonsJson,
      'comparisonType': publication.comparisonType,
      'photos': photosJson,
      'highlightMetric': publication.highlightMetric,
      'highlightValue': publication.highlightValue,
      'highlightUnit': publication.highlightUnit,
      'showPercentage': publication.showPercentage,
      'investmentLevel': publication.investmentLevel,
      'isVisible': publication.isVisible,
      'notes': publication.notes,
      'createdAt': publication.createdAt.toIso8601String(),
      'updatedAt': publication.updatedAt?.toIso8601String(),
      'publishedAt': publication.publishedAt?.toIso8601String(),
      'status': publication.status,
    };

    return {
      'id': publication.id,
      'created_at': publication.createdAt.millisecondsSinceEpoch,
      'json_data': jsonEncode(data),
    };
  }

  /// Converte uma row do banco para publicação
  MarketingPublication? _fromRow(Map<String, dynamic> row) {
    final jsonStr = row['json_data'] as String?;
    if (jsonStr == null) return null;

    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Deserializa comparações
      final comparisons = (data['comparisons'] as List<dynamic>? ?? []).map((
        c,
      ) {
        final photosData = c['photos'] as List<dynamic>? ?? [];
        final photos = photosData
            .map(
              (p) => PublicationPhoto(
                id: p['id'] as String? ?? '',
                path: p['path'] as String? ?? '',
                caption: p['caption'] as String? ?? '',
                isCover: p['isCover'] as bool? ?? false,
                order: p['order'] as int? ?? 0,
                createdAt: p['createdAt'] != null
                    ? DateTime.tryParse(p['createdAt'])
                    : null,
              ),
            )
            .toList();

        return ComparisonEntry(
          id: c['id'] as String? ?? '',
          label: c['label'] as String? ?? '',
          photos: photos,
          productivity: (c['productivity'] as num?)?.toDouble(),
          ndvi: (c['ndvi'] as num?)?.toDouble(),
          biomass: (c['biomass'] as num?)?.toDouble(),
          productivityUnit: c['productivityUnit'] as String? ?? 'sc/ha',
          notes: c['notes'] as String?,
          order: c['order'] as int? ?? 0,
        );
      }).toList();

      // Deserializa fotos gerais
      final photos = (data['photos'] as List<dynamic>? ?? [])
          .map(
            (p) => PublicationPhoto(
              id: p['id'] as String? ?? '',
              path: p['path'] as String? ?? '',
              caption: p['caption'] as String? ?? '',
              isCover: p['isCover'] as bool? ?? false,
              order: p['order'] as int? ?? 0,
              createdAt: p['createdAt'] != null
                  ? DateTime.tryParse(p['createdAt'])
                  : null,
            ),
          )
          .toList();

      // Parse tipo
      final typeStr = data['type'] as String? ?? 'caseSucesso';
      final type = PublicationType.values.firstWhere(
        (t) => t.name == typeStr,
        orElse: () => PublicationType.caseSucesso,
      );

      return MarketingPublication(
        id: data['id'] as String,
        latitude: (data['latitude'] as num).toDouble(),
        longitude: (data['longitude'] as num).toDouble(),
        clientId: data['clientId'] as String?,
        clientName: data['clientName'] as String?,
        areaId: data['areaId'] as String?,
        areaName: data['areaName'] as String?,
        type: type,
        title: data['title'] as String?,
        description: data['description'] as String?,
        product: data['product'] as String?,
        campaign: data['campaign'] as String?,
        harvest: data['harvest'] as String?,
        sellerName: data['sellerName'] as String?,
        sellerPhone: data['sellerPhone'] as String?,
        companyName: data['companyName'] as String?,
        comparisons: comparisons,
        comparisonType: data['comparisonType'] as String? ?? 'custom',
        photos: photos,
        highlightMetric: data['highlightMetric'] as String?,
        highlightValue: (data['highlightValue'] as num?)?.toDouble(),
        highlightUnit: data['highlightUnit'] as String? ?? 'sc/ha',
        showPercentage: data['showPercentage'] as bool? ?? true,
        investmentLevel: data['investmentLevel'] as String? ?? 'prata',
        isVisible: data['isVisible'] as bool? ?? true,
        notes: data['notes'] as String?,
        createdAt: DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] != null
            ? DateTime.tryParse(data['updatedAt'])
            : null,
        publishedAt: data['publishedAt'] != null
            ? DateTime.tryParse(data['publishedAt'])
            : null,
        status: data['status'] as String? ?? 'draft',
      );
    } catch (e) {
      print('Error parsing MarketingPublication: $e');
      return null;
    }
  }
}

/// Provider para lista de publicações (reativo)
final marketingPublicationsProvider =
    FutureProvider<List<MarketingPublication>>((ref) async {
      final repository = ref.watch(marketingPublicationRepositoryProvider);
      return repository.getAll();
    });

/// Provider para uma publicação específica
final marketingPublicationProvider =
    FutureProvider.family<MarketingPublication?, String>((ref, id) async {
      final repository = ref.watch(marketingPublicationRepositoryProvider);
      return repository.getById(id);
    });
