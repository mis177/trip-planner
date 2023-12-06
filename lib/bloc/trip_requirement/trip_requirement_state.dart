import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripRequirementState extends Equatable {
  final bool isLoading;
  final String loadingText;
  const TripRequirementState(
      {this.loadingText = 'Please wait a moment', this.isLoading = false});
  @override
  List<Object?> get props => [];
}

class TripRequirementInitial extends TripRequirementState {
  const TripRequirementInitial({super.loadingText, super.isLoading});
}

class TripRequirementLoadInProgress extends TripRequirementState {
  const TripRequirementLoadInProgress({super.loadingText, super.isLoading});
}

class TripRequirementLoadSuccess extends TripRequirementState {
  final List<DatabaseRequirement> dataRows;

  const TripRequirementLoadSuccess(
      {required this.dataRows, super.isLoading, super.loadingText});
}

class TripRequirementLoadFailure extends TripRequirementState {
  const TripRequirementLoadFailure({super.loadingText, super.isLoading});
}

class TripRequirementAddInProgress extends TripRequirementState {
  const TripRequirementAddInProgress({super.loadingText, super.isLoading});
}

class TripRequirementAddSuccess extends TripRequirementState {
  const TripRequirementAddSuccess({super.loadingText, super.isLoading});
}

class TripRequirementAddFailure extends TripRequirementState {
  const TripRequirementAddFailure({super.loadingText, super.isLoading});
}

class TripRequirementUpdateInProgress extends TripRequirementState {
  const TripRequirementUpdateInProgress({super.loadingText, super.isLoading});
}

class TripRequirementUpdateSuccess extends TripRequirementState {
  const TripRequirementUpdateSuccess({super.loadingText, super.isLoading});
}

class TripRequirementUpdateFailure extends TripRequirementState {
  const TripRequirementUpdateFailure({super.loadingText, super.isLoading});
}

class TripRequirementDeleteInProgress extends TripRequirementState {
  const TripRequirementDeleteInProgress({super.loadingText, super.isLoading});
}

class TripRequirementDeleteSuccess extends TripRequirementState {
  const TripRequirementDeleteSuccess({super.loadingText, super.isLoading});
}

class TripRequirementDeleteFailure extends TripRequirementState {
  const TripRequirementDeleteFailure({super.loadingText, super.isLoading});
}

class TripRequirementDeleteAllInProgress extends TripRequirementState {
  const TripRequirementDeleteAllInProgress(
      {super.loadingText, super.isLoading});
}

class TripRequirementDeleteAllSuccess extends TripRequirementState {
  const TripRequirementDeleteAllSuccess({super.loadingText, super.isLoading});
}

class TripRequirementDeleteAllFailure extends TripRequirementState {
  const TripRequirementDeleteAllFailure({super.loadingText, super.isLoading});
}
