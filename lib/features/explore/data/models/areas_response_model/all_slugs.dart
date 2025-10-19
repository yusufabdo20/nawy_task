import 'package:equatable/equatable.dart';

class AllSlugs extends Equatable {
  final String? en;
  final String? ar;

  const AllSlugs({this.en, this.ar});

  factory AllSlugs.fromJson(Map<String, dynamic> json) =>
      AllSlugs(en: json['en'] as String?, ar: json['ar'] as String?);

  Map<String, dynamic> toJson() => {'en': en, 'ar': ar};

  @override
  List<Object?> get props => [en, ar];
}
