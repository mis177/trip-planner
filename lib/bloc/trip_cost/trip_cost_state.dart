import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripCostState extends Equatable {
  const TripCostState();
  @override
  List<Object?> get props => [];
}

class TripCostInitial extends TripCostState {
  const TripCostInitial();
}

class TripCostLoadInProgress extends TripCostState {
  const TripCostLoadInProgress();
}

class TripCostLoadSuccess extends TripCostState {
  final List<DatabaseCost> dataRows;

  const TripCostLoadSuccess({required this.dataRows});

  @override
  List<Object?> get props => [dataRows];
}

class TripCostLoadFailure extends TripCostState {
  const TripCostLoadFailure();
}

class TripCostAddInProgress extends TripCostState {
  const TripCostAddInProgress();
}

class TripCostAddSuccess extends TripCostState {
  const TripCostAddSuccess();
}

class TripCostAddFailure extends TripCostState {
  const TripCostAddFailure();
}

class TripCostUpdateInProgress extends TripCostState {
  const TripCostUpdateInProgress();
}

class TripCostUpdateSuccess extends TripCostState {
  const TripCostUpdateSuccess();
}

class TripCostUpdateFailure extends TripCostState {
  const TripCostUpdateFailure();
}

class TripCostDeleteInProgress extends TripCostState {
  const TripCostDeleteInProgress();
}

class TripCostDeleteSuccess extends TripCostState {
  const TripCostDeleteSuccess();
}

class TripCostDeleteFailure extends TripCostState {
  const TripCostDeleteFailure();
}

class TripCostDeleteAllInProgress extends TripCostState {
  const TripCostDeleteAllInProgress();
}

class TripCostDeleteAllSuccess extends TripCostState {
  const TripCostDeleteAllSuccess();
}

class TripCostDeleteAllFailure extends TripCostState {
  const TripCostDeleteAllFailure();
}
