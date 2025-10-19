import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';

class GetCompoundsUseCase implements UseCase<List<Compound>, NoParams> {
  final ExploreRepository repository;

  const GetCompoundsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Compound>>> call(NoParams params) async {
    return await repository.getCompounds();
  }
}