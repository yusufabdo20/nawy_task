import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/features/favorites/domain/repositories/favorites_repository.dart';

class CheckFavoriteUseCase {
  final FavoritesRepository repository;

  const CheckFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String favoriteId) async {
    return await repository.isFavorite(favoriteId);
  }
}
