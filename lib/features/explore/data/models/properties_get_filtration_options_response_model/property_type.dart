import 'package:equatable/equatable.dart';

import 'icon.dart';

class PropertyType extends Equatable {
  final int? id;
  final String? name;
  final Icon? icon;
  final bool? hasLandArea;
  final bool? hasMandatoryGardenArea;

  const PropertyType({
    this.id,
    this.name,
    this.icon,
    this.hasLandArea,
    this.hasMandatoryGardenArea,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
    id: json['id'] as int?,
    name: json['name'] as String?,
    icon: json['icon'] == null
        ? null
        : Icon.fromJson(json['icon'] as Map<String, dynamic>),
    hasLandArea: json['has_land_area'] as bool?,
    hasMandatoryGardenArea: json['has_mandatory_garden_area'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon?.toJson(),
    'has_land_area': hasLandArea,
    'has_mandatory_garden_area': hasMandatoryGardenArea,
  };

  @override
  List<Object?> get props {
    return [id, name, icon, hasLandArea, hasMandatoryGardenArea];
  }
}
