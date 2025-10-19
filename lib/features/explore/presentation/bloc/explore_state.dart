import 'package:equatable/equatable.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<Property> properties;
  final List<Compound> compounds;

  const ExploreLoaded(this.properties, {this.compounds = const []});

  @override
  List<Object?> get props => [properties, compounds];
}

class ExploreEmpty extends ExploreState {
  const ExploreEmpty();
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}

class FilterOptionsLoaded extends ExploreState {
  final FilterOptions filterOptions;

  const FilterOptionsLoaded(this.filterOptions);

  @override
  List<Object?> get props => [filterOptions];
}
