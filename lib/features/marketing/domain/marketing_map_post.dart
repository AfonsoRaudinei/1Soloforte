class MarketingPhoto {
  final String path;
  final String caption;
  final bool isCover;

  const MarketingPhoto({
    required this.path,
    this.caption = '',
    this.isCover = false,
  });

  MarketingPhoto copyWith({String? path, String? caption, bool? isCover}) {
    return MarketingPhoto(
      path: path ?? this.path,
      caption: caption ?? this.caption,
      isCover: isCover ?? this.isCover,
    );
  }
}

class MarketingMapPost {
  final String id;
  final double latitude;
  final double longitude;
  final String type; // 'case' ou 'side_by_side'
  final String? title;
  final String? client;
  final String? area;
  final String? notes;
  final List<MarketingPhoto> photos;
  final DateTime createdAt;

  const MarketingMapPost({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.createdAt,
    this.title,
    this.client,
    this.area,
    this.notes,
    this.photos = const [],
  });

  MarketingPhoto? get coverPhoto {
    if (photos.isEmpty) return null;
    final cover = photos.where((p) => p.isCover).toList();
    return cover.isNotEmpty ? cover.first : photos.first;
  }

  MarketingMapPost copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? type,
    String? title,
    String? client,
    String? area,
    String? notes,
    List<MarketingPhoto>? photos,
    DateTime? createdAt,
  }) {
    return MarketingMapPost(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      title: title ?? this.title,
      client: client ?? this.client,
      area: area ?? this.area,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  MarketingMapPost ensureCover() {
    if (photos.isEmpty) return this;
    if (photos.any((p) => p.isCover)) return this;
    final updated = photos
        .asMap()
        .entries
        .map(
          (entry) => entry.key == 0
              ? entry.value.copyWith(isCover: true)
              : entry.value,
        )
        .toList();
    return copyWith(photos: updated);
  }
}
