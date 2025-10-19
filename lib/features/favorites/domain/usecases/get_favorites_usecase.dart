import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';
import 'package:nawy_task/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCaseNoParams<List<FavoriteItem>> {
  final FavoritesRepository repository;

  const GetFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FavoriteItem>>> call() async {
    return await repository.getFavorites();
  }
}
