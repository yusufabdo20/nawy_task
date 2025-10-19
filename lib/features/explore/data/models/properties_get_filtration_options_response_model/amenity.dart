import 'package:equatable/equatable.dart';

class Amenity extends Equatable {
  final int? id;
  final String? name;
  final String? imagePath;

  const Amenity({this.id, this.name, this.imagePath});

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    id: json['id'] as int?,
    name: json['name'] as String?,
    imagePath: json['image_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_path': imagePath,
  };

  @override
  List<Object?> get props => [id, name, imagePath];
}
