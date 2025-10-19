import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';

class SearchPropertiesUseCase implements UseCase<List<Property>, SearchPropertiesParams> {
  final ExploreRepository _repository;

  SearchPropertiesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Property>>> call(SearchPropertiesParams params) {
    return _repository.searchProperties(
      areaName: params.areaName,
      compoundName: params.compoundName,
      developerName: params.developerName,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minBedrooms: params.minBedrooms,
      maxBedrooms: params.maxBedrooms,
    );
  }
}

class SearchPropertiesParams extends Equatable {
  final String? areaName;
  final String? compoundName;
  final String? developerName;
  final int? minPrice;
  final int? maxPrice;
  final int? minBedrooms;
  final int? maxBedrooms;

  const SearchPropertiesParams({
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
