import 'package:nawy_task/features/explore/domain/entities/area.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

abstract class ExploreRemoteDataSource {
  Future<List<Compound>> getCompounds();
  Future<List<Area>> getAreas();
  Future<List<Property>> searchProperties({
    String? areaName,
    String? compoundName,
    String? developerName,
    int? minPrice,
    int? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
  });
  Future<FilterOptions> getFilterOptions();
}
