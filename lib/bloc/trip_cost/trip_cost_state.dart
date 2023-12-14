import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripCostState extends Equatable {
  final Exception? exception;
  const TripCostState({required this.exception});
  @override
  List<Object?> get props => [];
}

class TripCostInitial extends TripCostState {
  const TripCostInitial({required super.exception});
}

class TripCostLoadInProgress extends TripCostState {
  const TripCostLoadInProgress({required super.exception});
}

class TripCostLoaded extends TripCostState {
  final List<DatabaseCost> dataRows;

  const TripCostLoaded({required this.dataRows, required super.exception});

  @override
  List<Object?> get props => [dataRows];
}

class TripCostAddInProgress extends TripCostState {
  const TripCostAddInProgress({required super.exception});
}

class TripCostAdded extends TripCostState {
  const TripCostAdded({required super.exception});
}

class TripCostUpdateInProgress extends TripCostState {
  const TripCostUpdateInProgress({required super.exception});
}

class TripCostUpdated extends TripCostState {
  const TripCostUpdated({required super.exception});
}

class TripCostDeleteInProgress extends TripCostState {
  const TripCostDeleteInProgress({required super.exception});
}

class TripCostDeleted extends TripCostState {
  const TripCostDeleted({required super.exception});
}

class TripCostDeleteAllInProgress extends TripCostState {
  const TripCostDeleteAllInProgress({required super.exception});
}

class TripCostDeletedAll extends TripCostState {
  const TripCostDeletedAll({required super.exception});
}
