import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripCostState extends Equatable {
  final bool isLoading;
  final String loadingText;
  const TripCostState(
      {this.loadingText = 'Please wait a moment', this.isLoading = false});
  @override
  List<Object?> get props => [];
}

class TripCostInitial extends TripCostState {
  const TripCostInitial({super.loadingText, super.isLoading});
}

class TripCostLoadInProgress extends TripCostState {
  const TripCostLoadInProgress({super.loadingText, super.isLoading});
}

class TripCostLoadSuccess extends TripCostState {
  final List<DatabaseCost> dataRows;

  const TripCostLoadSuccess(
      {required this.dataRows, super.isLoading, super.loadingText});

  @override
  List<Object?> get props => [dataRows];
}

class TripCostLoadFailure extends TripCostState {
  const TripCostLoadFailure({super.loadingText, super.isLoading});
}

class TripCostAddInProgress extends TripCostState {
  const TripCostAddInProgress({super.loadingText, super.isLoading});
}

class TripCostAddSuccess extends TripCostState {
  const TripCostAddSuccess({super.loadingText, super.isLoading});
}

class TripCostAddFailure extends TripCostState {
  const TripCostAddFailure({super.loadingText, super.isLoading});
}

class TripCostUpdateInProgress extends TripCostState {
  const TripCostUpdateInProgress({super.loadingText, super.isLoading});
}

class TripCostUpdateSuccess extends TripCostState {
  const TripCostUpdateSuccess({super.loadingText, super.isLoading});
}

class TripCostUpdateFailure extends TripCostState {
  const TripCostUpdateFailure({super.loadingText, super.isLoading});
}

class TripCostDeleteInProgress extends TripCostState {
  const TripCostDeleteInProgress({super.loadingText, super.isLoading});
}

class TripCostDeleteSuccess extends TripCostState {
  const TripCostDeleteSuccess({super.loadingText, super.isLoading});
}

class TripCostDeleteFailure extends TripCostState {
  const TripCostDeleteFailure({super.loadingText, super.isLoading});
}

class TripCostDeleteAllInProgress extends TripCostState {
  const TripCostDeleteAllInProgress({super.loadingText, super.isLoading});
}

class TripCostDeleteAllSuccess extends TripCostState {
  const TripCostDeleteAllSuccess({super.loadingText, super.isLoading});
}

class TripCostDeleteAllFailure extends TripCostState {
  const TripCostDeleteAllFailure({super.loadingText, super.isLoading});
}
