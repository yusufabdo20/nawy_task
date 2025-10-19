import 'package:equatable/equatable.dart';

class PropertyType extends Equatable {
  final int? id;
  final int? count;

  const PropertyType({this.id, this.count});

  factory PropertyType.fromJson(Map<String, dynamic> json) =>
      PropertyType(id: json['id'] as int?, count: json['count'] as int?);

  Map<String, dynamic> toJson() => {'id': id, 'count': count};

  @override
  List<Object?> get props => [id, count];
}
