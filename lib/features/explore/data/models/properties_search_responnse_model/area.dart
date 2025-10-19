import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final int? id;
  final String? name;

  const Area({this.id, this.name});

  factory Area.fromJson(Map<String, dynamic> json) =>
      Area(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
