import 'package:equatable/equatable.dart';

import 'property_type.dart';
import 'seo_backlink.dart';
import 'value.dart';

class PropertiesSearchResponnseModel extends Equatable {
  final int? totalCompounds;
  final int? totalProperties;
  final int? totalPropertyGroups;
  final List<PropertyType>? propertyTypes;
  final List<Value>? values;
  final List<SeoBacklink>? seoBacklinks;
  final String? searchTrackingMsg;

  const PropertiesSearchResponnseModel({
    this.totalCompounds,
    this.totalProperties,
    this.totalPropertyGroups,
    this.propertyTypes,
    this.values,
    this.seoBacklinks,
    this.searchTrackingMsg,
  });

  factory PropertiesSearchResponnseModel.fromJson(Map<String, dynamic> json) {
    return PropertiesSearchResponnseModel(
      totalCompounds: json['total_compounds'] as int?,
      totalProperties: json['total_properties'] as int?,
      totalPropertyGroups: json['total_property_groups'] as int?,
      propertyTypes: (json['property_types'] as List<dynamic>?)
          ?.map((e) => PropertyType.fromJson(e as Map<String, dynamic>))
          .toList(),
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => Value.fromJson(e as Map<String, dynamic>))
          .toList(),
      seoBacklinks: (json['seo_backlinks'] as List<dynamic>?)
          ?.map((e) => SeoBacklink.fromJson(e as Map<String, dynamic>))
          .toList(),
      searchTrackingMsg: json['search_tracking_msg'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_compounds': totalCompounds,
    'total_properties': totalProperties,
    'total_property_groups': totalPropertyGroups,
    'property_types': propertyTypes?.map((e) => e.toJson()).toList(),
    'values': values?.map((e) => e.toJson()).toList(),
    'seo_backlinks': seoBacklinks?.map((e) => e.toJson()).toList(),
    'search_tracking_msg': searchTrackingMsg,
  };

  @override
  List<Object?> get props {
    return [
      totalCompounds,
      totalProperties,
      totalPropertyGroups,
      propertyTypes,
      values,
      seoBacklinks,
      searchTrackingMsg,
    ];
  }
}
