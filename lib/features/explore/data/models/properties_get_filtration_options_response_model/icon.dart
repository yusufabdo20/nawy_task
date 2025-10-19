import 'package:equatable/equatable.dart';

class Icon extends Equatable {
  final String? url;

  const Icon({this.url});

  factory Icon.fromJson(Map<String, dynamic> json) =>
      Icon(url: json['url'] as String?);

  Map<String, dynamic> toJson() => {'url': url};

  @override
  List<Object?> get props => [url];
}
