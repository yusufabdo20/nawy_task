import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(FavoriteItem favorite);
  Future<Either<Failure, void>> removeFavorite(String favoriteId);
  Future<Either<Failure, bool>> isFavorite(String favoriteId);
  Future<Either<Failure, void>> clearFavorites();
}
