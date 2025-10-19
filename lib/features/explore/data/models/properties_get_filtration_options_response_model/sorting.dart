import 'package:equatable/equatable.dart';

class Sorting extends Equatable {
  final String? key;
  final String? value;
  final String? direction;

  const Sorting({this.key, this.value, this.direction});

  factory Sorting.fromJson(Map<String, dynamic> json) => Sorting(
    key: json['key'] as String?,
    value: json['value'] as String?,
    direction: json['direction'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
    'direction': direction,
  };

  @override
  List<Object?> get props => [key, value, direction];
}
