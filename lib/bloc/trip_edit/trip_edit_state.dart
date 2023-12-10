import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripEditState extends Equatable {
  final DatabaseTrip? trip;
  const TripEditState({
    this.trip,
  });
  @override
  List<Object?> get props => [trip?.id];
}

class TripEditInitial extends TripEditState {
  const TripEditInitial({
    super.trip,
  });
}

class TripEditLoadInProgress extends TripEditState {
  const TripEditLoadInProgress({
    super.trip,
  });
}

class TripEditLoadSuccess extends TripEditState {
  const TripEditLoadSuccess({
    super.trip,
  });
}

class TripEditLoadFailure extends TripEditState {
  const TripEditLoadFailure({
    super.trip,
  });
}

class TripEditUpdateInProgress extends TripEditState {
  const TripEditUpdateInProgress({
    super.trip,
  });
}

class TripEditUpdateSuccess extends TripEditState {
  const TripEditUpdateSuccess({
    super.trip,
  });
}

class TripEditUpdateFailure extends TripEditState {
  const TripEditUpdateFailure({
    super.trip,
  });
}

class TripEditTableSelect extends TripEditState {
  final String route;
  const TripEditTableSelect({
    required this.route,
    super.trip,
  });
}

class TripEditTableSelectFailure extends TripEditState {
  const TripEditTableSelectFailure({
    super.trip,
  });
}
