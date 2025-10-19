import 'package:equatable/equatable.dart';

enum FavoriteType { property, compound }

class FavoriteItem extends Equatable {
  final String id;
  final FavoriteType type;
  final String name;
  final String? imageUrl;
  final String? slug;
  final DateTime addedAt;
  final Map<String, dynamic>? metadata;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.name,
    this.imageUrl,
    this.slug,
    required this.addedAt,
    this.metadata,
  });

  factory FavoriteItem.fromProperty({
    required String propertyId,
    required String name,
    String? imageUrl,
    String? slug,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteItem(
      id: 'property_$propertyId',
      type: FavoriteType.property,
      name: name,
      imageUrl: imageUrl,
      slug: slug,
      addedAt: DateTime.now(),
      metadata: metadata,
    );
  }

  factory FavoriteItem.fromCompound({
    required String compoundId,
    required String name,
    String? imageUrl,
    String? slug,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteItem(
      id: 'compound_$compoundId',
      type: FavoriteType.compound,
      name: name,
      imageUrl: imageUrl,
      slug: slug,
      addedAt: DateTime.now(),
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'imageUrl': imageUrl,
      'slug': slug,
      'addedAt': addedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      type: FavoriteType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FavoriteType.property,
      ),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      slug: json['slug'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [id, type, name, imageUrl, slug, addedAt, metadata];
}
