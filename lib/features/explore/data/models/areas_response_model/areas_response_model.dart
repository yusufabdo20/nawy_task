import 'package:equatable/equatable.dart';

import 'all_slugs.dart';

class AreasResponseModel extends Equatable {
  final int? id;
  final String? name;
  final String? slug;
  final AllSlugs? allSlugs;

  const AreasResponseModel({this.id, this.name, this.slug, this.allSlugs});

  factory AreasResponseModel.fromJson(Map<String, dynamic> json) {
    return AreasResponseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      allSlugs: json['all_slugs'] == null
          ? null
          : AllSlugs.fromJson(json['all_slugs'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'all_slugs': allSlugs?.toJson(),
  };

  @override
  List<Object?> get props => [id, name, slug, allSlugs];
}
