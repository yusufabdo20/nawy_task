import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawy_task/core/usecases/usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/search_properties_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_filter_options_usecase.dart';
import 'package:nawy_task/features/explore/domain/usecases/get_compounds_usecase.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_event.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchPropertiesUseCase _searchPropertiesUseCase;
  final GetFilterOptionsUseCase _getFilterOptionsUseCase;
  final GetCompoundsUseCase _getCompoundsUseCase;

  ExploreBloc(this._searchPropertiesUseCase, this._getFilterOptionsUseCase, this._getCompoundsUseCase) : super(const ExploreInitial()) {
    on<SearchPropertiesEvent>(_onSearchProperties);
    on<GetFilterOptionsEvent>(_onGetFilterOptions);
    on<GetCompoundsEvent>(_onGetCompounds);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchProperties(
    SearchPropertiesEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());

    // Fetch both properties and compounds in parallel
    final propertiesResult = await _searchPropertiesUseCase(
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

    final compoundsResult = await _getCompoundsUseCase(NoParams());

    // Handle results
    propertiesResult.fold(
      (failure) => emit(ExploreError(failure.message)),
      (properties) {
        compoundsResult.fold(
          (failure) => emit(ExploreError(failure.message)),
          (compounds) {
            if (properties.isEmpty && compounds.isEmpty) {
              emit(const ExploreEmpty());
            } else {
              emit(ExploreLoaded(properties, compounds: compounds));
            }
          },
        );
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

  Future<void> _onGetCompounds(
    GetCompoundsEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());

    final result = await _getCompoundsUseCase(NoParams());

    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (compounds) {
        if (compounds.isEmpty) {
          emit(const ExploreEmpty());
        } else {
          emit(ExploreLoaded(const [], compounds: compounds));
        }
      },
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<ExploreState> emit,
  ) {
    emit(const ExploreInitial());
  }
}
