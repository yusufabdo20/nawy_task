import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/exceptions.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/entities/area.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

class ExploreRepoImp implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  ExploreRepoImp(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Compound>>> getCompounds() async {
    try {
      final compounds = await _remoteDataSource.getCompounds();
      return Right(compounds);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Area>>> getAreas() async {
    try {
      final areas = await _remoteDataSource.getAreas();
      return Right(areas);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Property>>> searchProperties({
    String? areaName,
    String? compoundName,
    String? developerName,
    int? minPrice,
    int? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
  }) async {
    try {
      final properties = await _remoteDataSource.searchProperties(
        areaName: areaName,
        compoundName: compoundName,
        developerName: developerName,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minBedrooms: minBedrooms,
        maxBedrooms: maxBedrooms,
      );
      return Right(properties);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, FilterOptions>> getFilterOptions() async {
    try {
      final filterOptions = await _remoteDataSource.getFilterOptions();
      return Right(filterOptions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}