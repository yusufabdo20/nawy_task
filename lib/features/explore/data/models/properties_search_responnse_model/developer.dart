import 'package:equatable/equatable.dart';

class Developer extends Equatable {
  final int? id;
  final String? name;
  final String? slug;
  final String? logoPath;

  const Developer({this.id, this.name, this.slug, this.logoPath});

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
    id: json['id'] as int?,
    name: json['name'] as String?,
    slug: json['slug'] as String?,
    logoPath: json['logo_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'logo_path': logoPath,
  };

  @override
  List<Object?> get props => [id, name, slug, logoPath];
}
