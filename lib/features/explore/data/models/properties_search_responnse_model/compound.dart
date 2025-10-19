import 'package:equatable/equatable.dart';

class Compound extends Equatable {
  final int? id;
  final double? lat;
  final double? long;
  final String? name;
  final String? slug;
  final int? sponsored;
  final dynamic nawyOrganizationId;

  const Compound({
    this.id,
    this.lat,
    this.long,
    this.name,
    this.slug,
    this.sponsored,
    this.nawyOrganizationId,
  });

  factory Compound.fromJson(Map<String, dynamic> json) => Compound(
    id: json['id'] as int?,
    lat: (json['lat'] as num?)?.toDouble(),
    long: (json['long'] as num?)?.toDouble(),
    name: json['name'] as String?,
    slug: json['slug'] as String?,
    sponsored: json['sponsored'] as int?,
    nawyOrganizationId: json['nawy_organization_id'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'long': long,
    'name': name,
    'slug': slug,
    'sponsored': sponsored,
    'nawy_organization_id': nawyOrganizationId,
  };

  @override
  List<Object?> get props {
    return [id, lat, long, name, slug, sponsored, nawyOrganizationId];
  }
}
