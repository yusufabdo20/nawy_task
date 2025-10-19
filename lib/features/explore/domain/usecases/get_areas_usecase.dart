import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/entities/area.dart';

class GetAreasUseCase implements UseCaseNoParams<List<Area>> {
  final ExploreRepository _repository;

  GetAreasUseCase(this._repository);

  @override
  Future<Either<Failure, List<Area>>> call() {
    return _repository.getAreas();
  }
}
