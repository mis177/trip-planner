import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripRequirementState extends Equatable {
  const TripRequirementState();
  @override
  List<Object?> get props => [];
}

class TripRequirementInitial extends TripRequirementState {
  const TripRequirementInitial();
}

class TripRequirementLoadInProgress extends TripRequirementState {
  const TripRequirementLoadInProgress();
}

class TripRequirementLoadSuccess extends TripRequirementState {
  final List<DatabaseRequirement> dataRows;

  const TripRequirementLoadSuccess({required this.dataRows});
}

class TripRequirementLoadFailure extends TripRequirementState {
  const TripRequirementLoadFailure();
}

class TripRequirementAddInProgress extends TripRequirementState {
  const TripRequirementAddInProgress();
}

class TripRequirementAddSuccess extends TripRequirementState {
  const TripRequirementAddSuccess();
}

class TripRequirementAddFailure extends TripRequirementState {
  const TripRequirementAddFailure();
}

class TripRequirementUpdateInProgress extends TripRequirementState {
  const TripRequirementUpdateInProgress();
}

class TripRequirementUpdateSuccess extends TripRequirementState {
  const TripRequirementUpdateSuccess();
}

class TripRequirementUpdateFailure extends TripRequirementState {
  const TripRequirementUpdateFailure();
}

class TripRequirementDeleteInProgress extends TripRequirementState {
  const TripRequirementDeleteInProgress();
}

class TripRequirementDeleteSuccess extends TripRequirementState {
  const TripRequirementDeleteSuccess();
}

class TripRequirementDeleteFailure extends TripRequirementState {
  const TripRequirementDeleteFailure();
}

class TripRequirementDeleteAllInProgress extends TripRequirementState {
  const TripRequirementDeleteAllInProgress();
}

class TripRequirementDeleteAllSuccess extends TripRequirementState {
  const TripRequirementDeleteAllSuccess();
}

class TripRequirementDeleteAllFailure extends TripRequirementState {
  const TripRequirementDeleteAllFailure();
}
