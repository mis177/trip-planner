import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

abstract class TripListState extends Equatable {
  final List<DatabaseTrip> allTrips;
  final Exception? exception;
  const TripListState({this.allTrips = const [], required this.exception});
  @override
  List<Object?> get props => [];
}

class TripListInitial extends TripListState {
  const TripListInitial({super.allTrips, required super.exception});
}

class TripListLoadInProgress extends TripListState {
  const TripListLoadInProgress({super.allTrips, required super.exception});
}

class TripListLoaded extends TripListState {
  const TripListLoaded({super.allTrips, required super.exception});
}

class TripListAddInProgress extends TripListState {
  const TripListAddInProgress({super.allTrips, required super.exception});
}

class TripListAdded extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListAdded({
    required this.route,
    required this.trip,
    super.allTrips,
    required super.exception,
  });
}

class TripListRemoveInProgress extends TripListState {
  const TripListRemoveInProgress({super.allTrips, required super.exception});
}

class TripListRemoved extends TripListState {
  const TripListRemoved({super.allTrips, required super.exception});
}

class TripListClicked extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListClicked({
    required this.route,
    required this.trip,
    super.allTrips,
    required super.exception,
  });
}
