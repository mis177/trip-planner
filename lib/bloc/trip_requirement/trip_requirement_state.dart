import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripRequirementState extends Equatable {
  final Exception? exception;
  const TripRequirementState({required this.exception});
  @override
  List<Object?> get props => [];
}

class TripRequirementInitial extends TripRequirementState {
  const TripRequirementInitial({required super.exception});
}

class TripRequirementLoadInProgress extends TripRequirementState {
  const TripRequirementLoadInProgress({required super.exception});
}

class TripRequirementLoaded extends TripRequirementState {
  final List<DatabaseRequirement> dataRows;

  const TripRequirementLoaded(
      {required this.dataRows, required super.exception});
}

class TripRequirementAddInProgress extends TripRequirementState {
  const TripRequirementAddInProgress({required super.exception});
}

class TripRequirementAdded extends TripRequirementState {
  const TripRequirementAdded({required super.exception});
}

class TripRequirementUpdateInProgress extends TripRequirementState {
  const TripRequirementUpdateInProgress({required super.exception});
}

class TripRequirementUpdated extends TripRequirementState {
  const TripRequirementUpdated({required super.exception});
}

class TripRequirementDeleteInProgress extends TripRequirementState {
  const TripRequirementDeleteInProgress({required super.exception});
}

class TripRequirementDeleted extends TripRequirementState {
  const TripRequirementDeleted({required super.exception});
}

class TripRequirementDeleteAllInProgress extends TripRequirementState {
  const TripRequirementDeleteAllInProgress({required super.exception});
}

class TripRequirementDeletedAll extends TripRequirementState {
  const TripRequirementDeletedAll({required super.exception});
}
