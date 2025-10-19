import 'package:equatable/equatable.dart';

class SeoBacklink extends Equatable {
  final String? name;
  final String? slug;

  const SeoBacklink({this.name, this.slug});

  factory SeoBacklink.fromJson(Map<String, dynamic> json) =>
      SeoBacklink(name: json['name'] as String?, slug: json['slug'] as String?);

  Map<String, dynamic> toJson() => {'name': name, 'slug': slug};

  @override
  List<Object?> get props => [name, slug];
}
