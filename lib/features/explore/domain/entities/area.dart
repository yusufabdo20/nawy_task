import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final int? id;
  final String? name;
  final String? slug;

  const Area({
    this.id,
    this.name,
    this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}
