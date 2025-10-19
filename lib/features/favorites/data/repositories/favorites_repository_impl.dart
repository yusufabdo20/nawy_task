import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/exceptions.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';
import 'package:nawy_task/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  const FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FavoriteItem>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteItem favorite) async {
    try {
      await localDataSource.addFavorite(favorite);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String favoriteId) async {
    try {
      await localDataSource.removeFavorite(favoriteId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String favoriteId) async {
    try {
      final isFav = await localDataSource.isFavorite(favoriteId);
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites() async {
    try {
      await localDataSource.clearFavorites();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
