import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';

class GetCompoundsUseCase implements UseCaseNoParams<List<Compound>> {
  final ExploreRepository _repository;

  GetCompoundsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Compound>>> call() {
    return _repository.getCompounds();
  }
}
