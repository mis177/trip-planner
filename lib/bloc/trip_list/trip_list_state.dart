import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripListState extends Equatable {
  final bool isLoading;
  final String loadingText;
  final List<DatabaseTrip> allTrips;
  const TripListState({
    this.loadingText = 'Please wait a moment',
    this.isLoading = false,
    this.allTrips = const [],
  });
  @override
  List<Object?> get props => [];
}

class TripListInitial extends TripListState {
  const TripListInitial({super.loadingText, super.isLoading, super.allTrips});
}

class TripListLoadInProgress extends TripListState {
  const TripListLoadInProgress(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListLoadSuccess extends TripListState {
  const TripListLoadSuccess(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListLoadFailure extends TripListState {
  const TripListLoadFailure(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListAddInProgress extends TripListState {
  const TripListAddInProgress(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListAddSuccess extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListAddSuccess({
    required this.route,
    required this.trip,
    super.isLoading,
    super.loadingText,
    super.allTrips,
  });
}

class TripListAddFailure extends TripListState {
  const TripListAddFailure(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListRemoveInProgress extends TripListState {
  const TripListRemoveInProgress(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListRemoveSuccess extends TripListState {
  const TripListRemoveSuccess(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListRemoveFailure extends TripListState {
  const TripListRemoveFailure(
      {super.loadingText, super.isLoading, super.allTrips});
}

class TripListClicked extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListClicked({
    super.isLoading,
    super.loadingText,
    required this.route,
    required this.trip,
    super.allTrips,
  });
}

class TripListClickFailure extends TripListState {
  const TripListClickFailure(
      {super.loadingText, super.isLoading, super.allTrips});
}
