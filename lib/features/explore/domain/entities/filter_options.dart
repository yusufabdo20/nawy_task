import 'package:equatable/equatable.dart';

class FilterOptions extends Equatable {
  final int? minPrice;
  final int? maxPrice;
  final List<int>? priceList;
  final List<int>? minPriceList;
  final List<int>? maxPriceList;
  final int? minBedrooms;
  final int? maxBedrooms;
  final int? minBathrooms;
  final int? maxBathrooms;
  final int? minUnitArea;
  final int? maxUnitArea;
  final List<String>? propertyTypes;
  final List<String>? finishings;

  const FilterOptions({
    this.minPrice,
    this.maxPrice,
    this.priceList,
    this.minPriceList,
    this.maxPriceList,
    this.minBedrooms,
    this.maxBedrooms,
    this.minBathrooms,
    this.maxBathrooms,
    this.minUnitArea,
    this.maxUnitArea,
    this.propertyTypes,
    this.finishings,
  });

  @override
  List<Object?> get props => [
        minPrice,
        maxPrice,
        priceList,
        minPriceList,
        maxPriceList,
        minBedrooms,
        maxBedrooms,
        minBathrooms,
        maxBathrooms,
        minUnitArea,
        maxUnitArea,
        propertyTypes,
        finishings,
      ];
}
