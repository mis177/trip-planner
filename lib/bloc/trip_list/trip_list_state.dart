import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripListState extends Equatable {
  final List<DatabaseTrip> allTrips;
  const TripListState({
    this.allTrips = const [],
  });
  @override
  List<Object?> get props => [];
}

class TripListInitial extends TripListState {
  const TripListInitial({super.allTrips});
}

class TripListLoadInProgress extends TripListState {
  const TripListLoadInProgress({super.allTrips});
}

class TripListLoadSuccess extends TripListState {
  const TripListLoadSuccess({super.allTrips});
}

class TripListLoadFailure extends TripListState {
  const TripListLoadFailure({super.allTrips});
}

class TripListAddInProgress extends TripListState {
  const TripListAddInProgress({super.allTrips});
}

class TripListAddSuccess extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListAddSuccess({
    required this.route,
    required this.trip,
    super.allTrips,
  });
}

class TripListAddFailure extends TripListState {
  const TripListAddFailure({super.allTrips});
}

class TripListRemoveInProgress extends TripListState {
  const TripListRemoveInProgress({super.allTrips});
}

class TripListRemoveSuccess extends TripListState {
  const TripListRemoveSuccess({super.allTrips});
}

class TripListRemoveFailure extends TripListState {
  const TripListRemoveFailure({super.allTrips});
}

class TripListClicked extends TripListState {
  final String route;
  final DatabaseTrip trip;
  const TripListClicked({
    required this.route,
    required this.trip,
    super.allTrips,
  });
}

class TripListClickFailure extends TripListState {
  const TripListClickFailure({super.allTrips});
}
