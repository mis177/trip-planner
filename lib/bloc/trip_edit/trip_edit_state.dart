import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripEditState extends Equatable {
  final DatabaseTrip? trip;
  final Exception? exception;
  const TripEditState({
    required this.exception,
    this.trip,
  });
  @override
  List<Object?> get props => [trip?.id];
}

class TripEditInitial extends TripEditState {
  const TripEditInitial({
    super.trip,
    required super.exception,
  });
}

class TripEditLoadInProgress extends TripEditState {
  const TripEditLoadInProgress({
    super.trip,
    required super.exception,
  });
}

class TripEditLoaded extends TripEditState {
  const TripEditLoaded({
    super.trip,
    required super.exception,
  });
}

class TripEditUpdateInProgress extends TripEditState {
  const TripEditUpdateInProgress({
    super.trip,
    required super.exception,
  });
}

class TripEditUpdated extends TripEditState {
  const TripEditUpdated({
    super.trip,
    required super.exception,
  });
}

class TripEditTableSelected extends TripEditState {
  final String route;
  const TripEditTableSelected({
    required this.route,
    super.trip,
    required super.exception,
  });
}
