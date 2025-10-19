import 'package:equatable/equatable.dart';

import 'area.dart';
import 'compound.dart';
import 'developer.dart';
import 'property_type.dart';

class Value extends Equatable {
  final num? id;
  final String? slug;
  final String? name;
  final PropertyType? propertyType;
  final Compound? compound;
  final Area? area;
  final Developer? developer;
  final String? image;
  final String? finishing;
  final num? minUnitArea;
  final num? maxUnitArea;
  final num? minPrice;
  final num? maxPrice;
  final String? currency;
  final num? maxInstallmentYears;
  final String? maxInstallmentYearsMonths;
  final num? minInstallments;
  final num? minDownPayment;
  final num? numberOfBathrooms;
  final num? numberOfBedrooms;
  final String? minReadyBy;
  final num? sponsored;
  final bool? newProperty;
  final dynamic company;
  final bool? resale;
  final bool? financing;
  final String? type;
  final bool? hasOffers;
  final String? offerTitle;
  final bool? limitedTimeOffer;
  final dynamic isCash;
  final dynamic installmentType;
  final num? inQuickSearch;
  final dynamic recommended;
  final dynamic manualRanking;
  final num? completenessScore;
  final bool? favorite;
  final String? rankingType;
  final num? recommendedFinancing;
  final num? propertyRanking;
  final num? compoundRanking;
  final List<dynamic>? tags;

  const Value({
    this.id,
    this.slug,
    this.name,
    this.propertyType,
    this.compound,
    this.area,
    this.developer,
    this.image,
    this.finishing,
    this.minUnitArea,
    this.maxUnitArea,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.maxInstallmentYears,
    this.maxInstallmentYearsMonths,
    this.minInstallments,
    this.minDownPayment,
    this.numberOfBathrooms,
    this.numberOfBedrooms,
    this.minReadyBy,
    this.sponsored,
    this.newProperty,
    this.company,
    this.resale,
    this.financing,
    this.type,
    this.hasOffers,
    this.offerTitle,
    this.limitedTimeOffer,
    this.isCash,
    this.installmentType,
    this.inQuickSearch,
    this.recommended,
    this.manualRanking,
    this.completenessScore,
    this.favorite,
    this.rankingType,
    this.recommendedFinancing,
    this.propertyRanking,
    this.compoundRanking,
    this.tags,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    id: json['id'] as num?,
    slug: json['slug'] as String?,
    name: json['name'] as String?,
    propertyType: json['property_type'] == null
        ? null
        : PropertyType.fromJson(json['property_type'] as Map<String, dynamic>),
    compound: json['compound'] == null
        ? null
        : Compound.fromJson(json['compound'] as Map<String, dynamic>),
    area: json['area'] == null
        ? null
        : Area.fromJson(json['area'] as Map<String, dynamic>),
    developer: json['developer'] == null
        ? null
        : Developer.fromJson(json['developer'] as Map<String, dynamic>),
    image: json['image'] as String?,
    finishing: json['finishing'] as String?,
    minUnitArea: json['min_unit_area'] as num?,
    maxUnitArea: json['max_unit_area'] as num?,
    minPrice: (json['min_price']),
    maxPrice: (json['max_price']),
    currency: json['currency'] as String?,
    maxInstallmentYears: json['max_installment_years'] as num?,
    maxInstallmentYearsMonths: json['max_installment_years_months'] as String?,
    minInstallments: (json['min_installments']),
    minDownPayment: (json['min_down_payment']),
    numberOfBathrooms: json['number_of_bathrooms'] as num?,
    numberOfBedrooms: json['number_of_bedrooms'] as num?,
    minReadyBy: json['min_ready_by'] as String?,
    sponsored: json['sponsored'] as num?,
    newProperty: json['new_property'] as bool?,
    company: json['company'] as dynamic,
    resale: json['resale'] as bool?,
    financing: json['financing'] as bool?,
    type: json['type'] as String?,
    hasOffers: json['has_offers'] as bool?,
    offerTitle: json['offer_title'] as String?,
    limitedTimeOffer: json['limited_time_offer'] as bool?,
    isCash: json['is_cash'] as dynamic,
    installmentType: json['installment_type'] as dynamic,
    inQuickSearch: json['in_quick_search'] as num?,
    recommended: json['recommended'] as dynamic,
    manualRanking: json['manual_ranking'] as dynamic,
    completenessScore: json['completeness_score'] as num?,
    favorite: json['favorite'] as bool?,
    rankingType: json['ranking_type'] as String?,
    recommendedFinancing: json['recommended_financing'] as num?,
    propertyRanking: json['property_ranking'] as num?,
    compoundRanking: json['compound_ranking'] as num?,
    tags: json['tags'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'property_type': propertyType?.toJson(),
    'compound': compound?.toJson(),
    'area': area?.toJson(),
    'developer': developer?.toJson(),
    'image': image,
    'finishing': finishing,
    'min_unit_area': minUnitArea,
    'max_unit_area': maxUnitArea,
    'min_price': minPrice,
    'max_price': maxPrice,
    'currency': currency,
    'max_installment_years': maxInstallmentYears,
    'max_installment_years_months': maxInstallmentYearsMonths,
    'min_installments': minInstallments,
    'min_down_payment': minDownPayment,
    'number_of_bathrooms': numberOfBathrooms,
    'number_of_bedrooms': numberOfBedrooms,
    'min_ready_by': minReadyBy,
    'sponsored': sponsored,
    'new_property': newProperty,
    'company': company,
    'resale': resale,
    'financing': financing,
    'type': type,
    'has_offers': hasOffers,
    'offer_title': offerTitle,
    'limited_time_offer': limitedTimeOffer,
    'is_cash': isCash,
    'installment_type': installmentType,
    'in_quick_search': inQuickSearch,
    'recommended': recommended,
    'manual_ranking': manualRanking,
    'completeness_score': completenessScore,
    'favorite': favorite,
    'ranking_type': rankingType,
    'recommended_financing': recommendedFinancing,
    'property_ranking': propertyRanking,
    'compound_ranking': compoundRanking,
    'tags': tags,
  };

  @override
  List<Object?> get props {
    return [
      id,
      slug,
      name,
      propertyType,
      compound,
      area,
      developer,
      image,
      finishing,
      minUnitArea,
      maxUnitArea,
      minPrice,
      maxPrice,
      currency,
      maxInstallmentYears,
      maxInstallmentYearsMonths,
      minInstallments,
      minDownPayment,
      numberOfBathrooms,
      numberOfBedrooms,
      minReadyBy,
      sponsored,
      newProperty,
      company,
      resale,
      financing,
      type,
      hasOffers,
      offerTitle,
      limitedTimeOffer,
      isCash,
      installmentType,
      inQuickSearch,
      recommended,
      manualRanking,
      completenessScore,
      favorite,
      rankingType,
      recommendedFinancing,
      propertyRanking,
      compoundRanking,
      tags,
    ];
  }
}
