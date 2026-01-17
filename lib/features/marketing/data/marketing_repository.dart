import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:soloforte_app/core/database/database_helper.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';

abstract class MarketingRepositoryBase {
  Future<void> savePost(Post post);
  Future<void> deletePost(String id);
  Future<List<Post>> getPosts({required PostStatus status});
  Future<List<MarketingMapPost>> getMapPosts();
  Future<void> saveMapPost(MarketingMapPost post);
  Future<void> deleteMapPost(String id);
}

class MarketingRepository implements MarketingRepositoryBase {
  // Rollback flag: set false to restore in-memory behavior immediately.
  static bool usePersistentMarketingRepository = true;

  final MarketingRepositoryBase _delegate =
      usePersistentMarketingRepository
          ? PersistentMarketingRepository()
          : InMemoryMarketingRepository();

  @override
  Future<void> savePost(Post post) => _delegate.savePost(post);

  @override
  Future<void> deletePost(String id) => _delegate.deletePost(id);

  @override
  Future<List<Post>> getPosts({required PostStatus status}) =>
      _delegate.getPosts(status: status);

  @override
  Future<List<MarketingMapPost>> getMapPosts() => _delegate.getMapPosts();

  @override
  Future<void> saveMapPost(MarketingMapPost post) =>
      _delegate.saveMapPost(post);

  @override
  Future<void> deleteMapPost(String id) => _delegate.deleteMapPost(id);

  // Singleton pattern for consistency across screens
  static final MarketingRepository _instance = MarketingRepository._internal();
  factory MarketingRepository() => _instance;
  MarketingRepository._internal();
}

// InMemoryMarketingRepository (rollback)
class InMemoryMarketingRepository implements MarketingRepositoryBase {
  // Mock Data
  final List<Post> _posts = [];
  final List<MarketingMapPost> _mapPosts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> savePost(Post post) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index >= 0) {
      _posts[index] = post;
    } else {
      _posts.add(post);
    }
  }

  @override
  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _posts.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Post>> getPosts({required PostStatus status}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _posts.where((p) => p.status == status).toList();
  }

  @override
  Future<List<MarketingMapPost>> getMapPosts() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DatabaseHelper.tableMarketingPosts,
      orderBy: 'created_at DESC',
    );
    final posts = rows
        .map((row) => _mapPostFromRow(row))
        .whereType<MarketingMapPost>()
        .toList();
    _mapPosts
      ..clear()
      ..addAll(posts);
    return List<MarketingMapPost>.from(_mapPosts);
  }

  @override
  Future<void> saveMapPost(MarketingMapPost post) async {
    final db = await _dbHelper.database;
    final normalized = post.ensureCover();
    await db.insert(
      DatabaseHelper.tableMarketingPosts,
      _mapPostToRow(normalized),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final index = _mapPosts.indexWhere((p) => p.id == normalized.id);
    if (index >= 0) {
      _mapPosts[index] = normalized;
    } else {
      _mapPosts.add(normalized);
    }
  }

  @override
  Future<void> deleteMapPost(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableMarketingPosts,
      where: 'id = ?',
      whereArgs: [id],
    );
    _mapPosts.removeWhere((p) => p.id == id);
  }

  Map<String, dynamic> _mapPostToRow(MarketingMapPost post) {
    final jsonData = jsonEncode({
      'kind': 'map_post',
      'id': post.id,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'type': post.type,
      'title': post.title,
      'client': post.client,
      'area': post.area,
      'notes': post.notes,
      'investmentLevel': post.investmentLevel,
      'product': post.product,
      'productivity': post.productivity,
      'createdAt': post.createdAt.toIso8601String(),
      'photos': post.photos
          .map(
            (photo) => {
              'path': photo.path,
              'caption': photo.caption,
              'isCover': photo.isCover,
            },
          )
          .toList(),
    });

    return {
      'id': post.id,
      'created_at': post.createdAt.millisecondsSinceEpoch,
      'json_data': jsonData,
    };
  }

  MarketingMapPost? _mapPostFromRow(Map<String, dynamic> row) {
    final jsonStr = row['json_data'] as String?;
    if (jsonStr == null) return null;
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['kind'] != null && data['kind'] != 'map_post') {
        return null;
      }
      final photos = (data['photos'] as List<dynamic>? ?? [])
          .map(
            (item) => MarketingPhoto(
              path: item['path'] as String? ?? '',
              caption: item['caption'] as String? ?? '',
              isCover: item['isCover'] as bool? ?? false,
            ),
          )
          .toList();

      return MarketingMapPost(
        id: data['id'] as String? ?? row['id'] as String,
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
        type: data['type'] as String? ?? 'case',
        title: data['title'] as String?,
        client: data['client'] as String?,
        area: data['area'] as String?,
        notes: data['notes'] as String?,
        investmentLevel: data['investmentLevel'] as String?,
        product: data['product'] as String?,
        productivity: data['productivity'] as String?,
        photos: photos,
        createdAt: DateTime.parse(
          data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
      ).ensureCover();
    } catch (_) {
      return null;
    }
  }
}

class PersistentMarketingRepository implements MarketingRepositoryBase {
  final List<MarketingMapPost> _mapPosts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> savePost(Post post) async {
    final db = await _dbHelper.database;
    final jsonData = jsonEncode({
      'kind': 'post',
      ...post.toJson(),
    });
    await db.insert(
      DatabaseHelper.tableMarketingPosts,
      {
        'id': post.id,
        'created_at': post.createdAt.millisecondsSinceEpoch,
        'json_data': jsonData,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deletePost(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableMarketingPosts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Post>> getPosts({required PostStatus status}) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DatabaseHelper.tableMarketingPosts,
      orderBy: 'created_at DESC',
    );
    return rows
        .map((row) => _postFromRow(row))
        .whereType<Post>()
        .where((post) => post.status == status)
        .toList();
  }

  @override
  Future<List<MarketingMapPost>> getMapPosts() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DatabaseHelper.tableMarketingPosts,
      orderBy: 'created_at DESC',
    );
    final posts = rows
        .map((row) => _mapPostFromRow(row))
        .whereType<MarketingMapPost>()
        .toList();
    _mapPosts
      ..clear()
      ..addAll(posts);
    return List<MarketingMapPost>.from(_mapPosts);
  }

  @override
  Future<void> saveMapPost(MarketingMapPost post) async {
    final db = await _dbHelper.database;
    final normalized = post.ensureCover();
    await db.insert(
      DatabaseHelper.tableMarketingPosts,
      _mapPostToRow(normalized),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final index = _mapPosts.indexWhere((p) => p.id == normalized.id);
    if (index >= 0) {
      _mapPosts[index] = normalized;
    } else {
      _mapPosts.add(normalized);
    }
  }

  @override
  Future<void> deleteMapPost(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableMarketingPosts,
      where: 'id = ?',
      whereArgs: [id],
    );
    _mapPosts.removeWhere((p) => p.id == id);
  }

  Map<String, dynamic> _mapPostToRow(MarketingMapPost post) {
    final jsonData = jsonEncode({
      'kind': 'map_post',
      'id': post.id,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'type': post.type,
      'title': post.title,
      'client': post.client,
      'area': post.area,
      'notes': post.notes,
      'investmentLevel': post.investmentLevel,
      'product': post.product,
      'productivity': post.productivity,
      'createdAt': post.createdAt.toIso8601String(),
      'photos': post.photos
          .map(
            (photo) => {
              'path': photo.path,
              'caption': photo.caption,
              'isCover': photo.isCover,
            },
          )
          .toList(),
    });

    return {
      'id': post.id,
      'created_at': post.createdAt.millisecondsSinceEpoch,
      'json_data': jsonData,
    };
  }

  Post? _postFromRow(Map<String, dynamic> row) {
    final jsonStr = row['json_data'] as String?;
    if (jsonStr == null) return null;
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['kind'] != 'post') return null;
      return Post.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  MarketingMapPost? _mapPostFromRow(Map<String, dynamic> row) {
    final jsonStr = row['json_data'] as String?;
    if (jsonStr == null) return null;
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['kind'] != null && data['kind'] != 'map_post') {
        return null;
      }
      final photos = (data['photos'] as List<dynamic>? ?? [])
          .map(
            (item) => MarketingPhoto(
              path: item['path'] as String? ?? '',
              caption: item['caption'] as String? ?? '',
              isCover: item['isCover'] as bool? ?? false,
            ),
          )
          .toList();

      return MarketingMapPost(
        id: data['id'] as String? ?? row['id'] as String,
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
        type: data['type'] as String? ?? 'case',
        title: data['title'] as String?,
        client: data['client'] as String?,
        area: data['area'] as String?,
        notes: data['notes'] as String?,
        investmentLevel: data['investmentLevel'] as String?,
        product: data['product'] as String?,
        productivity: data['productivity'] as String?,
        photos: photos,
        createdAt: DateTime.parse(
          data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
      ).ensureCover();
    } catch (_) {
      return null;
    }
  }
}
