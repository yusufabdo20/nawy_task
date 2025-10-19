import 'package:dartz/dartz.dart';
import 'package:nawy_task/core/errors/failures.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

class GetFilterOptionsUseCase implements UseCaseNoParams<FilterOptions> {
  final ExploreRepository repository;

  const GetFilterOptionsUseCase({required this.repository});

  @override
  Future<Either<Failure, FilterOptions>> call() async {
    return await repository.getFilterOptions();
  }
}
