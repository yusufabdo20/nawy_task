import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawy_task/features/explore/domain/usecases/search_properties_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_filter_options_usecase.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_event.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchPropertiesUseCase _searchPropertiesUseCase;
  final GetFilterOptionsUseCase _getFilterOptionsUseCase;

  ExploreBloc(this._searchPropertiesUseCase, this._getFilterOptionsUseCase) : super(const ExploreInitial()) {
    on<SearchPropertiesEvent>(_onSearchProperties);
    on<GetFilterOptionsEvent>(_onGetFilterOptions);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchProperties(
    SearchPropertiesEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());

    final result = await _searchPropertiesUseCase(
      SearchPropertiesParams(
        areaName: event.areaName,
        compoundName: event.compoundName,
        developerName: event.developerName,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        minBedrooms: event.minBedrooms,
        maxBedrooms: event.maxBedrooms,
      ),
    );

    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (properties) {
        if (properties.isEmpty) {
          emit(const ExploreEmpty());
        } else {
          emit(ExploreLoaded(properties));
        }
      },
    );
  }

  Future<void> _onGetFilterOptions(
    GetFilterOptionsEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());

    final result = await _getFilterOptionsUseCase();

    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (filterOptions) => emit(FilterOptionsLoaded(filterOptions)),
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<ExploreState> emit,
  ) {
    emit(const ExploreInitial());
  }
}
