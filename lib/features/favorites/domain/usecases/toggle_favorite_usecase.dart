import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';
import 'package:nawy_task/features/favorites/domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  const ToggleFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(FavoriteItem favorite) async {
    try {
      // Check if already favorite
      final isFavoriteResult = await repository.isFavorite(favorite.id);
      
      return isFavoriteResult.fold(
        (failure) => Left(failure),
        (isFavorite) async {
          if (isFavorite) {
            // Remove from favorites
            final removeResult = await repository.removeFavorite(favorite.id);
            return removeResult.fold(
              (failure) => Left(failure),
              (_) => const Right(false),
            );
          } else {
            // Add to favorites
            final addResult = await repository.addFavorite(favorite);
            return addResult.fold(
              (failure) => Left(failure),
              (_) => const Right(true),
            );
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
