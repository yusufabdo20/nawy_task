import 'package:equatable/equatable.dart';

import 'area.dart';

class CompoundsResponseModel extends Equatable {
  final int? id;
  final int? areaId;
  final int? developerId;
  final String? name;
  final String? slug;
  final DateTime? updatedAt;
  final String? imagePath;
  final int? nawyOrganizationId;
  final bool? hasOffers;
  final Area? area;

  const CompoundsResponseModel({
    this.id,
    this.areaId,
    this.developerId,
    this.name,
    this.slug,
    this.updatedAt,
    this.imagePath,
    this.nawyOrganizationId,
    this.hasOffers,
    this.area,
  });

  factory CompoundsResponseModel.fromJson(Map<String, dynamic> json) {
    return CompoundsResponseModel(
      id: json['id'] as int?,
      areaId: json['area_id'] as int?,
      developerId: json['developer_id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      imagePath: json['image_path'] as String?,
      nawyOrganizationId: json['nawy_organization_id'] as int?,
      hasOffers: json['has_offers'] as bool?,
      area: json['area'] == null
          ? null
          : Area.fromJson(json['area'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'area_id': areaId,
    'developer_id': developerId,
    'name': name,
    'slug': slug,
    'updated_at': updatedAt?.toIso8601String(),
    'image_path': imagePath,
    'nawy_organization_id': nawyOrganizationId,
    'has_offers': hasOffers,
    'area': area?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      areaId,
      developerId,
      name,
      slug,
      updatedAt,
      imagePath,
      nawyOrganizationId,
      hasOffers,
      area,
    ];
  }
}
