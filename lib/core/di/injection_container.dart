import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nawy_task/core/network/api_constants.dart';
import 'package:nawy_task/core/network/api_services.dart';
import 'package:nawy_task/core/network/dio_factory.dart';
import 'package:nawy_task/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:nawy_task/features/explore/data/datasources/explore_remote_datasource_impl.dart';
import 'package:nawy_task/features/explore/data/repo/explore_repo.dart';
import 'package:nawy_task/features/explore/domain/repo_imp/explore_repo_imp.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_areas_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_compounds_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/search_properties_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_filter_options_usecase.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:nawy_task/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:nawy_task/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:nawy_task/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:nawy_task/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:nawy_task/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:nawy_task/features/favorites/domain/usecases/check_favorite_usecase.dart';
import 'package:nawy_task/features/favorites/presentation/services/favorites_service.dart';
import 'package:nawy_task/core/services/theme_service.dart';
import 'package:nawy_task/core/services/language_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();

  // Core
  sl.registerLazySingleton(() => ApiService.init(
    dio: DioFactory.getDio(baseUrl: ApiConstants.apiBaseUrl),
  ));

  // Data sources
  sl.registerLazySingleton<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sharedPreferences),
  );

  // Repository
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepoImp(sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCompoundsUseCase(sl()));
  sl.registerLazySingleton(() => GetAreasUseCase(sl()));
  sl.registerLazySingleton(() => SearchPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetFilterOptionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckFavoriteUseCase(repository: sl()));

  // Services
  sl.registerLazySingleton(() => FavoritesService(
    toggleFavoriteUseCase: sl(),
    checkFavoriteUseCase: sl(),
    getFavoritesUseCase: sl(),
  ));
  sl.registerLazySingleton(() => ThemeService());
  sl.registerLazySingleton(() => LanguageService());

  // Bloc
  sl.registerFactory(() => ExploreBloc(sl(), sl()));
}
