import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final num? id;
  final String? name;
  final String? slug;
  final String? propertyType;
  final String? deliveryYear;
  final double? price;
  final double? monthlyPayment;
  final num? paymentYears;
  final String? compound;
  final String? location;
  final num? bedrooms;
  final num? bathrooms;
  final String? area;
  final String? imageUrl;
  final String? developerName;
  final String? developerLogo;

  const Property({
    this.id,
    this.name,
    this.slug,
    this.propertyType,
    this.deliveryYear,
    this.price,
    this.monthlyPayment,
    this.paymentYears,
    this.compound,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.imageUrl,
    this.developerName,
    this.developerLogo,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        propertyType,
        deliveryYear,
        price,
        monthlyPayment,
        paymentYears,
        compound,
        location,
        bedrooms,
        bathrooms,
        area,
        imageUrl,
        developerName,
        developerLogo,
      ];
}
