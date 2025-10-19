import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/explore/domain/entities/area.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

abstract class ExploreRepository {
  Future<Either<Failure, List<Compound>>> getCompounds();
  Future<Either<Failure, List<Area>>> getAreas();
  Future<Either<Failure, List<Property>>> searchProperties({
    String? areaName,
    String? compoundName,
    String? developerName,
    int? minPrice,
    int? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
  });
  Future<Either<Failure, FilterOptions>> getFilterOptions();
}

