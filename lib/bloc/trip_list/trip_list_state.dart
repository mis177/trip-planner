import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripListState extends Equatable {
  final bool isLoading;
  final String loadingText;
  const TripListState(
      {this.loadingText = 'Please wait a moment', this.isLoading = false});
  @override
  List<Object?> get props => [];
}

class TripListInitial extends TripListState {
  const TripListInitial({super.loadingText, super.isLoading});
}

class TripListLoadInProgress extends TripListState {
  const TripListLoadInProgress({super.loadingText, super.isLoading});
}

class TripListLoadSuccess extends TripListState {
  final List<DatabaseTrip> allTrips;
  const TripListLoadSuccess({required this.allTrips});
}

class TripListLoadFailure extends TripListState {
  const TripListLoadFailure({super.isLoading, super.loadingText});
}

class TripListAddInProgress extends TripListState {
  const TripListAddInProgress({super.isLoading, super.loadingText});
}

class TripListAddSuccess extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListAddSuccess({
    required this.route,
    required this.trip,
    super.isLoading,
    super.loadingText,
  });
}

class TripListAddFailure extends TripListState {
  const TripListAddFailure({super.isLoading, super.loadingText});
}

class TripListRemoveInProgress extends TripListState {
  const TripListRemoveInProgress({super.isLoading, super.loadingText});
}

class TripListRemoveSuccess extends TripListState {
  const TripListRemoveSuccess({super.isLoading, super.loadingText});
}

class TripListRemoveFailure extends TripListState {
  const TripListRemoveFailure({super.isLoading, super.loadingText});
}

class TripListClicked extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListClicked({
    super.isLoading,
    super.loadingText,
    required this.route,
    required this.trip,
  });
}

class TripListClickFailure extends TripListState {
  const TripListClickFailure({super.isLoading, super.loadingText});
}
