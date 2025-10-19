import 'package:equatable/equatable.dart';

class Compound extends Equatable {
  final int? id;
  final int? areaId;
  final int? developerId;
  final String? name;
  final String? slug;
  final DateTime? updatedAt;
  final String? imagePath;
  final int? nawyOrganizationId;
  final bool? hasOffers;
  final String? areaName;

  const Compound({
    this.id,
    this.areaId,
    this.developerId,
    this.name,
    this.slug,
    this.updatedAt,
    this.imagePath,
    this.nawyOrganizationId,
    this.hasOffers,
    this.areaName,
  });

  @override
  List<Object?> get props => [
        id,
        areaId,
        developerId,
        name,
        slug,
        updatedAt,
        imagePath,
        nawyOrganizationId,
        hasOffers,
        areaName,
      ];
}
