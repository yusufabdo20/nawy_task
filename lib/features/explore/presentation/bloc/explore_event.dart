import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class SearchPropertiesEvent extends ExploreEvent {
  final String? areaName;
  final String? compoundName;
  final String? developerName;
  final int? minPrice;
  final int? maxPrice;
  final int? minBedrooms;
  final int? maxBedrooms;

  const SearchPropertiesEvent({
    this.areaName,
    this.compoundName,
    this.developerName,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.maxBedrooms,
  });

  @override
  List<Object?> get props => [areaName, compoundName, developerName, minPrice, maxPrice, minBedrooms, maxBedrooms];
}

class GetFilterOptionsEvent extends ExploreEvent {
  const GetFilterOptionsEvent();
}

class ClearSearchEvent extends ExploreEvent {
  const ClearSearchEvent();
}
