import 'package:equatable/equatable.dart';

import 'amenity.dart';
import 'property_type.dart';
import 'sorting.dart';

class PropertiesGetFiltrationOptionsResponseModel extends Equatable {
  final List<String>? finishings;
  final int? minBedrooms;
  final int? maxBedrooms;
  final int? minBathrooms;
  final int? maxBathrooms;
  final int? minUnitArea;
  final int? maxUnitArea;
  final int? minPrice;
  final int? maxPrice;
  final List<int>? priceList;
  final List<int>? minPriceList;
  final List<int>? maxPriceList;
  final int? minInstallmentYears;
  final int? maxInstallmentYears;
  final List<int>? installmentYearsList;
  final int? minDownPayment;
  final int? maxDownPayment;
  final List<int>? downPaymentList;
  final int? minInstallments;
  final int? maxInstallments;
  final List<int>? installmentsList;
  final String? maxReadyBy;
  final List<Amenity>? amenities;
  final List<dynamic>? tags;
  final List<PropertyType>? propertyTypes;
  final List<Sorting>? sortings;
  final List<String>? saleTypes;

  const PropertiesGetFiltrationOptionsResponseModel({
    this.finishings,
    this.minBedrooms,
    this.maxBedrooms,
    this.minBathrooms,
    this.maxBathrooms,
    this.minUnitArea,
    this.maxUnitArea,
    this.minPrice,
    this.maxPrice,
    this.priceList,
    this.minPriceList,
    this.maxPriceList,
    this.minInstallmentYears,
    this.maxInstallmentYears,
    this.installmentYearsList,
    this.minDownPayment,
    this.maxDownPayment,
    this.downPaymentList,
    this.minInstallments,
    this.maxInstallments,
    this.installmentsList,
    this.maxReadyBy,
    this.amenities,
    this.tags,
    this.propertyTypes,
    this.sortings,
    this.saleTypes,
  });

  factory PropertiesGetFiltrationOptionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PropertiesGetFiltrationOptionsResponseModel(
      finishings: (json['finishings'] as List<dynamic>?)?.cast<String>(),
      minBedrooms: json['min_bedrooms'] as int?,
      maxBedrooms: json['max_bedrooms'] as int?,
      minBathrooms: json['min_bathrooms'] as int?,
      maxBathrooms: json['max_bathrooms'] as int?,
      minUnitArea: json['min_unit_area'] as int?,
      maxUnitArea: json['max_unit_area'] as int?,
      minPrice: json['min_price'] as int?,
      maxPrice: json['max_price'] as int?,
      priceList: (json['price_list'] as List<dynamic>?)?.cast<int>(),
      minPriceList: (json['min_price_list'] as List<dynamic>?)?.cast<int>(),
      maxPriceList: (json['max_price_list'] as List<dynamic>?)?.cast<int>(),
      minInstallmentYears: json['min_installment_years'] as int?,
      maxInstallmentYears: json['max_installment_years'] as int?,
      installmentYearsList: (json['installment_years_list'] as List<dynamic>?)?.cast<int>(),
      minDownPayment: json['min_down_payment'] as int?,
      maxDownPayment: json['max_down_payment'] as int?,
      downPaymentList: (json['down_payment_list'] as List<dynamic>?)?.cast<int>(),
      minInstallments: json['min_installments'] as int?,
      maxInstallments: json['max_installments'] as int?,
      installmentsList: (json['installments_list'] as List<dynamic>?)?.cast<int>(),
      maxReadyBy: json['max_ready_by'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: json['tags'] as List<dynamic>?,
      propertyTypes: (json['property_types'] as List<dynamic>?)
          ?.map((e) => PropertyType.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortings: (json['sortings'] as List<dynamic>?)
          ?.map((e) => Sorting.fromJson(e as Map<String, dynamic>))
          .toList(),
      saleTypes: (json['sale_types'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'finishings': finishings,
    'min_bedrooms': minBedrooms,
    'max_bedrooms': maxBedrooms,
    'min_bathrooms': minBathrooms,
    'max_bathrooms': maxBathrooms,
    'min_unit_area': minUnitArea,
    'max_unit_area': maxUnitArea,
    'min_price': minPrice,
    'max_price': maxPrice,
    'price_list': priceList,
    'min_price_list': minPriceList,
    'max_price_list': maxPriceList,
    'min_installment_years': minInstallmentYears,
    'max_installment_years': maxInstallmentYears,
    'installment_years_list': installmentYearsList,
    'min_down_payment': minDownPayment,
    'max_down_payment': maxDownPayment,
    'down_payment_list': downPaymentList,
    'min_installments': minInstallments,
    'max_installments': maxInstallments,
    'installments_list': installmentsList,
    'max_ready_by': maxReadyBy,
    'amenities': amenities?.map((e) => e.toJson()).toList(),
    'tags': tags,
    'property_types': propertyTypes?.map((e) => e.toJson()).toList(),
    'sortings': sortings?.map((e) => e.toJson()).toList(),
    'sale_types': saleTypes,
  };

  @override
  List<Object?> get props {
    return [
      finishings,
      minBedrooms,
      maxBedrooms,
      minBathrooms,
      maxBathrooms,
      minUnitArea,
      maxUnitArea,
      minPrice,
      maxPrice,
      priceList,
      minPriceList,
      maxPriceList,
      minInstallmentYears,
      maxInstallmentYears,
      installmentYearsList,
      minDownPayment,
      maxDownPayment,
      downPaymentList,
      minInstallments,
      maxInstallments,
      installmentsList,
      maxReadyBy,
      amenities,
      tags,
      propertyTypes,
      sortings,
      saleTypes,
    ];
  }
}
